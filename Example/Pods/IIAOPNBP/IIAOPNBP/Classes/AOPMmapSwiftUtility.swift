//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPMmapSwiftUtility.swift
//
// Created by    Noah Shan on 2018/11/8
// InspurEmail   shanwzh@inspur.com
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *

import Foundation
import IISwiftBaseUti

class AOPMmapSwiftUtility: NSObject {

    static var parametersJoinedCharacter: String = "|"

    static var dateFormatStr: String = "yyyy-MM-dd HH:mm:ss"

    static var userID: String {
        return MMAPUserInfo.userID
    }

    static var userName: String {
        return MMAPUserInfo.userName
    }

    static var enterpriseID: Int32 {
        return MMAPUserInfo.enterpriseID
    }

    static var deviceType: String {
        return MMAPUserInfo.deviceType
    }

    static var osVersion: String  {
        return MMAPUserInfo.osVersion
    }

    static  var appVersion: String  {
        return MMAPUserInfo.appVersion
    }

    override init() {
        super.init()
    }

    /*
     方法此处需要添加到串行队列中-尽量是高优先级的线程
     目前统一放到主线程中即可，因为ios主线程是一个串行队列，不必担心内存映射内容覆盖问题

     filename目前规则为nsuuid.string:如果当前映射的地址空间未使用完毕，则此参数无用，继续使用空间
     如果空间不足以存储写入的内容，则使用此参数创建文件系统并映射进内存
     目前映射地址空间为  1Mb

     content为需要写入的内容：目前仅使用UTF-8编码格式
     */
    static func write2MmapFileSys(name filename: String, fileContent content: String) {

        GCDUtils.toMianThreadProgressSome {
            AOPMmapOCUtility.writeData(filename, fileContent: content, userInspurCode: initUserInfo())
        }
    }

    private static func initUserInfo()  -> String {
        return userID + parametersJoinedCharacter + userName + parametersJoinedCharacter +
            enterpriseID.description
            + parametersJoinedCharacter + deviceType +
            parametersJoinedCharacter + osVersion + parametersJoinedCharacter + appVersion
    }
}
