//
//  OTVoiceBLayer.swift
//  OralStunts
//
//  Created by Noah_Shan on 2018/5/17.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit
@_exported import IIUIAndBizConfig

/// bottom path
class OTVoiceBLayer: CAShapeLayer {
    
    override init() {
        super.init()
        self.lineWidth = 5
        self.strokeColor = APPUIConfig.cloudThemeColor.cgColor
        self.path = self.realPath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var realPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        return path
    }
    
}
