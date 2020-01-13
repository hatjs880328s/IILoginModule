//
//  IILoginVCBLL.m
//  CloudLoginModule
//
//  Created by xin on 2020/1/3.
//  Copyright © 2020 xin. All rights reserved.
//

#import "IILoginVCBLL.h"
#import "IMPAccessTokenModel.h"
#import <IIOCBIZUti/IMPHttpSvc.h>
#import <IIOCBIZUti/AFHTTPRequestOperation+IMPKit.h>
#import "GlobalAction.h"
#import "TakeRouterSocketAdressClass.h"
#import "MJExtension.h"
#import "Constants.h"
#import "IILoginModuleAction.h"


@implementation IILoginVCBLL

//登录获取token
- (void)IIPRIVATE_checkLoginForUser:(NSString *)user IIPRIVATE_withPassword:(NSString *)password finishBlock:(FinishWithErrorBlock)finishBlock {
    
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [IMPHttpSvc requestAuthTokenWithUserName:[user stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] password:password complete:^(BOOL success, AFOAuthCredential *credential, int code, NSError *_Nullable error) {
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
        
        //统计
        if ([IILoginModuleAction sharedObject].httpCollectBlock) {
            [IILoginModuleAction sharedObject].httpCollectBlock(@"oauth2.0/token", startTime, endTime);
        }

        if (success) {
            
            if ([IILoginModuleAction sharedObject].saveLastLoginUserNameBlock) {
                [IILoginModuleAction sharedObject].saveLastLoginUserNameBlock(user);
            }
            
            IMPAccessTokenModel *token = [IMPAccessTokenModel activeToken];
            token.tokenType = credential.tokenType;
            token.accessToken = credential.accessToken;
            token.refreshToken = credential.refreshToken;
            token.expireDate = credential.expiration;
            token.isExpired = credential.isExpired;
            [IMPAccessTokenModel IIPRIVATE_setActiveToken:token];
            //记录刷新时间
            [[NSUserDefaults standardUserDefaults] setInteger:[[NSDate date] timeIntervalSince1970] forKey:[NSString stringWithFormat:@"%@_%d_refreshATTime",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self queryUserProfileWithFinishBlock:finishBlock];
        }
        else {
            [[IMPAccessTokenModel activeToken] reset];
            if (finishBlock) {
                finishBlock(error);
            }
        }
    }];
}

/// 获取用户信息
- (void)queryUserProfileWithFinishBlock:(FinishWithErrorBlock)finishBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/oauth2.0/profile",[TakeRouterSocketAdressClass getAppOAuthIP]];
    
    //监测请求时间
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [IMPHttpSvc GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
        
        //统计
        if ([IILoginModuleAction sharedObject].httpCollectBlock) {
            [IILoginModuleAction sharedObject].httpCollectBlock(url, startTime, endTime);
        }
        
        if (responseObject == nil || [responseObject isEqual:[NSNull null]] || [responseObject isEqual:@""]) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"无效的返回值" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"LoginAndLogout" code:0 userInfo:userInfo];
            if (finishBlock) {
                finishBlock(error);
            }
        }
        else {
            IMPUserModel *userModel = [IMPUserModel mj_objectWithKeyValues:responseObject];
            if ([IILoginModuleAction sharedObject].saveUserModelBlock) {
                [IILoginModuleAction sharedObject].saveUserModelBlock(userModel);
            }
            
            //20180730,Elliot,增加当用户默认企业及多企业均为空时，不准进入并合理提示
            if (userModel.enterprise == nil && userModel.enterprises.count == 0) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"无效的返回值" forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"LoginAndLogout" code:-10086 userInfo:userInfo];
                if (finishBlock) {
                    finishBlock(error);
                }
            }
            else {
                if (userModel.enterprises.count > 1) {
                    NSDictionary *defaultEnterprise = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultEnterprise];
                    IMPEnterpriseModel *oldEnterpriseModel = [IMPEnterpriseModel mj_objectWithKeyValues:defaultEnterprise];
                    int localId = oldEnterpriseModel.id;
                    BOOL isExistDefaultEnterpriseID = NO;
                    for (int i = 0; i< userModel.enterprises.count; i ++) {
                        IMPEnterpriseModel *enterprisesModel = [IMPEnterpriseModel mj_objectWithKeyValues:userModel.enterprises[i]];
                        if (enterprisesModel.id == localId) {
                            isExistDefaultEnterpriseID = YES;
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[userModel.enterprises[i] mj_keyValues]];
                            if([[defaultEnterprise allKeys] containsObject:@"rememberFlag"]) {
                                [dic setObject:[defaultEnterprise objectForKey:@"rememberFlag"] forKey:@"rememberFlag"];
                            }
                            if([[defaultEnterprise allKeys] containsObject:@"cacheFlag"]) {
                                [dic setObject:[defaultEnterprise objectForKey:@"cacheFlag"] forKey:@"cacheFlag"];
                            }
                            if([[defaultEnterprise allKeys] containsObject:@"switchFlag"]) {
                                [dic setObject:[defaultEnterprise objectForKey:@"switchFlag"] forKey:@"switchFlag"];
                            }
                            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:DefaultEnterprise];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            userModel.enterprise = enterprisesModel;
                        }
                    }
                    if (isExistDefaultEnterpriseID == NO) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DefaultEnterprise];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                else {
                    //20180730,Elliot,此处需要判断如果enterprise为空，但enterprises不为空的情况，取第一个
                    if (userModel.enterprise == nil) {
                        if (userModel.enterprises.count > 0) {
                            IMPEnterpriseModel *enterprisesModel = [IMPEnterpriseModel mj_objectWithKeyValues:userModel.enterprises[0]];
                            [[NSUserDefaults standardUserDefaults] setObject:[enterprisesModel mj_keyValues] forKey:DefaultEnterprise];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[userModel mj_keyValues]];
                            [dic setObject:userModel.enterprises[0] forKey:@"enterprise"];
                            userModel = [IMPUserModel mj_objectWithKeyValues:dic];
                        }
                    }
                    else {
                        [[NSUserDefaults standardUserDefaults] setObject:[userModel.enterprise mj_keyValues] forKey:DefaultEnterprise];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([IILoginModuleAction sharedObject].saveUserModelBlock) {
                    [IILoginModuleAction sharedObject].saveUserModelBlock(userModel);
                }
                if (finishBlock) {
                    finishBlock(nil);
                }
            }
        }
    }
            failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
                //统计
                if ([IILoginModuleAction sharedObject].httpCollectBlock) {
                    [IILoginModuleAction sharedObject].httpCollectBlock(url, startTime, endTime);
                }
                
                [[IMPUserModel activeInstance] reset];
                [[IMPAccessTokenModel activeToken] reset];
                NSObject *defaultEnterprise = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultEnterprise];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)defaultEnterprise];
                if ([[dic allKeys] containsObject:@"switchFlag"]) {
                    [dic removeObjectForKey:@"switchFlag"];
                }
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:DefaultEnterprise];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (error == nil) {
                    NSString *domain = @"com.inspur.ErrorDomain";
                    NSString *desc = @"error";
                    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
                    error = [NSError errorWithDomain:domain code:-1009 userInfo:userInfo];
                }
                if (finishBlock) {
                    finishBlock(error);
                }
            }];
}


@end
