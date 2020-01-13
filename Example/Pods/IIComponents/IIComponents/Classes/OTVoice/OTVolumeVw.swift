//
//  OTVolumeVw.swift
//  OralStunts
//
//  Created by Noah_Shan on 2018/5/22.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class OTVolumeVw: UIView {
    
    var oldValue: Int32 = 0
    
    var oldLayers: [UIView] = []
    
    let eachWidth: CGFloat = 3
    
    let disWidth: CGFloat = 2
    
    var volumeList: [Int32] = []
    
    init(frame: CGRect, fatherVw: UIView) {
        super.init(frame: frame)
        fatherVw.addSubview(self)
        createVw()
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createVw() {
        self.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.top.equalTo(5)
            make.height.equalTo(20)
        }
    }
    
    func setValue(value: Int32) {
        if value == 0 { return }
        if value == oldValue {
            if self.oldLayers.count == 0 {
                createNewVw(value)
            }
        } else {
            createNewVw(value)
        }
        oldValue = value
    }
    
    private func createNewVw(_ height: Int32) {
        let layer = UIView()
        layer.backgroundColor = APPUIConfig.cloudThemeColor
        self.addSubview(layer)
        let lastLayer = self.oldLayers.last
        if lastLayer == nil {
            layer.snp.makeConstraints { (make) in
                make.width.equalTo(eachWidth)
                make.centerY.equalToSuperview()
                make.height.equalTo(analyzeHeight(height))
                make.left.equalTo(disWidth)
            }
        } else {
            layer.snp.makeConstraints { (make) in
                make.width.equalTo(eachWidth)
                make.centerY.equalToSuperview()
                make.height.equalTo(analyzeHeight(height))
                make.left.equalTo(lastLayer!.snp.right).offset(disWidth)
            }
        }
        self.oldLayers.append(layer)
        volumeList.append(height)
    }
    
    func analyzeHeight(_ height: Int32) -> CGFloat {
        let maxVolume: CGFloat = 20
        var result = CGFloat(height) * 20 / maxVolume
        if result > 20 { result = 20 }
        return result
    }
}
