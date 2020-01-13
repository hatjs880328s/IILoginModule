//
//  AgoraVoiceAniVw.swift
//  impcloud_dev
//
//  Created by Noah_Shan on 2018/8/21.
//  Copyright © 2018 Elliot. All rights reserved.
//

import Foundation
import UIKit

public class AgoraVoiceAniVw: UIImageView {
    
    weak var fatherVw: UIView?
    
    var aniTimer: Timer?
    
    var picNum: Int = 1
    
    var picName = "agora_voicenum"
    
    public init(frame: CGRect, fatherVw: UIView) {
        super.init(frame: frame)
        self.fatherVw = fatherVw
        createVw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createVw() {
        self.fatherVw?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.right.equalTo(self.fatherVw!.snp.right)
            make.bottom.equalTo(self.fatherVw!.snp.bottom)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
    }
    
    /// 开始动画-timer开始执行
    public func startAni() {
        self.aniTimer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(aniAction), userInfo: nil, repeats: true)
        self.backgroundColor = APPUIConfig.agoraBGGreen
    }
    
    /// 结束动画-并且设置当前view的图片为nil
    public func stopAni() {
        self.aniTimer?.invalidate()
        self.aniTimer = nil
        self.image = nil
        self.backgroundColor = UIColor.clear
    }
    
    @objc func aniAction() {
        if self.picNum >= 3 {
            self.picNum = 1
        } else {
            self.picNum += 1
        }
        self.image = UIImage(named: "\(picName)\(picNum)")
    }
}
