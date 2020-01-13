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


#import "IMPUserModel.h"
#import "MJExtension.h"

#define KActiveUser                     @"ActiveUser"

@implementation IMPUserModel

static IMPUserModel *sharedInstance;

// mapping
+(NSDictionary *) mj_replacedKeyFromPropertyName {
    return @{
             @"code" : @"code",
             @"id" : @"id",
             @"email" : @"mail",
             @"phone" : @"phone",
             @"firstName" : @"first_name",
             @"lastName" : @"last_name",
             @"gender" : @"gender",
             @"locale" : @"locale",
             @"createdAt" : @"creation_date",
             @"avatar" : @"avatar",
             @"state" : @"state",
             @"enterprise" : @"enterprise",
             @"enterprises" : @"enterprises",
             @"oldId" : @"old_id",
             @"has_password" : @"has_password"
             };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"createdAt"]) {
        if (oldValue == nil) return @"";
    }
    else if (property.type.typeClass == [NSDate class]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt dateFromString:oldValue];
    }
    return oldValue;
}

+ (id)activeInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IMPUserModel alloc] init];//在耗时操作前先执行一个简单的初始化
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:KActiveUser];
        sharedInstance = [IMPUserModel mj_objectWithKeyValues:dic];
    });
    return sharedInstance ;
}

//代码拆分
+ (BOOL)IIPRIVATE_setActiveInstance:(IMPUserModel *)user {
    NSString *strAppOAuthIP = @"https://id.inspuronline.com";
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"kAppMainIP"];
    if (str.length != 0) {
        strAppOAuthIP = str;
    }
    NSDictionary *defaultEnterprise = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%d_Default_Enterprise", strAppOAuthIP,[IMPUserModel activeInstance].id]];
    IMPEnterpriseModel *oldEnterpriseModel = [IMPEnterpriseModel mj_objectWithKeyValues:defaultEnterprise];
    BOOL isSameUser = YES;
    if(user.id != sharedInstance.id || oldEnterpriseModel.id != sharedInstance.enterprise.id) {
        isSameUser = NO;
    }
    sharedInstance = user;
    if (user) {
        [[NSUserDefaults standardUserDefaults] setObject:[user mj_keyValues] forKey:KActiveUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KActiveUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return isSameUser;
}

- (NSString *)userName {
    if(self.firstName == nil){
        self.firstName = @"";
    }
    if(self.lastName == nil){
        self.lastName = @"";
    }
    return [NSString stringWithFormat:@"%@%@", self.firstName, self.lastName];
}

- (NSString *)exeofidString {
    if (self.id >0) {
        return [NSString stringWithFormat:@"%d",self.id];
    }
    else {
        return @"";
    }
}

- (NSString *)userEmail {
    if(self.email == nil) {
        self.email = @"";
    }
    return self.email;
}

- (NSString *)userMobile {
    if(self.phone == nil) {
        self.phone = @"";
    }
    return self.phone;
}

- (NSArray *)getEnterprises {
    return self.enterprises;
}

- (void)reset {
    sharedInstance = [IMPUserModel mj_objectWithKeyValues:[[NSDictionary alloc] init]];
    [[NSUserDefaults standardUserDefaults] setObject:[sharedInstance mj_keyValues] forKey:KActiveUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
