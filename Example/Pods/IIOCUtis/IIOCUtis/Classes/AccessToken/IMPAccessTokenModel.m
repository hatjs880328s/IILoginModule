// ==============================================================================
//
// This file is part of the IMP Cloud.
//
// Create by Shiguang <shiguang@richingtech.com>
// Copyright (c) 2016-2017 inspur.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================


#import "IMPAccessTokenModel.h"
#import "MJExtension.h"

#define kUserAccessToken @"UserAccessToken"

@implementation IMPAccessTokenModel

static IMPAccessTokenModel *sharedInstance = nil;

+ (IMPAccessTokenModel *)activeToken {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAccessToken];
        sharedInstance = [IMPAccessTokenModel mj_objectWithKeyValues:dic];
        if(sharedInstance == nil){
            sharedInstance = [[IMPAccessTokenModel alloc] init];
        }
    });
    return sharedInstance;
}

+ (void)IIPRIVATE_setActiveToken:(IMPAccessTokenModel *)token {
    if (token == nil) {
        [[IMPAccessTokenModel activeToken] reset];
        return;
    }
    if(sharedInstance != nil){
        //实际上，这里接收的token对象会先通过activeToken获得sharedInstance，按照当前的写法，在外部设置值的时候已经把sharedInstance的数值更改了
        sharedInstance.userId = token.userId;
        sharedInstance.accessToken = token.accessToken;
        sharedInstance.refreshToken = token.refreshToken;
        sharedInstance.expireDate = token.expireDate;
        sharedInstance.tokenType = token.tokenType;
        sharedInstance.isExpired = token.isExpired;
    }else {
        sharedInstance = token;
    }
    [[NSUserDefaults standardUserDefaults] setObject:token.mj_keyValues forKey:kUserAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDictionary *) mj_replacedKeyFromPropertyName {
    return @{
             @"userId" : @"user_id",
             @"accessToken" : @"accessToken",
             @"refreshToken" : @"refreshToken",
             @"expireDate" : @"expiration",
             @"tokenType" : @"tokenType",
             @"isExpired" : @"isExpired"
             };
}

- (void)exeofsetUserToken:(NSDictionary *)dic {
    IMPAccessTokenModel *model = [IMPAccessTokenModel activeToken];
    model.tokenType = dic[@"token_type"];
    model.accessToken = dic[@"access_token"];
    model.refreshToken = dic[@"refresh_token"];
    int expireIn = [dic[@"expires_in"] intValue];
    model.expireDate = [[NSDate date] dateByAddingTimeInterval:expireIn];
    [IMPAccessTokenModel IIPRIVATE_setActiveToken:model];
}

- (BOOL)isValid {
    return self.accessToken.length >0 && !_isExpired;
}

- (void)reset {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];

    sharedInstance.userId = nil;
    sharedInstance.accessToken = nil;
    sharedInstance.refreshToken = nil;
    sharedInstance.expireDate = nil;
    sharedInstance.tokenType = nil;
    sharedInstance.isExpired = YES;
}
@end
