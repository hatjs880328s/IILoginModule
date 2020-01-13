//
//  PeopleSettingTableViewCell.swift
//  FSZCItem
//
//  Created by 东正 on 15/12/28.
//  Copyright © 2015年 Mrshan. All rights reserved.
//个人中心 列表cell

import UIKit
import IIUIAndBizConfig
import SnapKit
@_exported import IISwiftBaseUti

public class CustomMoreTabVCell: UITableViewCell {
    //图片
    var titleIcon: UIImageView!
    //文字
    var titletext: UILabel!
    var sizeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleIcon = UIImageView()
        self.backgroundColor = UIColor.white
        self.addSubview(titleIcon)
        titleIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        titletext = UILabel()
        self.addSubview(titletext)
        titletext.font = APPUIConfig.uiFont(with: 16)
        titletext.snp.makeConstraints { (make) in
            make.left.equalTo(titleIcon.snp.right).offset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(-5)
            make.height.equalTo(20)
        }
        
        titletext.textColor = APPUIConfig.mainCharColor
        //titletext.textAlignment = .center
        //line
        let line = UIView()
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        line.backgroundColor = APPUIConfig.customListSepLineColor
    }
    
    /// 设置信息
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - titleInfo: title
    func setInfo(image: UIImage, titleInfo: String, tintColor: UIColor?, bgColor: UIColor) {
        self.titletext.text = titleInfo
        self.titletext.textColor = tintColor == nil ? APPUIConfig.mainCharColor : tintColor!
        self.titleIcon.image = image
        if tintColor != nil {
            self.titleIcon.tintColor = tintColor!
            self.titleIcon.setRenderImg()
        }
        self.backgroundColor = bgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
