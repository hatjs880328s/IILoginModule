//
//  ActionForCheck.m
//  impcloud
//
//  Created by Jacky Zang on 2017/7/6.
//  Copyright © 2017年 Elliot. All rights reserved.
//

#import "ActionForCheck.h"
#import "ContactLoadScreen.h"
#import "GetTabContentClass.h"
#import "SetSDImageHeaderClass.h"
#import "TakeRouterSocketAdressClass.h"
#import "IMPUserModel.h"
#import "Constants.h"
#import "GetDeviceUUIDClass.h"
#import "IMPHttpSvc.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"

#define requestTabBarMaxNum 3

@interface ActionForCheck() {
    BOOL needQueryMainTab;
    BOOL needQuery3DTouch;
    BOOL needQueryAdvert;
    BOOL needQueryApplication;
    CheckQuerySuccessHandler mainTabHandler;
    CheckQuerySuccessHandler touchHandler;
    CheckQuerySuccessHandler advertHandler;
}

@end

@implementation ActionForCheck

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static ActionForCheck *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)queryClientId {
    if ([IMPUserModel activeInstance].id == 0) {
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kBOOLClientId] == YES && [[NSUserDefaults standardUserDefaults] objectForKey:keyForClientId]) {
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:keyForClientId]) {
        [self checkTabMenu:0];
        [self checkLanuchAdvert];
        [self checkRecommendApps];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            [self check3dTouchMenu];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kBOOLClientId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSObject *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    if (![deviceToken isKindOfClass:[NSString class]] || [(NSString *)deviceToken length] == 0) {
        deviceToken = @"UNKNOWN";
    }
    NSString *deviceName = [NSString stringWithFormat:@"%@[%@]", [[[UIDevice currentDevice] model] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *deviceId = [[GetDeviceUUIDClass shareInstance] getDeviceUUID];
    NSString *url = [NSString stringWithFormat: @"%@/client", [TakeRouterSocketAdressClass getAppECMIP_ClientRegistry]];
    NSDictionary *dict = @{@"deviceId"              :  deviceId,
                           @"deviceName"            :  deviceName,
                           @"notificationProvider"  :  @"com.apple.push",
                           @"notificationTracer"    :  deviceToken};
    [IMPHttpSvc POST:url parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kBOOLClientId];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"id"] forKey:keyForClientId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self queryClientId];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kBOOLClientId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(![[ContactLoadScreen sharedInstance] isHidden]) {
            [[ContactLoadScreen sharedInstance] finishTabBar];
        }
    }];
}

- (void)checkRecommendApps {
    NSInteger daysSince1970 = floor([[NSDate date] timeIntervalSince1970]/(3600.0*24));
    NSDictionary *recommendInfo = [[NSUserDefaults standardUserDefaults] objectForKey:RecommendAPPs];
    NSInteger createAtDaysSince1970 = [recommendInfo objectForKey:@"createAtDaysSince1970"] ? [[recommendInfo objectForKey:@"createAtDaysSince1970"] integerValue] : 0;
    if (daysSince1970 <= createAtDaysSince1970) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/api/mam/v6.0/app/recommend/apps",[TakeRouterSocketAdressClass getAppEMMIP]];
    [IMPHttpSvc GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSMutableDictionary *recommendApps = [[NSMutableDictionary alloc] initWithDictionary: responseObject];
        [recommendApps setObject:[NSNumber numberWithInteger:daysSince1970] forKey:@"createAtDaysSince1970"];
        [[NSUserDefaults standardUserDefaults] setObject:recommendApps forKey: RecommendAPPs];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {}];
}

- (void)needQuery3DTouch:(BOOL)ifNeed withSuccessHandler:(CheckQuerySuccessHandler)handler{
    needQuery3DTouch = ifNeed;
    touchHandler = handler;
    if (ifNeed && [[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        [self check3dTouchMenu];
    }
}

- (void)needQueryAdvert:(BOOL)ifNeed withSuccessHandler:(CheckQuerySuccessHandler)handler{
    needQueryAdvert = ifNeed;
    advertHandler = handler;
    if (ifNeed) {
        [self checkLanuchAdvert];
    }
}

- (void)needQueryMainTab:(BOOL)ifNeed withSuccessHandler:(CheckQuerySuccessHandler)handler{
    needQueryMainTab = ifNeed;
    mainTabHandler = handler;
    if (ifNeed) {
        [self checkTabMenu:0];
    }
}

- (BOOL)getNeedRefreshApplication {
    return needQueryApplication;
}

- (void)setNeedRefreshApplication:(BOOL)ifNeed {
    needQueryApplication = ifNeed;
}

- (void)checkTabMenu:(NSInteger)failureNum {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kBOOLClientId] == YES || ![[NSUserDefaults standardUserDefaults] objectForKey:keyForClientId] || !needQueryMainTab) {
        return;
    }
    NSString *clientId = [[NSUserDefaults standardUserDefaults] objectForKey:keyForClientId];
    __block NSString *localVer = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserTabConVer])
        localVer = [[NSUserDefaults standardUserDefaults] objectForKey:UserTabConVer];
    NSString *url = [NSString stringWithFormat:@"%@/preference/main-tab/latest?version=%@&clientId=%@", [TakeRouterSocketAdressClass getAppECMIP_Distribution]  , localVer, clientId];
    [IMPHttpSvc GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] containsObject:@"command"]) {
            if ([responseObject[@"command"] isEqualToString:@"FORWARD"]) {
                NSArray *tabs = responseObject[@"payload"][@"tabs"];
                [[NSUserDefaults standardUserDefaults] setObject:tabs forKey:UserTabCon];
                NSString *version = @"";
                if (responseObject[@"payload"][@"version"]) {
                    version = responseObject[@"payload"][@"version"];
                }
                [[NSUserDefaults standardUserDefaults] setObject:version forKey:UserTabConVer];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:NSClassFromString(@"ViewController")]) {
                    if ([[UIApplication sharedApplication].delegate.window.rootViewController respondsToSelector:@selector(refreshTabWithIsMainTabCall:)]) {
                        [[UIApplication sharedApplication].delegate.window.rootViewController performSelector:@selector(refreshTabWithIsMainTabCall:) withObject:[NSNumber numberWithBool:YES]];
                    }
                    for (int i = 0; i < tabs.count; i++) {
                        if ([tabs[i][@"name"] isEqualToString:Tab_Discover] && [tabs[i][@"uri"] isEqualToString:Tab_RN_Discover_Uri]) {
                            [self checkRNDiscover];
                        }
                    }
                }
            }
            else {
                NSArray *tabArr = [GetTabContentClass getTabContent];
                for (int i = 0; i < tabArr.count; i++) {
                    if ([tabArr[i][@"name"] isEqualToString:Tab_Discover] && [tabArr[i][@"uri"] isEqualToString:Tab_RN_Discover_Uri]) {
                        [self checkRNDiscover];
                    }
                }
            }
        }
        if(![[ContactLoadScreen sharedInstance] isHidden]) {
            [[ContactLoadScreen sharedInstance] finishTabBar];
        }
        self->needQueryMainTab = NO;
        self->mainTabHandler(YES);
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        //增加失败重传机制
        if(failureNum == 0) {
            //失败一次后就把加载中放开
            if (![[ContactLoadScreen sharedInstance] isHidden]) {
                [[ContactLoadScreen sharedInstance] finishTabBar];
            }
        }
        if(failureNum < requestTabBarMaxNum - 1 && ![[TakeRouterSocketAdressClass getAppECMIP_Distribution] isEqualToString:@""]) {
            //确保再次发送请求时路由依旧存在
            [self checkTabMenu:failureNum + 1];
        }
        else {
            self->needQueryMainTab = NO;
        }
    }];
}

- (void)check3dTouchMenu {
    NSString *clientId = [[NSUserDefaults standardUserDefaults] objectForKey:keyForClientId];
    if (!clientId || !needQuery3DTouch || [[NSUserDefaults standardUserDefaults] boolForKey:kBOOLClientId] == YES) {
        return ;
    }
    __block NSString *localVer = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:User3DTouchVer]) {
        localVer = [[NSUserDefaults standardUserDefaults] objectForKey:User3DTouchVer];
    }
    NSString *url = [NSString stringWithFormat:@"%@/preference/quick-launch/latest?version=%@&clientId=%@", [TakeRouterSocketAdressClass getAppECMIP_Distribution], localVer, clientId];
    [IMPHttpSvc GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        self->needQuery3DTouch = NO;
        self->touchHandler(YES);
        if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] containsObject:@"command"] && [responseObject[@"command"] isEqualToString:@"FORWARD"] && [[responseObject allKeys] containsObject:@"payload"]) {
            NSDictionary *dict = [responseObject objectForKey:@"payload"];
            if([[dict allKeys] containsObject:@"items"] && [[dict objectForKey:@"items"] isKindOfClass:[NSArray class]]){
                NSArray *arr = [dict objectForKey:@"items"];
                if (arr.count != 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:User3DTouch];
                    NSString *str = [dict objectForKey:@"version"];
                    [[NSUserDefaults standardUserDefaults] setObject:str forKey:User3DTouchVer];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {self->touchHandler(NO);}];
}

- (void)checkRNDiscover {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *basePath = [documentsPath stringByAppendingPathComponent:@"DiscoverResource"];
    NSString *localPath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].exeofidString]];
    NSString *configPath = [localPath stringByAppendingPathComponent:@"bundle.json"];
    NSData* configData = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *localConfig;
    if (configData) {
        localConfig = [NSJSONSerialization JSONObjectWithData:configData options:kNilOptions error:nil];
    }
    NSString *version = localConfig[@"version"] ? localConfig[@"version"] : @"";
    NSString *creationDate = localConfig[@"creationDate"] ? localConfig[@"creationDate"] : @"0";
    NSString *clientId = [[NSUserDefaults standardUserDefaults] objectForKey:keyForClientId];
    NSString *url = [NSString stringWithFormat:@"%@/view/%@/bundle/?version=%@&lastCreationDate=%@&clientId=%@", [TakeRouterSocketAdressClass getAppECMIP_Distribution]  , @"DISCOVER", version, creationDate, clientId];
    [IMPHttpSvc GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            Class rnView = NSClassFromString(@"ReactNativeView");
            if (rnView != nil) {
                UIViewController *vc = [[NSClassFromString(@"ReactNativeView") alloc] init];
                if ([vc respondsToSelector:@selector(loadBundleFromRemoteWithParam:)]) {
                    [vc performSelector:@selector(loadBundleFromRemoteWithParam:) withObject:responseObject];
                }
            }
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {}];
}

- (void)checkLanuchAdvert {
    __block NSString *clientId = [[NSUserDefaults standardUserDefaults] objectForKey:keyForClientId];
    if(!clientId || !needQueryAdvert || [[NSUserDefaults standardUserDefaults] boolForKey:kBOOLClientId] == YES){
        return ;
    }
    __block NSString *ver = @"";
    NSDictionary *localInfo = [[NSUserDefaults standardUserDefaults] objectForKey:AdvertKey];
    if (localInfo) {
        ver = localInfo[@"version"];
    }
    if (![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:AdvertKey]) {
        ver = @"";
    }
    NSString *url = [NSString stringWithFormat:@"%@/preference/launch-screen/latest?version=%@&clientId=%@", [TakeRouterSocketAdressClass getAppECMIP_Distribution]  , ver, clientId];
    [IMPHttpSvc GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        needQueryAdvert = NO;
        advertHandler(YES);
        NSDictionary *remoteInfo = (NSDictionary *)responseObject;
        if (remoteInfo && [remoteInfo[@"command"] isEqualToString:@"FORWARD"]) {
            NSMutableDictionary *advertInfo = [[NSMutableDictionary alloc] init];
            advertInfo[@"version"] = remoteInfo[@"payload"][@"version"] ? remoteInfo[@"payload"][@"version"] : @"";
            advertInfo[@"res"] = remoteInfo[@"payload"][@"resource"][@"default"][@"res3x"];
            advertInfo[@"expireAt"] = remoteInfo[@"payload"][@"expireDate"];
            advertInfo[@"effectiveAt"] = remoteInfo[@"payload"][@"effectiveDate"];
            advertInfo[@"type"] = @"image";
            NSURL *imageUrl = [NSURL URLWithString: [NSString stringWithFormat:@"%@/avatar/stream/%@",[TakeRouterSocketAdressClass getAppECMIP_StorageLegacy], advertInfo[@"res"]]];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (image) {
                    [SetSDImageHeaderClass setSDWebImageHeader];
                    [[SDImageCache sharedImageCache] removeImageForKey:AdvertKey fromDisk:YES withCompletion:^{}];
                    [[SDImageCache sharedImageCache] storeImage:image forKey:AdvertKey toDisk:YES completion:^{}];
                    [[NSUserDefaults standardUserDefaults] setObject:advertInfo forKey:AdvertKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSDictionary *updateInfo = @{@"preVersion":ver,@"currentVersion":advertInfo[@"version"],@"clientId":clientId,@"command":@"FORWARD"};
                    [self sendLog:updateInfo];
                }
            }];
        }
    }
    failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        advertHandler(NO);
    }];
}

- (void)sendLog:(NSDictionary *)info {
    NSString *url = [NSString stringWithFormat:@"%@/preference/launch-screen/update?preVersion=%@&currentVersion=%@&clientId=%@&command=%@", [TakeRouterSocketAdressClass getAppECMIP_Distribution], info[@"preVersion"], info[@"currentVersion"], info[@"clientId"], info[@"command"]];
    [IMPHttpSvc POST:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {}failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}

//20190424 Elliot 增加multipleLayout
- (void)needQueryMultipleLayoutWithSuccessHandler:(CheckQuerySuccessHandler)handler {
    //获取multipleLayout
    NSString *url = [NSString stringWithFormat:@"%@/api/sys/v6.0/config/multipleLayout",[TakeRouterSocketAdressClass getAppEMMIP]];
    [IMPHttpSvc GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        //确保返回值是个字典且包含defaultScheme字段
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject allKeys] containsObject:@"schemes"]) {
                if (((NSArray *)[responseObject objectForKey:@"schemes"]).count > 0) {
                    //获取布局数据
                    [self saveDataToUserDefaults:responseObject forKey:MultipleLayoutData];
                }
                else {
                    //清除数据
                    [self clearAllData];
                }
            }
            else {
                //清除数据
                [self clearAllData];
            }
        }
        handler(YES);
        //刷新Tab
        if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:NSClassFromString(@"ViewController")]) {
            if ([[UIApplication sharedApplication].delegate.window.rootViewController respondsToSelector:@selector(refreshTabWithIsMainTabCall:)]) {
                [[UIApplication sharedApplication].delegate.window.rootViewController performSelector:@selector(refreshTabWithIsMainTabCall:) withObject:[NSNumber numberWithBool:NO]];
            }
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        //更新失败
        handler(NO);
    }];
}

//清除数据
- (void)clearAllData {
    //清除布局数据
    [self clearUserDefaultsbyKey:MultipleLayoutData];
    //清除选中状态
    [self clearUserDefaultsbyKey:MultipleLayoutSelectScheme];
}

//存储到UserDefaults函数
- (void)saveDataToUserDefaults:(nullable id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//清除UserDefaults函数
- (void)clearUserDefaultsbyKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
