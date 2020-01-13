//
//  IICoreExtension.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/16.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

/*
 app ui config file
 all ui config parameters

 */

public class APPUIConfig: NSObject {

    /// 跟踪导航栏颜色
    @objc public static var navigationBarColor: UIColor {
        guard let color = ((UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)?.viewControllers?[0])?.navigationController?.navigationBar.tintColor else {
            return APPUIConfig.cloudThemeColorVersion3
        }
        return color
    }

    @objc public static var useDefaultStatusBarStyle = true

    /// 白色
    @objc public static let whiteColor = UIColor.white

    /// 背景-灰色[eg.tableview-bgcolor]
    @objc public static let bgLightGray = UIColor(red: 248 / 255, green: 249 / 255, blue: 251 / 255, alpha: 1)

    /// 线条-灰色[eg.tableview-sepline-color]
    @objc public static let lineLightGray = UIColor(red: 221 / 255, green: 221 / 255, blue: 221 / 255, alpha: 1)

    /// ding-talk蓝
    @objc public static let dingtalkBlue = UIColor(red: 54 / 255, green: 165 / 255, blue: 246 / 255, alpha: 1)

    /// 文字链接蓝
    @objc public static let linkBlue = UIColor(red: 54 / 255, green: 165 / 255, blue: 246 / 255, alpha: 1)

    /// 云+主题色
    @objc public static var cloudThemeColor = UIColor(red: 15 / 255, green: 123 / 255, blue: 202 / 255, alpha: 1)

    /// 文本副标题-灰色
    @objc public static var charGrayColor = UIColor.gray

    /// 默认的黑体字颜色-主标题
    @objc public static var mainCharColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)

    /// 色-副标题[浅蓝]
    @objc public static let subCharColor = UIColor(red: 79 / 255, green: 133 / 255, blue: 161 / 255, alpha: 1)

    /// 不可用状态-灰
    @objc public static let disabledGray = UIColor(red: 203 / 255, green: 204 / 255, blue: 206 / 255, alpha: 1)

    /// 个人头像默认背景色
    @objc public static let personAvatarBackground = UIColor(red: 255 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1)

    /// 语音背景-绿
    @objc public static let agoraBGGreen = UIColor(red: 54 / 255, green: 211 / 255, blue: 67 / 255, alpha: 1)

    /// 红色
    @objc public static let redColor = UIColor.red

    // ========================ui3.0start ==============================

    ///网盘中按钮的背景蓝色
    @objc public static let btnBGBlue = UIColor(red: 219 / 255, green: 240 / 255, blue: 255 / 255, alpha: 1)

    ///日程中时间轴青色背景
    @objc public static let calendarTimeLineBG = UIColor(red: 54 / 255, green: 165 / 255, blue: 246 / 255, alpha: 0.05)

    ///日程中某一个cell-header标题颜色
    @objc public static let calendarHeaderTitleColor = UIColor(red: 148 / 255, green: 175 / 255, blue: 196 / 255, alpha: 1)

    ///搜索框的背景颜色
    @objc public static let searchBarBgColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)

    ///3.0浅蓝
    @objc public static var blueThemeColor = UIColor(red: 54 / 255, green: 165 / 255, blue: 246 / 255, alpha: 1)

    /// more-tab-sep-line-color
    @objc public static let customListSepLineColor = UIColor(red: 227 / 255, green: 227 / 255, blue: 227 / 255, alpha: 1)

    /// 新背景色
    @objc public static var newBgColor = UIColor(red: 248 / 255, green: 249 / 255, blue: 251 / 255, alpha: 1)

    /// 云+主题色 3.0
    @objc public static var cloudThemeColorVersion3 = UIColor.white

    ///导航栏文字颜色
    @objc public static var navCharColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)

    /// 自己的聊天气泡颜色
    @objc public static var myChatBgColor = blueThemeColor

    /// 他人的聊天气泡颜色
    @objc public static var otherChatBgColor = UIColor(red: 236 / 255, green: 238 / 255, blue: 242 / 255, alpha: 1)

    /// 聊天时间分段字体颜色
    @objc public static let chatTimeSectionCharColor = UIColor(red: 151 / 255, green: 163 / 255, blue: 180 / 255, alpha: 1)

    /// 聊天未读消息提醒按钮颜色
    @objc public static let chatUnreadRemindBgColor = UIColor(red: 150 / 255, green: 207 / 255, blue: 248 / 255, alpha: 1)//UIColor(red: 54 / 255, green: 165 / 255, blue: 246 / 255, alpha: 0.5)

    /// 搜索头部字体颜色
    @objc public static let tableHeaderColor = UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)

    ///输入框选中时线条颜色
    @objc public static let selectedLineColor = UIColor(red: 54 / 255, green: 165 / 255, blue: 246 / 255, alpha: 1)

    ///输入框未选中时线条颜色
    @objc public static let inputLineColor = UIColor(red: 211 / 255, green: 223 / 255, blue: 239 / 255, alpha: 1)

    ///导航栏右侧按钮颜色
    @objc public static var navRightTextColor = blueThemeColor//UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)

    ///导航栏左侧按钮颜色
    //    @objc static let navLeftTextColor = UIColor(red: 51 / 255, green: 158 / 255, blue: 236 / 255, alpha: 1)

    ///选择按钮底色
    @objc public static var switchButtonBgColor = blueThemeColor

    ///日历日期文字颜色
    @objc public static let calendarTimeTextColor = UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1)

    ///工作Navi未选中状态颜色
    @objc public static var workNaviSubTextColor = UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1)

    ///底部TabBar文字 普通状态/选中状态 颜色
    @objc public static var tabBarTextNormalColor = UIColor(red: 151 / 255, green: 158 / 255, blue: 163 / 255, alpha: 1)
    @objc public static var tabBarTextSelectedColor = UIColor(red: 54 / 255, green: 165 / 255, blue: 246 / 255, alpha: 1)

    ///底部按钮颜色 退出登录、添加日历等
    @objc public static var bottomButtonColor = UIColor(red: 54 / 255, green: 165 / 255, blue: 246 / 255, alpha: 1)

    ///聊天“+”背景色
    @objc public static var extraActionsBgColor = UIColor(red: 248 / 255, green: 249 / 255, blue: 251 / 255, alpha: 1)

    ///搜索Bar背景色
    @objc public static var searchBarNewBgColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)

    ///遮罩层颜色
    @objc public static var shadowColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.2)

    /// 缩放比例（目前默认为1）
    @objc public static let sizeScale: CGFloat = UIScreen.main.bounds.width / 375.0

    /// 顶部状态栏高度(导航栏以上部分iphonex就是这部分高度不同)
    @objc public static var noNaviTopDistance: CGFloat {
        var dis: CGFloat = 0
        dis = UIApplication.shared.statusBarFrame.size.height
        return dis
    }

    /// 导航栏高度
    @objc public static var naviTopDistance: CGFloat {
        var dis: CGFloat = 0
        dis = UINavigationBar().frame.size.height
        return dis
    }

    /// 根据字号和宽度比例来处理字体
    @objc public static func uiFont(with size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }

    /// 根据字号和宽度比例来处理字体(加粗)
    @objc public static func boldUIFont(with size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }

    /// screen height
    @objc public static let aHeight: CGFloat = UIScreen.main.bounds.size.height

    /// screen weight
    @objc public static let aWeight: CGFloat = UIScreen.main.bounds.size.width

    /// 导航栏高度+状态栏-设置一下属性即可
    /// self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    @objc public static var naviHeight: CGFloat {
        let con = UINavigationController()
        return UIApplication.shared.statusBarFrame.size.height + con.navigationBar.frame.height
    }

    /// 应用页面Footer数值
    @objc public static var appFooterWeight: CGFloat = 10
    /// 应用页面LineHeader数值
    @objc public static var appLineHeaderWeight: CGFloat = 10
    /// 应用页面LabelHeader数值
    @objc public static var appLabelHeaderWeight: CGFloat = 0

    /// tabbar高度
    @objc public static var tabbbarHeight: CGFloat {
        return (UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)?.tabBar.frame.size.height ?? 123//UITabBar().frame.size.height
    }

}
