//
//  IIPitchFilter.swift
//  OralStunts
//
//  Created by Noah_Shan on 2018/6/26.
//  Copyright © 2018 Inspur. All rights reserved.
//

import Foundation

/// Filter-progress CLASS<sys class> & METHOD<sys method>
public class IIPitchFilter: NSObject {

    /// oc-class white list
    @objc public static var ocClassFilterArr: [String] =
    ["ChatMediaCell", "ActionForMessage", "SocketManage", "CacheForMessage"]

    /// ignore shouldn't progress classes [snapkit start...]
    @objc public static var filterArr: [String] = ["TABLESwizzing", "VCSwizzing", "ApplicitonSwizzing", "Aspect", "AOPNBPCoreManagerCenter", "GodfatherSwizzingPostnotification", "AOPNotificaitonCenter", "SnapKit", "JPush", "JPUSH", "IFly", "UMSocial", "AppDelegate", "AMap", "SD", "MJ", "OOP", "__", "Aspect", "TraverseCoreOBJC", "IIPitchFilter", "IITraverseUtility", "CleanKeychain", "WCT", "RCT", "FM", "AOPMmapOCUtility", "String", "NSDate", "AFN", "NSUUID", "SessionDelegate", "UIControl", "Connectivity", "IIPitchUtility", "IIPitchFilter"]

    /// ignore shouldn't progress methods  [mj start...]
    @objc public static var filterFunctionArr: [String] = ["init", "startServices", "cxx_destruct", "AnalyzeNetWorkWithNoti", "description", "heightForRowAt", "numberOfRowsInSection", "cellForRowAt", "didSelectRowAt", "numberOfSections", "mj", "heightForHeaderInSection", "heightForFooterInSection", "viewForHeaderInSection", "viewForFooterInSection", "didReceiveWSResponse", "getMessageDicByResponseDic", "setLocalSessions", "localSessions", "receiveMessage", "sendNotification", "aspects", "replaceSessionO", "getChannelLastMessageInDB", "deleteLocalMsgByCid", "deleteCacheMessageByCid", "getSessionInCacheByChannelId", "needToUseNewMessageTime", "getUnreadSum", "updateSessionLastMessage"]

    /// bundle name - progress swift class
    /// Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String + "."
    private static let bundleName = "imp_cloud."

    /// filter classes
    public static func filterNouseClass(className: String) -> Bool {
        // swift custom classes
        if !className.contains(bundleName) {
            for i in ocClassFilterArr {
                if i == className {
                    return true
                }
            }
            return false
        }
        for eachItem in filterArr {
            if className.contains(eachItem) {
                return false
            }
        }

        return true
    }

    /// filter methods
    public static func filterNouseFunction(funcName: String) -> Bool {
        for eachItem in filterFunctionArr {
            if funcName.contains(eachItem) {
                return false
            }
        }

        return true
    }
}
