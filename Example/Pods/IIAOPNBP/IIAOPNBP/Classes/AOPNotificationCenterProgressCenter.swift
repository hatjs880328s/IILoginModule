//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPNotificationCenterProgressCenter.swift
//
// Created by    Noah Shan on 2018/3/14
// InspurEmail   shanwzh@inspur.com
// GithubAddress https://github.com/hatjs880328s
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// For the full copyright and license information, plz view the LICENSE(open source)
// File that was distributed with this source code.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
//
import UIKit
import Foundation

/// progress userinfo tool
class AOPNotificationCenterProgressCenter: NSObject {
    
    var userinfo: [AnyHashable: Any] = [: ]

    /// cache lasted ui-event
    static var lastedInfo: GodfatherEvent?
    
    init(userinfo: [AnyHashable: Any]?) {
        super.init()
        if userinfo != nil {
            self.userinfo = userinfo!
        }
    }
    
    func progressUserinfo() {}

    /// here is main-thread
    func insertIntoMemCacheList(item: GodfatherEvent) {
        if AOPNBPCoreManagerCenter.getInstance().isHaveCacheFunctions {
            // insert cache.
            AOP1LvlMemCacheV20.getInstance().addOneItemFromNotificationCenter(item: item)
        } else {
            /*
             mem cache - directly inert into mmap file sys
             step1: analyze mem cache first obj is equal to the para-item
             step2: if equals - return
             step3: otherwise - write to disk & update lasted ui-event
             */
            if item.description == AOPNotificationCenterProgressCenter.lastedInfo?.description {
                return
            } else {
                AOPNotificationCenterProgressCenter.lastedInfo = item
                AOPDiskIOProgress.getInstance().writeEventsToDisk(with: [NSUUID().uuidString: [item]])
            }
        }
        
    }
    
    func alertInfo(realInfo: GodfatherEvent) {
        @discardableResult
        func showAlert() -> Bool {
            let alert = UIAlertView(title: "AOPCore", message: realInfo.sourceName + realInfo.triggerDate.description, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return true
        }
        
        //assert(showAlert())
    }
}

class TBProgress: AOPNotificationCenterProgressCenter {
    override func progressUserinfo() {
        guard let realInfo = (super.userinfo[AOPEventType.tbselectedAction] as? TBEvent) else { return }
        self.insertIntoMemCacheList(item: realInfo)
        self.alertInfo(realInfo: realInfo)
    }
}

class VCProgress: AOPNotificationCenterProgressCenter {
    override func progressUserinfo() {
        guard let realInfo = (super.userinfo[AOPEventType.vceventAction] as? VCEvent) else { return }
        self.insertIntoMemCacheList(item: realInfo)
        self.alertInfo(realInfo: realInfo)
    }
}

class APPProgress: AOPNotificationCenterProgressCenter {
    override func progressUserinfo() {
        guard let realInfo = (super.userinfo[AOPEventType.applicationSendaction] as? SendActionEvent) else { return }
        self.insertIntoMemCacheList(item: realInfo)
        self.alertInfo(realInfo: realInfo)
    }
}

class WEBVWProgress: AOPNotificationCenterProgressCenter {
    override func progressUserinfo() {
        guard let realInfo = (super.userinfo[AOPEventType.webviewRequest] as? WebVWEvent) else { return }
        self.insertIntoMemCacheList(item: realInfo)
        self.alertInfo(realInfo: realInfo)
    }
}

/// progress tool factory
class AOPProgressCenterFactory: NSObject {
    func concreateIns(userinfo: [AnyHashable: Any]) -> AOPNotificationCenterProgressCenter {
        let eventType: String = "\(userinfo.first!.key)"
        switch eventType {
        case AOPEventType.tbselectedAction.rawValue:
            return TBProgress(userinfo: userinfo)
        case AOPEventType.applicationSendaction.rawValue:
            return APPProgress(userinfo: userinfo)
        case AOPEventType.vceventAction.rawValue:
            return VCProgress(userinfo: userinfo)
        case AOPEventType.webviewRequest.rawValue:
            return WEBVWProgress(userinfo: userinfo)
        default:
            return AOPNotificationCenterProgressCenter(userinfo: [:])
        }
    }
}
