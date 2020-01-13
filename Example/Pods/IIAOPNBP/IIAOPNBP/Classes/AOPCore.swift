//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// shanGo.swift
//
// Created by    Noah Shan on 2018/3/13
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
@_exported import IISwiftBaseUti

/*
 non-buried point(NBP) SDK : AOP layer
 collect sys event & post notification to NotificationCenter


 Note:

 1.MMAPUserInfo [require]
 2.AOPNBPCoreManagerCenter.mmapFileName [require]

 */

class GodfatherSwizzingPostnotification: NSObject {
    class func postNotification(notiName: Notification.Name, userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: notiName, object: nil, userInfo: userInfo)
    }
}

class GodfatherSwizzing: NSObject {
    
    static let sourceJoinedCharacter: String = "-"
    
    func aopFunction() {}
}

class TABLESwizzing: GodfatherSwizzing {
    /// tb-celldid-deselected
    let tbDidselectedBlock: @convention(block) (_ id: AspectInfo) -> Void = {aspectInfo in
        let event = AOPEventFilter.tbFilter(aspectInfo: aspectInfo)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().tbDidSelectedAction, userInfo: [AOPEventType.tbselectedAction: event])
    }
    
    let tbRemoveBGBlock: @convention(block) (_ id: AspectInfo) -> Void = {aspectInfo in
        if let tab = aspectInfo.instance() as? UITableView {
            tab.backgroundView = nil
        }
    }
    
    /// tab-celldeselected
    override func aopFunction() {
        do {
            try UITableView.aspect_hook(#selector(UITableView.deselectRow(at:animated:)),
                                        with: .init(rawValue:0),
                                        usingBlock: tbDidselectedBlock)
        } catch {}
    }
}

class VCSwizzing: GodfatherSwizzing {
    /// vc-viewdidappear
    let viewdidAppearBlock: @convention(block) (_ id: AspectInfo) -> Void = { aspectInfo in
        let event = AOPEventFilter.vcFilter(aspectInfo: aspectInfo, isAppear: true)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().vceventAction, userInfo: [AOPEventType.vceventAction: event])
    }
    
    /// vc-viewdiddisappear
    let viewdidDisappearBlock:@convention(block) (_ id: AspectInfo) -> Void = {aspectInfo in
        let event = AOPEventFilter.vcFilter(aspectInfo: aspectInfo, isAppear: false)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().vceventAction, userInfo: [AOPEventType.vceventAction: event])
    }
    
    /// vc-viewdidappear & diddisappear
    override func aopFunction() {
        do {
            try UIViewController.aspect_hook(#selector(UIViewController.viewDidAppear(_:)),
                                             with: .init(rawValue: 0),
                                             usingBlock: self.viewdidAppearBlock)
            try UIViewController.aspect_hook(#selector(UIViewController.viewDidDisappear(_:)),
                                             with: .init(rawValue:0),
                                             usingBlock: viewdidDisappearBlock)
        } catch {}
    }
}

class ApplicitonSwizzing: GodfatherSwizzing {
    /// application-sendAction
    let appSendActionBlock:@convention(block) (_ id: AspectInfo) -> Void = { aspectInfo in
        if let event = AOPEventFilter.appFilter(aspectInfo: aspectInfo) {
            GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().appSendActions, userInfo: [AOPEventType.applicationSendaction: event])
        }
    }
    
    /// navigation-pop(custom btn replace the sys navigationBar-backBtn)
    let navigationPopBlock:@convention(block) (_ id: AspectInfo) -> Void = { aspectInfo in
    }
    
    /// application sendaction
    override func aopFunction() {
        do {
            try UIControl.aspect_hook(#selector(UIControl.sendAction(_:to:for:)),
                                     with: .init(rawValue: 0),
                                     usingBlock: appSendActionBlock)
        } catch {}
    }
}

class WebViewSwizzing: GodfatherSwizzing {
    /// webview-loadrequest
    let appSendActionBlock:@convention(block) (_ id: AspectInfo) -> Void = { aspectInfo in
        AOPEventFilter.webviewFilter(aspectInfo: aspectInfo, resultAction: { (optionalEvents) in
            if optionalEvents != nil {
                GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().webvwRequest, userInfo: [AOPEventType.webviewRequest: optionalEvents!])
            }
        })
    }

    /// webview-loadrequest
    override func aopFunction() {
        do {
            try UIWebView.aspect_hook(#selector(UIWebView.loadRequest(_:)), with: .init(rawValue: 0), usingBlock: appSendActionBlock)
        } catch {}
    }
}

class SetGetSwizzing: GodfatherSwizzing {
    /// nsobject - get - set
    let appSendActionBlock:@convention(block) (_ id: AspectInfo) -> Void = { aspectInfo in
        AOPEventFilter.webviewFilter(aspectInfo: aspectInfo, resultAction: { (optionalEvents) in
            if optionalEvents != nil {
                GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().webvwRequest, userInfo: [AOPEventType.webviewRequest: optionalEvents!])
            }
        })
    }

    /// 处理ios - oc - 属性get处理
    override func aopFunction() {
        do {
            try NSObject.aspect_hook(#selector(NSObject.value(forKey:)), with: .init(rawValue: 0), usingBlock: appSendActionBlock)
        } catch {}
    }
}

/// each Event upload hex info[require]
public class MMAPUserInfo: NSObject {

    @objc public static var userID: String = ""//IMPUserModel.activeInstance()?.exeofidString() ?? ""

    @objc public static var userName: String = ""//IMPUserModel.activeInstance()?.userName() ?? ""

    @objc public static var enterpriseID: Int32 = 0//IMPUserModel.activeInstance()?.enterprise?.id ?? 0

    @objc public static var deviceType: String = ""//Utilities.getDeviceModel() ?? ""

    @objc public static var osVersion: String = ""//Utilities.getDeviceiOSVersion() ?? ""

    @objc public static var appVersion: String = ""//Utilities.getAPPCurrentVersion() ?? ""
}

/// aop core manager---start service here [iipitching ^ aopnbpcore]
public class AOPNBPCoreManagerCenter: NSObject {
    
    private static var shareInstance: AOPNBPCoreManagerCenter!
    
    /// aop-nbp-ut have cache ?
    public var isHaveCacheFunctions: Bool = false

    /// custom-log write flag default is false
    private var customLogWriteFlag: Bool = false
    
    private override init() {
        super.init()
    }

    /// mmap file name param[require]
    @objc public static var mmapFileName = ""//IMPUserModel.activeInstance()?.id.description ?? ""
    
    @objc public static func getInstance() -> AOPNBPCoreManagerCenter {
        if shareInstance == nil {
            shareInstance = AOPNBPCoreManagerCenter()
        }
        return shareInstance
    }
    
    /// AOP-NBP-monitor-service start  [withCache-if have cache functions]
    public func startService(_ withCache: Bool = false) {
        self.createFolder()
        self.delete3DaysOldFolders()
        self.isHaveCacheFunctions = withCache
        AOPNotificaitonCenter.getInstance()
        ApplicitonSwizzing().aopFunction()
        TABLESwizzing().aopFunction()
        VCSwizzing().aopFunction()
        //WebViewSwizzing().aopFunction()
        self.customLogWriteFlag = true
    }

    /// flag control it [custom log write]
    @objc public func writeCustomLog(event: GodfatherEvent) {
        if !self.customLogWriteFlag {
            return
        }
        AOPDiskIOProgress.getInstance().writeEventsToDisk(with: [NSUUID().uuidString: [event]])
    }
    
    /// before start service - create AOPNBP Folder - for mmap open file function
    private func createFolder() {
        let aopFileFolder = NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent("AOPNBPUTFile")
        let filemanager = FileManager()
        var isDir: ObjCBool = false
        let exist = filemanager.fileExists(atPath: aopFileFolder, isDirectory: &isDir)
        if !(isDir.boolValue && exist) {
            do {
                try filemanager.createDirectory(atPath: aopFileFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {}
        }
    }

    /// save log 3days - then delete it
    private func delete3DaysOldFolders() {
        AOPDiskIOProgressUtility().deleteLogs3DaysBefore()
    }
}
