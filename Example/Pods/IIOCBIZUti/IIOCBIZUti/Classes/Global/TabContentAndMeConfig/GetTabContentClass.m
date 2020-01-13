//
//  GetTabContentClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/26.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "GetTabContentClass.h"
#import "GetTabMeConfigClass.h"
#import "IMPUserModel.h"
#import "Constants.h"

@implementation GetTabContentClass

//获取Tab内容
+(NSArray *)getTabContent {
    //先判定布局数据Data是否有值
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:MultipleLayoutData];
    if (dic != nil) {
        //目标数组
        NSArray *targetArr = [[NSArray alloc] init];
        //系统默认数组
        NSArray *defaultArr = [[NSArray alloc] init];
        //是否包含默认布局
        BOOL isContainDefaultScheme = NO;
        //数据源
        NSArray *arr = [dic objectForKey:@"schemes"];
        //是否包含用户选择的布局
        BOOL isContainScheme = NO;
        //再判定用户是否选择了布局
        NSString *selectScheme = [[NSUserDefaults standardUserDefaults] objectForKey:MultipleLayoutSelectScheme];
        if (selectScheme == nil) {
            //用户没有选择布局，走默认defaultScheme
            selectScheme = [dic objectForKey:@"defaultScheme"];
        }
        for (int i=0; i<arr.count; i++) {
            if ([[[arr objectAtIndex:i] objectForKey:@"name"] isEqualToString:selectScheme]) {
                //包含用户选择的布局
                isContainScheme = YES;
                targetArr = [[arr objectAtIndex:i] objectForKey:@"tabs"];
                //判空处理
                if (targetArr.count == 0) {
                    //使用默认MainTab数据
                    targetArr = [self getDefaultTabContent];
                }
            }
            if (selectScheme != nil && [[[arr objectAtIndex:i] objectForKey:@"name"] isEqualToString:[dic objectForKey:@"defaultScheme"]]) {
                //不包含用户选择的布局但数据源中有默认布局
                isContainDefaultScheme = YES;
                defaultArr = [[arr objectAtIndex:i] objectForKey:@"tabs"];
            }
        }
        if (isContainScheme) {
            //含有
            [[NSUserDefaults standardUserDefaults] setObject:selectScheme forKey:MultipleLayoutSelectScheme];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else {
            //已删除，判断数据中是否包含默认值
            if (isContainDefaultScheme) {
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"defaultScheme"] forKey:MultipleLayoutSelectScheme];
                [[NSUserDefaults standardUserDefaults] synchronize];
                targetArr = defaultArr;
            }
            else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:MultipleLayoutSelectScheme];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //使用默认MainTab数据
                targetArr = [self getDefaultTabContent];
            }
        }
        return targetArr;
    }
    else {
        //使用默认MainTab数据
        return [self getDefaultTabContent];
    }
}

//获取默认MainTab数据
+ (NSArray *)getDefaultTabContent {
    NSArray *tabArr = [[NSUserDefaults standardUserDefaults] objectForKey:UserTabCon];
    if (tabArr.count > 0) {
        return tabArr;
    }
    else {
        tabArr = @[@{
                       @"name"            :       @"application",
                       @"ico"             :       @"application",
                       @"selected"        :       @"1",
                       @"title"           :       @{@"en-US" : @"Apps",@"zh-Hans" : @"应用",@"zh-Hant" : @"應用"},
                       @"type"            :       @"native",
                       @"uri"             :       @"native://application"
                       },
                   @{
                       @"name"            :       @"me",
                       @"ico"             :       @"me",
                       @"selected"        :       @"0",
                       @"title"           :       @{@"en-US" : @"Me",@"zh-Hans" : @"我",@"zh-Hant" : @"我"},
                       @"type"            :       @"native",
                       @"uri"             :       @"native://me",
                       @"properties"      :       @{@"extendList" : [GetTabMeConfigClass getDefaultMeConfigArr]}
                       }];
        return tabArr;
    }
}

@end
