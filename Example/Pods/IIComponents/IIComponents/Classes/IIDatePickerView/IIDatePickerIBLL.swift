//
//  *******************************************
//  
//  IIDatePickerIBLL.swift
//  impcloud_dev
//
//  Created by Noah_Shan on 2019/5/22.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit

public protocol IIDatePickerIBLL {
    
    func initSelf(haveMinDate: Bool, each10MinsProgress: Bool, scrollDate: Date!, type: Int, endAction:@escaping (_ dateInfo: Date?) -> Void)

    func show()
}
