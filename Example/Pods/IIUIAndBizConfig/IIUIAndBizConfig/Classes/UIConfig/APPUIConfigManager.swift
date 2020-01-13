//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// APPUIConfigManager.swift
//
// Created by    Noah Shan on 2018/7/25
// InspurEmail   shanwzh@inspur.com
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *

import Foundation
import IISwiftBaseUti
import IIBLL

/*
 对UIConfig进行管理的类
 
 1.Theme处理-主题色管理
 2.缩放比例管理-目前为1
 3.线条分割线颜色管理
 4.空白页面灰色背景管理
 
*/

public class APPUIConfigManager: NSObject {

    /// 对外暴露的切换主题执行类
    @objc public var actionForLogin: AnyClass?

    private static var instance: APPUIConfigManager!

    private var kAppSkinName = "kAppSkinName"

    private override init() {
        super.init()
    }

    @objc public static func getInstance() -> APPUIConfigManager {
        if self.instance == nil {
            self.instance = APPUIConfigManager()
        }
        return self.instance
    }
    
    /// 切换根控制器，在切换语言|主题等操作之后
    private func changeRootVc() {
        (self.actionForLogin as? LoginIBLLOC.Type)?.refreshMain()
    }

    ///初始化主题色
    @objc public func initColorTheme() {
        let schemeId: ColorSchemeTheme = ColorSchemeTheme(rawValue: self.getCurrentColorThemeId()) ?? ColorSchemeTheme.themeWhite
        let colorScheme: ColorScheme = ColorSchemeData.sharedInstance().getColorScheme(byId: schemeId)
        
        self.changeAPPUIConfigWithColorScheme(colorScheme: colorScheme)
    }

    @objc public func changeAPPUIConfigWithColorScheme(colorScheme: ColorScheme) {
        //APPUIConfig.cloudThemeColor = colorScheme.navCharColor
        IIImage.themeType = self.getCurrentColorThemeId()
        //UI3.0
        APPUIConfig.newBgColor = colorScheme.bgColor
        APPUIConfig.cloudThemeColorVersion3 = colorScheme.navColor
        APPUIConfig.navCharColor = colorScheme.navCharColor
        APPUIConfig.navRightTextColor = colorScheme.navRightTextColor
        APPUIConfig.myChatBgColor = colorScheme.myChatBgColor
        APPUIConfig.otherChatBgColor = colorScheme.otherChatBgColor
        APPUIConfig.blueThemeColor = colorScheme.blueThemeColor
        APPUIConfig.switchButtonBgColor = colorScheme.switchButtonBgColor
        APPUIConfig.useDefaultStatusBarStyle = colorScheme.useDefaultStatusBar
        APPUIConfig.tabBarTextNormalColor = colorScheme.tabBarTextNormalColor
        APPUIConfig.tabBarTextSelectedColor = colorScheme.tabBarTextSelectedColor
        APPUIConfig.bottomButtonColor = colorScheme.bottomButtonColor
        APPUIConfig.extraActionsBgColor = colorScheme.extraActionsBgColor
        APPUIConfig.appFooterWeight = colorScheme.appFooterWeight
        APPUIConfig.appLineHeaderWeight = colorScheme.appLineHeaderWeight
        APPUIConfig.appLabelHeaderWeight = colorScheme.appLabelHeaderWeight
        APPUIConfig.workNaviSubTextColor = colorScheme.workNaviSubTextColor
    }
    
    /// 主题色修改并更改rootviewcontroller
    @objc public func themeColorProgress(colorScheme: ColorScheme) {
        self.changeAPPUIConfigWithColorScheme(colorScheme: colorScheme)
        self.changeRootVc()
    }

    /// 获取当前颜色主题类别 [默认是白色主题]
    @objc public func getCurrentColorThemeId() -> Int {
        guard let themeKey = UserDefaults.standard.string(forKey: kAppSkinName) else { return ColorSchemeTheme.themeWhite.rawValue }
        return self.getColorSchemeTheme(themeName: themeKey)
    }

    ///保存当前颜色主题
    @objc public func saveColorTheme(colorScheme: ColorScheme) {
        UserDefaults.standard.setValue(self.getColorThemeString(schemeId: colorScheme.schemeId.rawValue), forKey: kAppSkinName)
        UserDefaults.standard.synchronize()
    }

    //枚举转文字
    @objc public func getColorThemeString(schemeId: Int) -> String {
        switch schemeId {
        case ColorSchemeTheme.themeWhite.rawValue :
            return "white"
        case ColorSchemeTheme.themeBlue.rawValue:
            return "blue"
        case ColorSchemeTheme.themeGray.rawValue :
            return "gray"
        default: return ""
        }
    }

    //文字转枚举
    @objc public func getColorSchemeTheme(themeName: String) -> Int {
        switch themeName {
        case "white":
            return ColorSchemeTheme.themeWhite.rawValue
        case "blue":
            return ColorSchemeTheme.themeBlue.rawValue
        case "gray":
            return ColorSchemeTheme.themeGray.rawValue
        default:
            return ColorSchemeTheme.themeWhite.rawValue
        }
    }

    //显示的名称
    @objc public func getShowTitle(schemeId: Int) -> String {
        var title: String = getI18NStr(key: "changeSkin_colorScheme_white")
        switch schemeId {
        case ColorSchemeTheme.themeWhite.rawValue :
            title = getI18NStr(key: "changeSkin_colorScheme_white")
        case ColorSchemeTheme.themeBlue.rawValue :
            return getI18NStr(key: "changeSkin_colorScheme_blue")
        case ColorSchemeTheme.themeGray.rawValue :
            return getI18NStr(key: "changeSkin_colorScheme_gray")
        default: return ""
        }
        return title
    }

    //主题色图标名称

}
