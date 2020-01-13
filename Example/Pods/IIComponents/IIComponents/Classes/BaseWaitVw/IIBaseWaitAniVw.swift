//
//  IIBaseWaitAniVw.swift
//  impcloud_dev
//
//  Created by Noah_Shan on 2018/9/14.
//  Copyright © 2018 Elliot. All rights reserved.
//

import Foundation
import SnapKit
import IIUIAndBizConfig

public class IIBaseWaitAniVw: UIView {

    let indic = MONActivityIndicatorView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        indic.radius = 5
        indic.internalSpacing = 3
        indic.numberOfCircles = 5
        indic.duration = 1
        indic.delay = 0.4
        self.addSubview(indic)
        indic.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
        indic.startAnimating()
    }

    public func stopAni() {
        self.indic.stopAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
