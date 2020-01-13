//
//  Utilities.m
//  impcloud
//
//  Created by Elliot on 15/5/27.
//  Copyright (c) 2015年 Elliot. All rights reserved.
//  

#import "Utilities.h"
#import "AVFoundation/AVFoundation.h"
#import "UIImageView+WebCache.h"
#import "WebKit/WebKit.h"
#import "sys/utsname.h"
#import <UIKit/UIKit.h>
#import "Toast.h"

//判断iOS设备
//iPhone 4、4s
#define Resolution_960x640 CGSizeMake(960.0f, 640.0f)
#define Resolution_640x960 CGSizeMake(640.0f, 960.0f)
//iPhone 5、5s、5c、SE
#define Resolution_1136x640 CGSizeMake(1136.0f, 640.0f)
#define Resolution_640x1136 CGSizeMake(640.0f, 1136.0f)
//iPhone 6、7、8
#define Resolution_1334x750 CGSizeMake(1334.0f, 750.0f)
#define Resolution_750x1334 CGSizeMake(750.0f, 1334.0f)
//iPhone 6p、7p、8p
#define Resolution_2208x1242 CGSizeMake(2208.0f, 1242.0f)
#define Resolution_1242x2208 CGSizeMake(1242.0f, 2208.0f)
//iPhone X、Xs
#define Resolution_2436x1125 CGSizeMake(2436.0f, 1125.0f)
#define Resolution_1125x2436 CGSizeMake(1125.0f, 2436.0f)
//iPhone Xr
#define Resolution_1792x828 CGSizeMake(1792.0f, 828.0f)
#define Resolution_828x1792 CGSizeMake(828.0f, 1792.0f)
//iPhone Xs Max
#define Resolution_2688x1242 CGSizeMake(2688.0f, 1242.0f)
#define Resolution_1242x2688 CGSizeMake(1242.0f, 2688.0f)

//iPad
#define Resolution_1024x768 CGSizeMake(1024.0f,768.0f)
#define Resolution_768x1024 CGSizeMake(768.0f,1024.0f)
//iPad Retina and Normal
#define Resolution_2048x1536 CGSizeMake(2048.0f,1536.0f)
#define Resolution_1536x2048 CGSizeMake(1536.0f,2048.0f)
//iPad Pro 10.5
#define Resolution_2224x1668 CGSizeMake(2224.0f,1668.0f)
#define Resolution_1668x2224 CGSizeMake(1668.0f,2224.0f)
//iPad Pro 11
#define Resolution_2388x1668 CGSizeMake(2388.0f,1668.0f)
#define Resolution_1668x2388 CGSizeMake(1668.0f,2388.0f)
//iPad Pro 12.9
#define Resolution_2732x2048 CGSizeMake(2732.0f,2048.0f)
#define Resolution_2048x2732 CGSizeMake(2048.0f,2732.0f)

//放大模式
#define Resolution_750x1334_Scale_1_5 CGSizeMake(Resolution_750x1334.width * 1.5, Resolution_750x1334.height * 1.5)

@implementation Utilities

static NSMutableArray *viewControllersToBeDeleted;

//判断iOS设备 方法
+ (ETDeviceSeries)getDeviceSeries {
    //默认为 iPhone 6、7、8
    static enum ETDeviceSeries _currentDeviceSeries = iPhone6_Series_1334x750;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
        if (CGSizeEqualToSize(Resolution_2688x1242, screenSize)||CGSizeEqualToSize(Resolution_1242x2688, screenSize) || [[self getDeviceModel] isEqualToString:@"iPhone XS Max"]) {
            //iPhone Xs Max
            _currentDeviceSeries = iPhoneXsMax_Series_2688x1242;
        }
        if (CGSizeEqualToSize(Resolution_1792x828, screenSize)||CGSizeEqualToSize(Resolution_828x1792, screenSize) || [[self getDeviceModel] isEqualToString:@"iPhone XR"]) {
            //iPhone Xr
            _currentDeviceSeries = iPhoneXr_Series_1792x828;
        }
        if (CGSizeEqualToSize(Resolution_2436x1125, screenSize)||CGSizeEqualToSize(Resolution_1125x2436, screenSize) || [[self getDeviceModel] isEqualToString:@"iPhone XS"] || [[self getDeviceModel] isEqualToString:@"iPhone X"]) {
            //iPhone X、Xs
            _currentDeviceSeries = iPhoneX_Series_2436x1125;
        }
        if (CGSizeEqualToSize(Resolution_2208x1242, screenSize)||CGSizeEqualToSize(Resolution_1242x2208, screenSize) || [[self getDeviceModel] isEqualToString:@"iPhone 6 Plus"] || [[self getDeviceModel] isEqualToString:@"iPhone 6s Plus"] || [[self getDeviceModel] isEqualToString:@"iPhone 7 Plus"] || [[self getDeviceModel] isEqualToString:@"iPhone 8 Plus"]) {
            //iPhone 6p、7p、8p
            _currentDeviceSeries = iPhone6p_Series_2208x1242;
        }
        if(CGSizeEqualToSize(Resolution_1334x750, screenSize)||CGSizeEqualToSize(Resolution_750x1334, screenSize)||CGSizeEqualToSize(Resolution_750x1334_Scale_1_5, screenSize) || [[self getDeviceModel] isEqualToString:@"iPhone 6"] || [[self getDeviceModel] isEqualToString:@"iPhone 6s"] || [[self getDeviceModel] isEqualToString:@"iPhone 7"] || [[self getDeviceModel] isEqualToString:@"iPhone 8"]) {
            //iPhone 6、7、8
            _currentDeviceSeries = iPhone6_Series_1334x750;
        }
        if (CGSizeEqualToSize(Resolution_1136x640, screenSize)||CGSizeEqualToSize(Resolution_640x1136, screenSize) || [[self getDeviceModel] isEqualToString:@"iPhone 5"] || [[self getDeviceModel] isEqualToString:@"iPhone 5c"] || [[self getDeviceModel] isEqualToString:@"iPhone 5s"] || [[self getDeviceModel] isEqualToString:@"iPhone SE"]) {
            //iPhone 5、5s、5c、SE
            _currentDeviceSeries = iPhone5_Series_1136x640;
        }
        if (CGSizeEqualToSize(Resolution_960x640, screenSize)||CGSizeEqualToSize(Resolution_640x960, screenSize)) {
            //iPhone 4、4s
            _currentDeviceSeries = iPhone4_Series_960x640;
        }
        if (CGSizeEqualToSize(Resolution_2048x1536, screenSize)||CGSizeEqualToSize(Resolution_1536x2048, screenSize)||CGSizeEqualToSize(Resolution_1024x768, screenSize)||CGSizeEqualToSize(Resolution_768x1024, screenSize)) {
            //iPad
            _currentDeviceSeries = iPad_2048x1536;
        }
        if (CGSizeEqualToSize(Resolution_2224x1668, screenSize)||CGSizeEqualToSize(Resolution_1668x2224, screenSize)) {
            //iPad Pro 10.5
            _currentDeviceSeries = iPad_2224x1668;
        }
        if (CGSizeEqualToSize(Resolution_2388x1668, screenSize)||CGSizeEqualToSize(Resolution_1668x2388, screenSize)) {
            //iPad Pro 11
            _currentDeviceSeries = iPad_2224x1668;
        }
        if (CGSizeEqualToSize(Resolution_2732x2048, screenSize)||CGSizeEqualToSize(Resolution_2048x2732, screenSize)) {
            //iPad Pro 12.9
            _currentDeviceSeries = iPad_2732x2048;
        }
    });
    return _currentDeviceSeries;
}

/**************设备信息相关********/
//获取设备型号，截止到2019-08
+ (NSString *)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod touch (2nd generation)";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod touch (3rd generation)";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod touch (4th generation)";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod touch (5th generation)";
    if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod touch (6th generation)";
    if ([deviceString isEqualToString:@"iPod9,1"])      return @"iPod touch (7th generation)";
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad (3rd generation)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad (3rd generation)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad (3rd generation)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad (4th generation)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad (4th generation)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad (4th generation)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro (9.7-inch)";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro (9.7-inch)";
    if ([deviceString isEqualToString:@"iPad6,11"])     return @"iPad (5th generation)";
    if ([deviceString isEqualToString:@"iPad6,12"])     return @"iPad (5th generation)";
    if ([deviceString isEqualToString:@"iPad7,1"])      return @"iPad Pro (12.9-inch, 2nd generation)";
    if ([deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro (12.9-inch, 2nd generation)";
    if ([deviceString isEqualToString:@"iPad7,3"])      return @"iPad Pro (10.5-inch)";
    if ([deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro (10.5-inch)";
    if ([deviceString isEqualToString:@"iPad7,5"])      return @"iPad (6th generation)";
    if ([deviceString isEqualToString:@"iPad7,6"])      return @"iPad (6th generation)";
    if ([deviceString isEqualToString:@"iPad8,1"])      return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,2"])      return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,3"])      return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,4"])      return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,5"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceString isEqualToString:@"iPad8,6"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceString isEqualToString:@"iPad8,7"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceString isEqualToString:@"iPad8,8"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceString isEqualToString:@"iPad11,3"])     return @"iPad Air (3rd generation)";
    if ([deviceString isEqualToString:@"iPad11,4"])     return @"iPad Air (3rd generation)";
    //iPad mini
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad mini 4";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad mini 4";
    if ([deviceString isEqualToString:@"iPad11,1"])     return @"iPad mini (5th generation)";
    if ([deviceString isEqualToString:@"iPad11,2"])     return @"iPad mini (5th generation)";
    //Simulator
    if ([deviceString isEqualToString:@"i386"])         return @"iOS Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"iOS Simulator";
    return deviceString;
}

//获取设备iOS版本
+ (NSString *)getDeviceiOSVersion {
    NSString *deviceVer = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] systemVersion]];
    return deviceVer;
}

//获取设备分辨率
+ (NSString *)getDeviceResolution {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = rect.size.width * scale;
    CGFloat height = rect.size.height * scale;
    return [NSString stringWithFormat:@"%d*%d",(int)height,(int)width];
}

//获取设备码
+ (NSString *)getDeviceKey {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

//获取APP版本号
+ (NSString *)getAPPCurrentVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return version;
}

//获取APPCore版本,基础版本 给外部打包的时候尤其需要注意
+ (NSString *)getAPPCoreVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return version;
}

//获取APP BundleID
+ (NSString *)getAPPBundleID {
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return bundleID;
}

//获取用户自定义名称
+ (NSString *)getDeviceUserName {
    NSString *userName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return userName;
}
/**************设备信息相关********/

+ (BOOL)judgeCameraPermissions {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    }else {
        return YES;
    }
}

//判断是否是手机号
+ (BOOL) validatePhoneNum:(NSString *)phone
{
    NSString *phoneRegex = @"^([1])\\d{10}$";
    BOOL bPhone = NO;
    bPhone = [self judgeLegalWithPredicateString:phoneRegex andCompareString:phone];
    return bPhone;
}

+ (BOOL)judgeLegalWithPredicateString:(NSString *)predicateStr  andCompareString:(NSString *)strCompare
{
    NSPredicate *predicateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateStr];
    return [predicateTest evaluateWithObject:strCompare];
}

/*
用户名与昵称的区别
 
用户名就是登陆名，只能由英文或英文加数字组成，用户名是唯一的，任何人的用户名都不会和你的用户名重复；
 
昵称就是笔名，可以是任意字符，是公开的，可以任意修改，多人重复。
*/

//判断是否是用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//判断是否是昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//判断是否是密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//判断是否是邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断是否是身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//将本地日期字符串转为UTC日期字符串
+(NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    
    return dateString;
}

//将UTC日期字符串转为NSDate
+(NSDate *)getDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    //输出格式
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    return dateFormatted;
}

//通过颜色码获取UIColor
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor redColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if (cString.length == 6) {
        cString = [@"ff" stringByAppendingString:cString];
    }
    if ([cString length] != 8)
        return [UIColor redColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.length = 2;
    range.location = 0;
    NSString *aString = [cString substringWithRange:range];
    range.location = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 4;
    NSString *gString = [cString substringWithRange:range];
    range.location = 6;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}

#pragma  mark 正则验证
+(BOOL)check:(NSString*)text predicate:(NSString*)predicate
{
    NSString *regex = predicate;
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [p evaluateWithObject:text];
}

+(NSString *) compareCurrentTime:(NSDate*) compareDate{
    /*
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: [NSDate date]];//东八区，8小时
    NSDate *localeDate = [[NSDate date]  dateByAddingTimeInterval: interval];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceDate:localeDate];

    
    if ((int)timeInterval/60/60/24<timeInterval/60/60/24) {
        return [NSString stringWithFormat:@"%d",(int)timeInterval/60/60/24+1];
    }
    else return [NSString stringWithFormat:@"%d",(int)timeInterval/60/60/24];*/
    
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    int timeDay = (int)(([compareDate timeIntervalSince1970] + timezoneFix)/(24*3600)) -    (int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(24*3600));

    return [NSString stringWithFormat:@"%d",timeDay];
    
}

#pragma  mark 字符串转时间
//yyyy-MM-dd HH:mm:ss
+(NSDate *)dateString:(NSString *)dateString dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

#pragma  mark 时间转字符串
//yyyy-MM-dd HH:mm:ss
+(NSString *)date:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

#pragma  mark 时间格式转换
+(NSString *)dateString:(NSString *)dateString newFormat:(NSString *)newFormat
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:dateFormat];
//    NSDate *date = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:newFormat];
    NSString *myNewDateString = [outputFormat stringFromDate:date];
    
    return myNewDateString;
}
+ (NSDate *)zeroOfDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}
#pragma mark 毫秒转秒
+(NSString *)msToS:(NSString *)ms {
     return [NSString stringWithFormat:@"%lld",[ms longLongValue]/1000];
}

#pragma mark 切割图片
+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool
{
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if(centerBool)
    {
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    }
    else
    {
        if (viewheight < viewwidth)
        {
            if (imgwidth <= imgheight)
            {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }
            else
            {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2 ;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }
                else
                {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }
        else
        {
            if (imgwidth <= imgheight)
            {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight)
                {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }
                else
                {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }
            else
            {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth)
                {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }
                else
                {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();

    return smallImage;
}

+ (NSString *)base64EncodedString:(NSString *)string
{
    NSData *plainData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}

+ (NSString *)base64DecodedString:(NSString *)string
{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

+ (NSString *)appDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString *)getStringFromUnixDate:(NSString *)unixDate
{
    NSString *str = [unixDate substringToIndex:10];
    
    double unixTimeStamp = [str doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *_date=[_formatter stringFromDate:date];
    return _date;
}

// 时间格式和字符串通过forment互相转化
+ (NSString *)stringFromDate:(NSDate *)date andFormentStr:(NSString *)forment {
    if (!date) {
        date = [NSDate date];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    if (forment) {
        [dateFormatter setDateFormat:forment];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    }
    
    return [dateFormatter stringFromDate:date];
    
}

+ (NSDate *)dateFromString:(NSString *)dateStr andFormentStr:(NSString *)forment
{
    if (!dateStr)
    {
        return [NSDate date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    if (forment)
    {
        [dateFormatter setDateFormat:forment];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    if (date)
    {
        return date;
    }
    
    return nil;
}

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];

    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return true;
    }
    else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        }
        else {
            return false;
        }
    }
}

/*
    jsonStr与 Dic 的转化
    Modify By Jacky Zang
*/
+ (NSObject *)dicFromJSONStr:(NSString *)jsonStr {
    if (jsonStr == nil) {
        return nil;
    }
    NSError *error = nil;
    
    NSObject *res = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        return  nil;
    }
    return res;
}

+ (NSString *)JSONStrFromDic:(NSObject *)dic {
    if (dic == nil) {
        return  nil;
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//URL encode
+(NSString *)IIPRIVATE_encodeString:(NSString*)unencodedString {
    NSString *encodedString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)unencodedString,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return encodedString;
}

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr
{
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        // 设置值
        [params setValue:value forKey:key];
    }
    return params;
}

+ (UIApplicationShortcutIconType)getApplicationShortcutIconType:(NSString *)str {
    if ([str isEqualToString:@"compose"]) {
        return UIApplicationShortcutIconTypeCompose;
    } else if ([str isEqualToString:@"play"]) {
        return UIApplicationShortcutIconTypePlay;
    } else if ([str isEqualToString:@"pause"]) {
        return UIApplicationShortcutIconTypePause;
    } else if ([str isEqualToString:@"add"]) {
        return UIApplicationShortcutIconTypeAdd;
    } else if ([str isEqualToString:@"location"]) {
        return UIApplicationShortcutIconTypeLocation;
    } else if ([str isEqualToString:@"search"]) {
        return UIApplicationShortcutIconTypeSearch;
    } else if ([str isEqualToString:@"share"]) {
        return UIApplicationShortcutIconTypeShare;
    } else { if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.1) {
            if ([str isEqualToString:@"prohibit"]) {
                return UIApplicationShortcutIconTypeProhibit;
            } else if ([str isEqualToString:@"contact"]) {
                return UIApplicationShortcutIconTypeContact;
            } else if ([str isEqualToString:@"home"]) {
                return UIApplicationShortcutIconTypeHome;
            } else if ([str isEqualToString:@"mark-location"]) {
                return UIApplicationShortcutIconTypeMarkLocation;
            } else if ([str isEqualToString:@"favorite"]) {
                return UIApplicationShortcutIconTypeFavorite;
            } else if ([str isEqualToString:@"love"]) {
                return UIApplicationShortcutIconTypeLove;
            } else if ([str isEqualToString:@"cloud"]) {
                return UIApplicationShortcutIconTypeCloud;
            } else if ([str isEqualToString:@"invitation"]) {
                return UIApplicationShortcutIconTypeInvitation;
            } else if ([str isEqualToString:@"confirmation"]) {
                return UIApplicationShortcutIconTypeConfirmation;
            } else if ([str isEqualToString:@"mail"]) {
                return UIApplicationShortcutIconTypeMail;
            } else if ([str isEqualToString:@"message"]) {
                return UIApplicationShortcutIconTypeMessage;
            } else if ([str isEqualToString:@"date"]) {
                return UIApplicationShortcutIconTypeDate;
            } else if ([str isEqualToString:@"time"]) {
                return UIApplicationShortcutIconTypeTime;
            } else if ([str isEqualToString:@"capture-photo"]) {
                return UIApplicationShortcutIconTypeCapturePhoto;
            } else if ([str isEqualToString:@"capture-video"]) {
                return UIApplicationShortcutIconTypeCaptureVideo;
            } else if ([str isEqualToString:@"task"]) {
                return UIApplicationShortcutIconTypeTask;
            } else if ([str isEqualToString:@"completed"]) {
                return UIApplicationShortcutIconTypeTaskCompleted;
            } else if ([str isEqualToString:@"alarm"]) {
                return UIApplicationShortcutIconTypeAlarm;
            } else if ([str isEqualToString:@"bookmark"]) {
                return UIApplicationShortcutIconTypeBookmark;
            } else if ([str isEqualToString:@"shuffle"]) {
                return UIApplicationShortcutIconTypeShuffle;
            } else if ([str isEqualToString:@"audio"]) {
                return UIApplicationShortcutIconTypeAudio;
            } else if ([str isEqualToString:@"update"]) {
                return UIApplicationShortcutIconTypeUpdate;
            } else {
                return UIApplicationShortcutIconTypePlay;
            }
        } else {
            return UIApplicationShortcutIconTypePlay;
        }
    }
}

+(void)appOpenURL:(NSURL *)URL {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success){}];
    }
    else {
        [application openURL:URL];
    }
}

//获取升级属性Key
+(NSString *)getAPPUpgradeKey {
    NSString *key = @"YunPlus_dev";
    NSString *BundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([BundleID isEqualToString:@"com.inspur.impcloud"]) {
        key = @"YunPlus_Dis";
    }
    return key;
}

+ (NSString *)htmlEntityDecode:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    return string;
}

//Toast
+(void)showToast:(NSString *)str {
    [[UIApplication sharedApplication].keyWindow makeToast:str duration:1.0 position:CSToastPositionCenter];
}
//保存页面临时跳转时的页面
+ (void)addVCToBeDeleted:(UIViewController *)vc{
    if(!viewControllersToBeDeleted){
        viewControllersToBeDeleted = [[NSMutableArray alloc] init];
    }
    if(![viewControllersToBeDeleted containsObject:vc]){
        [viewControllersToBeDeleted addObject:vc];
    }
}

+ (NSMutableArray *)getVCToBeDeleted {
    if(viewControllersToBeDeleted){
        return viewControllersToBeDeleted;
    }else {
        return [[NSMutableArray alloc] init];
    }
}

+ (void)clearVCToBeDeleted {
    [viewControllersToBeDeleted removeAllObjects];
}

//注销远程推送
+ (void)notification_unregisterForRemoteNotification {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

//跳转到App Store【云+App】
+ (void)jumpToAppStoreAboutCloud {
    [self appOpenURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/id1132537698?mt=8"]];
}

+ (NSString *)getNewFileLocalId:(NSString *)cid {
    return [NSString stringWithFormat:@"%@_channelFile_%ld", cid, (long)([[NSDate date] timeIntervalSince1970] * 1000)];
}

+ (NSString *)getNewImageLocalId:(NSString *)cid {
    return [NSString stringWithFormat:@"%@_channelImage_%ld", cid, (long)([[NSDate date] timeIntervalSince1970] * 1000)];
}
+ (NSString *)getNewVoiceLocalId:(NSString *)cid {
    return [NSString stringWithFormat:@"%@_channelVoice_%ld", cid, (long)([[NSDate date] timeIntervalSince1970] * 1000)];
}

+ (NSDate *)getCurrentDateAfterHalfHour {
    NSTimeInterval time =  [[NSDate date] timeIntervalSince1970];
    double res =  ceil(time/1800.0)*1800;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:res];
    return newDate;
}

/**
 根据目标图片制作一个盖水印的图片

 @param originalImage 源图片
 @param title 水印文字
 @param markFont 水印文字font(如果不传默认为23)
 @param markColor 水印文字颜色(如果不传递默认为源图片的对比色)
 @return 返回盖水印的图片
 **/
+ (UIImage *)getWaterMarkImage: (UIImage *)originalImage andTitle: (NSString *)title andMarkFont: (UIFont *)markFont {
    UIFont *font = markFont;
    if (font == nil) {
        font = [UIFont boldSystemFontOfSize:23];
    }
    UIColor *color = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //原始image的宽高
    CGFloat viewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat viewHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    //为了防止图片失真，绘制区域宽高和原始图片宽高一样
    UIGraphicsBeginImageContext(CGSizeMake(viewWidth, viewHeight));
    //先将原始image绘制上
    [originalImage drawInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
    //sqrtLength：原始image的对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
    CGFloat sqrtLength = sqrt(viewWidth*viewWidth + viewHeight*viewHeight);
    //文字的属性
    NSDictionary *attr = @{
                           //设置字体大小
                           NSFontAttributeName: font,
                           //设置文字颜色
                           NSForegroundColorAttributeName :color,
                           };
    NSString* mark = title;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:mark attributes:attr];
    //绘制文字的宽高
    CGFloat strWidth = attrStr.size.width;
    CGFloat strHeight = attrStr.size.height;
    //开始旋转上下文矩阵，绘制水印文字
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将绘制原点（0，0）调整到源image的中心
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2, viewHeight/2));
    //以绘制原点为中心旋转
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(-(M_PI_2 / 3)));
    //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2, -viewHeight/2));
    //计算需要绘制的列数和行数
    int horCount = sqrtLength / (strWidth + 150) + 1;
    int verCount = sqrtLength / (strHeight + 100) + 1;
    //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
    CGFloat orignX = -(sqrtLength-viewWidth)/2;
    CGFloat orignY = -(sqrtLength-viewHeight)/2;
    //在每列绘制时X坐标叠加
    CGFloat tempOrignX = orignX;
    //在每行绘制时Y坐标叠加
    CGFloat tempOrignY = orignY;
    for (int i = 0; i < horCount * verCount; i++) {
        [mark drawInRect:CGRectMake(tempOrignX, tempOrignY, strWidth, strHeight) withAttributes:attr];
        if (i % horCount == 0 && i != 0) {
            tempOrignX = orignX;
            tempOrignY += (strHeight + 150);
        }
        else{
            tempOrignX += (strWidth + 100);
        }
    }
    //根据上下文制作成图片
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    return finalImg;
}

/**
 绘制带名字最后一个字的图片
 @param text 文字，利用正则获取匹配的数据，然后再取最后一个字
 @return 图片
 */
+ (UIImage *)getAvatarByText:(NSString *)text {
    NSString *lastWord;
    NSString *filePath;
    if(text.length > 0){
        //正则(\\(|（)[^（\\(\\)）]*?(\\)|）)|\\d*$
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\(|（)[^（\\(\\)）]*?(\\)|）)|\\d*$" options:NSRegularExpressionCaseInsensitive error:nil];
        NSString *str = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
        if (str.length > 0) {
            //取最后一个字
            lastWord = [str substringFromIndex:str.length-1];
        }
        else {
            lastWord = @"";
        }
    }
    else {
        lastWord = @"";
    }
    //检查有没有缓存，有就直接读本地
    filePath = [[self getAvatarSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",lastWord]];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    if(img != nil) {
        return img;
    }
    CGSize size = CGSizeMake(180, 180);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor colorWithRed:54/255.0 green:165/255.0 blue:246/255.0 alpha:1];
    //Color
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:104], NSFontAttributeName, nil];
    CGSize textSize = [lastWord sizeWithAttributes:textAttributes];
    [lastWord drawInRect:CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height) withAttributes:textAttributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //生成完之后，储存本地
    if(text.length > 0){
        [UIImageJPEGRepresentation(image, 0.8) writeToFile:filePath atomically:YES];
    }
    return image;
}

+ (NSString *)getAvatarSavePath {
    //头像生成路径无需区分用户、企业
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"AvatarFolder"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir) {
            NSLog(@"创建文件夹失败！%@",path);
        }
    }
    return path;
}

//可用于清除导航栏下方横线
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if([view isKindOfClass:UIImageView.class] && view.bounds.size.height<=1.0) {
        return(UIImageView*)view;
    }
    for(UIView*subview in view.subviews) {
        UIImageView*imageView = [self findHairlineImageViewUnder:subview];
        if(imageView) {
            return imageView;
        }
    }
    return nil;
}

+ (void)changeViewFrameWhenKeyboardShow:(UIView *)myView {
    ETDeviceSeries deviceSeries = [self getDeviceSeries];
    switch (deviceSeries) {
        case iPhone4_Series_960x640:{
            [UIView animateWithDuration:0.3 animations:^{
                myView.frame = CGRectMake(myView.frame.origin.x, -74-144,myView.frame.size.width,myView.frame.size.height);
            }];
        }
            break;
        case iPhone5_Series_1136x640:{
            [UIView animateWithDuration:0.3 animations:^{
                myView.frame = CGRectMake(myView.frame.origin.x, -144,myView.frame.size.width,myView.frame.size.height);
            }];
        }
            break;
        case iPhone6_Series_1334x750: case iPhone6p_Series_2208x1242:{
            [UIView animateWithDuration:0.3 animations:^{
                myView.frame =CGRectMake(myView.frame.origin.x, -54,myView.frame.size.width,myView.frame.size.height);
            }];
        }
            break;
        default:
            break;
    }
}

+ (void)changeViewFrameWhenKeyboardHide:(UIView *)myView {
    ETDeviceSeries deviceSeries = [self getDeviceSeries];
    switch (deviceSeries) {
        case iPhone4_Series_960x640:{
            [UIView animateWithDuration:0.3 animations:^{
                myView.frame = CGRectMake(myView.frame.origin.x, 0,myView.frame.size.width,myView.frame.size.height);
            }];
        }
            break;
        case iPhone5_Series_1136x640:{
            [UIView animateWithDuration:0.3 animations:^{
                myView.frame = CGRectMake(myView.frame.origin.x, 0,myView.frame.size.width,myView.frame.size.height);
            }];
        }
            break;
        case iPhone6_Series_1334x750: case iPhone6p_Series_2208x1242:{
            [UIView animateWithDuration:0.3 animations:^{
                myView.frame =CGRectMake(myView.frame.origin.x, 0,myView.frame.size.width,myView.frame.size.height);
            }];
        }
            break;
        default:
            break;
    }
}

//清除Web Cookie和缓存[UIWebView、WKWebView]
+ (void)deleteWebCache {
    //UIWebView
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    //WKWebView
    if ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion > 9){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 9.0, *)) {
            NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                            WKWebsiteDataTypeMemoryCache,
                                                            WKWebsiteDataTypeSessionStorage,
                                                            WKWebsiteDataTypeDiskCache,
                                                            WKWebsiteDataTypeOfflineWebApplicationCache,
                                                            WKWebsiteDataTypeCookies,
                                                            WKWebsiteDataTypeLocalStorage,
                                                            WKWebsiteDataTypeIndexedDBDatabases,
                                                            WKWebsiteDataTypeWebSQLDatabases
                                                            ]];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                //NSLog(@"WKWebView (ClearWebCache) Clear All Cache Done");
            }];
        }
#endif
    }
    else {
        // iOS8
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        @"WKWebsiteDataTypeCookies",
                                                        @"WKWebsiteDataTypeLocalStorage",
                                                        @"WKWebsiteDataTypeIndexedDBDatabases",
                                                        @"WKWebsiteDataTypeWebSQLDatabases"
                                                        ]];
        for (NSString *type in websiteDataTypes) {
            clearWebViewCacheFolderByType(type);
        }
    }
}
FOUNDATION_STATIC_INLINE void clearWebViewCacheFolderByType(NSString *cacheType) {
    static dispatch_once_t once;
    static NSDictionary *cachePathMap = nil;
    dispatch_once(&once,^{
        NSString *bundleId = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleIdentifierKey];
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *storageFileBasePath = [libraryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"WebKit/%@/WebsiteData/", bundleId]];
        cachePathMap = @{@"WKWebsiteDataTypeCookies":
                             [libraryPath stringByAppendingPathComponent:@"Cookies/Cookies.binarycookies"],
                         @"WKWebsiteDataTypeLocalStorage":
                             [storageFileBasePath stringByAppendingPathComponent:@"LocalStorage"],
                         @"WKWebsiteDataTypeIndexedDBDatabases":
                             [storageFileBasePath stringByAppendingPathComponent:@"IndexedDB"],
                         @"WKWebsiteDataTypeWebSQLDatabases":
                             [storageFileBasePath stringByAppendingPathComponent:@"WebSQL"]
                         };
    });
    NSString *filePath = cachePathMap[cacheType];
    if (filePath && filePath.length > 0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (error) {
                NSLog(@"removed file fail: %@ ,error %@", [filePath lastPathComponent], error);
            }
        }
    }
}

@end
