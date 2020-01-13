//
//  Utilities.h
//  impcloud
//
//  Created by Elliot on 15/5/27.
//  Copyright (c) 2015年 Elliot. All rights reserved.
//  公共文件

#import <UIKit/UIKit.h>

//判断iPhone、iPad
typedef NS_ENUM(NSInteger, ETDeviceSeries) {
    iPhone4_Series_960x640,         //iPhone 4、4s
    iPhone5_Series_1136x640,        //iPhone 5、5s、5c、SE
    iPhone6_Series_1334x750,        //iPhone 6、7、8
    iPhone6p_Series_2208x1242,      //iPhone 6p、7p、8p
    iPhoneX_Series_2436x1125,       //iPhone X、Xs
    iPhoneXr_Series_1792x828,       //iPhone Xr
    iPhoneXsMax_Series_2688x1242,   //iPhone Xs Max
    iPad_2048x1536,                 //iPad Retina and Normal
    iPad_2224x1668,                 //iPad Pro 10.5
    iPad_2388x1668,                 //iPad Pro 11
    iPad_2732x2048,                 //iPad Pro 12.9
};

@interface Utilities : NSObject

+ (NSDate *)zeroOfDate:(NSDate *)date;

//判断iPhone、iPad方法
+ (ETDeviceSeries)getDeviceSeries;

/**************设备信息相关********/
//获取设备型号
+ (NSString *)getDeviceModel;

//获取设备iOS版本
+ (NSString *)getDeviceiOSVersion;

//获取设备分辨率
+ (NSString *)getDeviceResolution;

//获取设备码
+ (NSString *)getDeviceKey;

//获取APP版本号
+ (NSString *)getAPPCurrentVersion;

//获取APPCore版本
+ (NSString *)getAPPCoreVersion;

//获取APP BundleID
+ (NSString *)getAPPBundleID;

//获取用户自定义名称
+ (NSString *)getDeviceUserName;
/**************设备信息相关********/

//判断相机权限
+ (BOOL)judgeCameraPermissions;

//判断是否是手机号
+ (BOOL) validatePhoneNum:(NSString *)phone;

//判断是否是用户名
+ (BOOL) validateUserName:(NSString *)name;

//判断是否是昵称
+ (BOOL) validateNickname:(NSString *)nickname;

//判断是否是密码
+ (BOOL) validatePassword:(NSString *)passWord;

//判断是否是邮箱
+ (BOOL) validateEmail:(NSString *)email;

//判断是否是身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//将本地日期字符串转为UTC日期字符串
+(NSString *)getUTCFormateLocalDate:(NSString *)localDate;

//将UTC日期字符串转为NSDate
+(NSDate *)getDateFormateUTCDate:(NSString *)utcDate;

//通过颜色码获取UIColor
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

//正则验证
+(BOOL)check:(NSString*)text predicate:(NSString*)predicate;

//距离今天多久
+(NSString *) compareCurrentTime:(NSDate*) compareDate;

//字符串转时间
+(NSDate *)dateString:(NSString *)dateString dateFormat:(NSString *)dateFormat;

//时间转字符串
+(NSString *)date:(NSDate *)date dateFormat:(NSString *)dateFormat;

//时间格式转换
+(NSString *)dateString:(NSString *)dateString newFormat:(NSString *)newFormat;

 //毫秒转成秒
+(NSString *)msToS:(NSString *)ms;

+ (NSString *)base64EncodedString:(NSString *)string;

+ (NSString *)base64DecodedString:(NSString *)string;

+ (NSString *)appDocumentPath;

/**
 *  @author wangzhen@richingtech.com, 16-06-14
 *
 *  UNIX 时间戳 转 string
 */
+ (NSString *)getStringFromUnixDate:(NSString *)unixDate;

// 时间格式和字符串通过forment互相转化
+ (NSString *)stringFromDate:(NSDate *)date andFormentStr:(NSString *)forment;

+ (NSDate *)dateFromString:(NSString *)dateStr andFormentStr:(NSString *)forment;

///判断两天是否同一天
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

+ (BOOL)isEmpty:(NSString *)str;

+ (NSObject *)dicFromJSONStr:(NSString *)jsonStr;
+ (NSString *)JSONStrFromDic:(NSObject *)dic;

//URL encode
+(NSString *)IIPRIVATE_encodeString:(NSString*)unencodedString;

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

//3D-Touch
+ (UIApplicationShortcutIconType)getApplicationShortcutIconType:(NSString *)str;

+(void)appOpenURL:(NSURL *)URL;

//获取升级属性Key
+(NSString *)getAPPUpgradeKey;

//处理html特殊字符
+ (NSString *)htmlEntityDecode:(NSString *)string;

//Toast
+(void)showToast:(NSString *)str;

//保存页面临时跳转时的页面
+ (void)addVCToBeDeleted:(UIViewController *)vc;
+ (NSMutableArray *)getVCToBeDeleted;
+ (void)clearVCToBeDeleted;

//注销远程推送
+ (void)notification_unregisterForRemoteNotification;

//跳转到App Store【云+App】
+ (void)jumpToAppStoreAboutCloud;

//频道文件上传生成本地id
+ (NSString *)getNewFileLocalId:(NSString *)cid;
+ (NSString *)getNewImageLocalId:(NSString *)cid;
+ (NSString *)getNewVoiceLocalId:(NSString *)cid;

//获取当前最近的半点时间
+ (NSDate *)getCurrentDateAfterHalfHour;

//根据目标图片制作一个盖水印的图片
+ (UIImage *)getWaterMarkImage: (UIImage *)originalImage andTitle: (NSString *)title andMarkFont: (UIFont *)markFont;

//通过文字生成图片
+ (UIImage *)getAvatarByText:(NSString *)text;

//可用于清除导航栏下方横线
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

//键盘显示隐藏时，界面上移或恢复
+ (void)changeViewFrameWhenKeyboardShow:(UIView *)myView;
+ (void)changeViewFrameWhenKeyboardHide:(UIView *)myView;

//清除Web Cookie和缓存[UIWebView、WKWebView]
+ (void)deleteWebCache;

@end
