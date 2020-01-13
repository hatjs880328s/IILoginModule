//
//  NSBundle+MJRefresh.m
//  MJRefreshExample
//
//  Created by MJ Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "NSBundle+MJRefresh.h"
#import "MJRefreshComponent.h"
//#import "IIOCUtility/IMPCache.h"

@implementation NSBundle (MJRefresh)
+ (instancetype)mj_refreshBundle
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MJRefreshComponent class]] pathForResource:@"MJRefresh" ofType:@"bundle"]];
    }
    return refreshBundle;
}

+ (UIImage *)mj_arrowImage
{
    static UIImage *arrowImage = nil;
    if (arrowImage == nil) {
        arrowImage = [[UIImage imageWithContentsOfFile:[[self mj_refreshBundle] pathForResource:@"arrow@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return arrowImage;
}

+ (NSString *)mj_localizedStringForKey:(NSString *)key
{
    return [self mj_localizedStringForKey:key value:nil];
}

+ (NSString *)mj_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MJRefresh" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
        NSString *language;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"] == nil)
        {
            //获取系统当前语言版本
            NSArray *languages = [NSLocale preferredLanguages];
            language = [languages objectAtIndex:0];
            if ([language hasPrefix:@"en"])
            {
                //英文
                language = @"en";
            }
            else if ([language hasPrefix:@"zh"])
            {
                language = @"zh-Hans";
            }
            else
            {
                //其他语言不支持，默认为简体中文
                language = @"zh-Hans";
            }
            [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"userLanguage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            language = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"];
            if(language.length == 0)
            {
                //获取系统当前语言版本
                NSArray *languages = [NSLocale preferredLanguages];
                NSString *language = [languages objectAtIndex:0];
                if ([language hasPrefix:@"en"])
                {
                    //英文
                    language = @"en";
                }
                else if ([language hasPrefix:@"zh"])
                {
                    language = @"zh-Hans";
                }
                else
                {
                    //其他语言不支持，默认为简体中文
                    language = @"zh-Hans";
                }
                [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"userLanguage"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
        if ([[bundle localizations] containsObject:language])
        {
            bundlePath = [bundle pathForResource:language ofType:@"lproj"];
        }
        
        bundle = [NSBundle bundleWithPath:bundlePath] ?: [NSBundle mainBundle];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
@end
