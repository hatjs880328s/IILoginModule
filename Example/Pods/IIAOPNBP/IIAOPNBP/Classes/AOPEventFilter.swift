//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPEventFilter.swift
//
// Created by    Noah Shan on 2018/3/15
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

import Foundation

/*
 filter  - notificationProgressCenter use it . [collector]
 succsee - post to MEMCache Layer
 fail    - do nothing...
 */

class AOPEventFilter: NSObject {
    static let sourceJoinedCharacter: String = "-"
    
    /// tb filter
    static func tbFilter(aspectInfo: AspectInfo) -> TBEvent {
        let tbEvent = TBEvent()
        
        var sourcename = String()
        if let tb = aspectInfo.instance() as? UITableView {
            if let tbVC = tb.iiViewController() {
                let vcName = NSStringFromClass(object_getClass(tbVC)!)
                sourcename += vcName + GodfatherSwizzing.sourceJoinedCharacter
            }
            sourcename += NSStringFromClass(object_getClass(tb)!) + GodfatherSwizzing.sourceJoinedCharacter
        }
        
        if let tbIndex = aspectInfo.arguments() {
            if let index = tbIndex[0] as? IndexPath {
                tbEvent.setBaseInfo(eventSourceName: sourcename, time: Date(), index: index)
            } else {
                let innerIndex = IndexPath(item: 99, section: 99)
                tbEvent.setBaseInfo(eventSourceName: sourcename, time: Date(), index: innerIndex)
            }
        }
        return tbEvent
    }
    
    /// vc filter
    static func vcFilter(aspectInfo: AspectInfo, isAppear: Bool) -> VCEvent {
        let vcEvent = VCEvent()
        
        var sourcename = String()
        if let vc = aspectInfo.instance() as? UIViewController {
            let vcName = NSStringFromClass(object_getClass(vc)!)
            sourcename += vcName
        }
        
        vcEvent.setBaseInfo(eventSourceName: sourcename, time: Date(), type: isAppear ? VCEventType.didappear : VCEventType.diddisappear)
        return vcEvent
    }
    
    /// uicontrol-application sendAction filter
    static func appFilter(aspectInfo: AspectInfo) -> SendActionEvent? {
        let appEvent = SendActionEvent()
        var sourcename = String()
        var eventType = IIAOPControlEventType.uibutton
        let instance = aspectInfo.instance()
        if let tb = instance as? UIButton {
            if let tbVC = tb.iiViewController() {
                let vcName = NSStringFromClass(object_getClass(tbVC)!)
                sourcename += vcName + GodfatherSwizzing.sourceJoinedCharacter
            }
            sourcename += NSStringFromClass(object_getClass(tb)!) + GodfatherSwizzing.sourceJoinedCharacter
            sourcename += tb.frame.debugDescription + GodfatherSwizzing.sourceJoinedCharacter
        } else if NSStringFromClass(object_getClass(instance)!) == "_UIButtonBarButton"{
            sourcename = "UINavigationController-_UIButtonBarButton"
            eventType = .uibuttonbarbutton
        } else if (instance as? UINavigationController) != nil {
            sourcename = "UINavigationController-poptovcFunction"
            eventType = .navigationVCPop
        } else {
            sourcename = NSStringFromClass(object_getClass(instance)!)
            //return nil
        }
        appEvent.setBaseInfo(eventSourceName: sourcename, time: Date(), type: eventType)
        return appEvent
    }

    /// webview-loadrequest sendAction filter
    static func webviewFilter(aspectInfo: AspectInfo, resultAction:@escaping (_ event: WebVWEvent?) -> Void) {
//        if let arguments = (aspectInfo.arguments().first as? NSURLRequest)?.url?.absoluteString {
//            IIHTTPRequest.startRequest(showAlertInfo: false, method: IIHTTPMethod.get, url: arguments, params: nil, successAction: { (response) in
//            }, errorAction: { (errorInfo) in
//                let event = WebVWEvent()
//                event.setBaseInfo(apiName: arguments, time: Date(), milSecs: errorInfo.responseData?.count ?? 0)
//                resultAction(event)
//            })
//        }
    }
}
