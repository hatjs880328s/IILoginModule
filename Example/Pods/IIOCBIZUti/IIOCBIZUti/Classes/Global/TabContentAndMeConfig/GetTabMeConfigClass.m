//
//  GetTabMeConfigClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/26.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "GetTabMeConfigClass.h"
#import "MeConfigModel.h"
#import "IMPUserModel.h"
#import "Constants.h"

@import II18N;

@implementation GetTabMeConfigClass

//获取“我”相关配置
+(NSArray *)getMeConfig {
    NSArray *tabArr = [[NSUserDefaults standardUserDefaults] objectForKey:UserTabCon];
    NSArray *arr = [[NSArray alloc] init];
    if (tabArr.count > 0) {
        for (int i=0; i<tabArr.count; i++) {
            if ([tabArr[i][@"name"] isEqualToString:Tab_Me] && [tabArr[i] objectForKey:@"properties"] && [[tabArr[i] objectForKey:@"properties"] objectForKey:@"tablist"] && ([(NSArray *)[[tabArr[i] objectForKey:@"properties"] objectForKey:@"extendList"] count] > 0 || [(NSArray *)[[tabArr[i] objectForKey:@"properties"] objectForKey:@"tablist"] count] > 0)) {
                if ([[(NSDictionary *)[tabArr[i] objectForKey:@"properties"] allKeys] containsObject:@"extendList"]) {
                    arr = [self getNewRemoteMeConfigArr:(NSArray *)[[tabArr[i] objectForKey:@"properties"] objectForKey:@"extendList"]];
                }
                else if ([[(NSDictionary *)[tabArr[i] objectForKey:@"properties"] allKeys] containsObject:@"tablist"]) {
                    arr = [self getOldRemoteMeConfigArr:(NSArray *)[[tabArr[i] objectForKey:@"properties"] objectForKey:@"tablist"]];
                }
                else {
                    arr = [self getDefaultMeConfigArr];
                    return arr;
                }
            }
        }
        if (arr.count > 0) {
            return arr;
        }
        else {
            arr = [self getDefaultMeConfigArr];
            return arr;
        }
    }
    else {
        arr = [self getDefaultMeConfigArr];
        return arr;
    }
}

+ (NSArray *)getDefaultMeConfigArr {
    NSArray *arr = @[@[@{
                           @"name":@"my_personalInfo_function",
                           @"url":@"",
                           @"displayName":@"",
                           @"ico":@""
                           }],@[
                         @{
                             @"name":@"my_setting_function",
                             @"url":@"",
                             @"displayName":IMPLocalizedString(@"My_setting"),
                             @"ico":@"personcenter_setting"
                             }],@[
                         @{
                             @"name":@"my_cardbox_function",
                             @"url":@"",
                             @"displayName":IMPLocalizedString(@"discovery_mainpage_cardbox"),
                             @"ico":@"personcenter_cardbox"
                             }],@[
                         @{
                             @"name":@"my_aboutUs_function",
                             @"url":@"",
                             @"displayName":IMPLocalizedString(@"My_setting_about"),
                             @"ico":@"personcenter_aboutus"
                             }]];
    return arr;
}

+ (NSArray *)getNewRemoteMeConfigArr:(NSArray *)arr {
    NSMutableArray *targetArr = [[NSMutableArray alloc] init];
    for (int i=0; i<arr.count; i++) {
        NSArray *tempArr = [arr objectAtIndex:i];
        NSMutableArray *tempDataArr = [[NSMutableArray alloc] init];
        for (int j=0; j<tempArr.count; j++) {
            MeConfigModel *model = [[MeConfigModel alloc] initWithDictionary:(NSDictionary *)[tempArr objectAtIndex:j]];
            NSString *displayName = [self getMeConfigTitle:model.title];
            NSDictionary *dic = @{
                                  @"name":model.id,
                                  @"url":model.uri,
                                  @"displayName":displayName,
                                  @"ico":model.ico
                                  };
            [tempDataArr addObject:dic];
        }
        [targetArr addObject:[tempDataArr copy]];
    }
    NSArray *dataSource = [targetArr copy];
    if (dataSource.count == 0) {
        dataSource = [self getDefaultMeConfigArr];
    }
    return dataSource;
}

+ (NSArray *)getOldRemoteMeConfigArr:(NSArray *)arr {
    NSMutableArray *targetArr = [[NSMutableArray alloc] init];
    for (int i=0; i<arr.count; i++) {
        NSArray *tempArr = [arr objectAtIndex:i];
        NSMutableArray *tempDataArr = [[NSMutableArray alloc] init];
        for (int j=0; j<tempArr.count; j++) {
            NSString *name = @"";
            if (tempArr.count > 0) {
                name = [tempArr objectAtIndex:j];
            }
            NSString *url = @"";
            NSString *displayName = @"";
            NSString *ico = @"";
            if (name == nil) {
                name = @"";
            }
            else if ([name isEqualToString:@"my_setting_function"]) {
                displayName = IMPLocalizedString(@"My_setting");
                ico = @"personcenter_setting";
            }
            else if ([name isEqualToString:@"my_cardbox_function"]) {
                displayName = IMPLocalizedString(@"discovery_mainpage_cardbox");
                ico = @"personcenter_cardbox";
            }
            else if ([name isEqualToString:@"my_aboutUs_function"]) {
                displayName = IMPLocalizedString(@"My_setting_about");
                ico = @"personcenter_aboutus";
            }
            else if ([name isEqualToString:@"my_feedback_function"]) {
                displayName = IMPLocalizedString(@"My_feedback");
                ico = @"personcenter_feedback";
            }
            else if ([name isEqualToString:@"my_customerService_function"]) {
                displayName = IMPLocalizedString(@"Cloud_Page_Customer_Service");
                ico = @"personcenter_customerservice";
            }
            NSDictionary *dic = @{
                                  @"name":name,
                                  @"url":url,
                                  @"displayName":displayName,
                                  @"ico":ico
                                  };
            [tempDataArr addObject:dic];
        }
        [targetArr addObject:[tempDataArr copy]];
    }
    NSArray *dataSource = [targetArr copy];
    if (dataSource.count == 0) {
        dataSource = [self getDefaultMeConfigArr];
    }
    return dataSource;
}

+ (NSString *)getMeConfigTitle:(NSDictionary *)dic {
    NSString *title;
    if ([[IMPI18N userLanguage] isEqualToString:@"zh-Hans"]) {
        title = blankOrJSONObjectForKey(dic, @"zh-Hans");
    }
    else if ([[IMPI18N userLanguage] isEqualToString:@"en"]) {
        title = blankOrJSONObjectForKey(dic, @"en-US");
    }
    else {
        title = blankOrJSONObjectForKey(dic, @"zh-Hant");
    }
    if (title.length == 0) {
        title = @"";
    }
    return title;
}

@end
