//
//  QueryUserDisplayInfoClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/26.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "QueryUserDisplayInfoClass.h"
#import "IMPUserModel.h"

@implementation QueryUserDisplayInfoClass

/*个人信息相关*/
//  获取个人信息
+(nullable UserInfoDisplayConfigModel *)queryUserDisplayInfo {
    //  UserInfoDisplayConfigModel初始化
    UserInfoDisplayConfigModel *dataSource = [[UserInfoDisplayConfigModel alloc] init];
    //  Name
    //  增加userName判空处理
    NSString *userName = [IMPUserModel activeInstance].userName;
    if (userName == nil) {
        userName = @"";
    }
    ShowUserDisplayModel *name = [[ShowUserDisplayModel alloc] initWithDictionary:@{@"value":userName, @"show":@YES}];
    dataSource.name = name;
    //  头像
    ShowUserDisplayModel *headUrl = [[ShowUserDisplayModel alloc] initWithDictionary:@{@"value":@"", @"show":@YES}];
    dataSource.headUrl = headUrl;
    //  EnterpriseName
    //  增加EnterpriseName判空处理
    NSString *eName = [IMPUserModel activeInstance].enterprise.name;
    if (eName == nil) {
        eName = @"";
    }
    ShowUserDisplayModel *enterpriseName = [[ShowUserDisplayModel alloc] initWithDictionary:@{@"value":eName, @"show":@YES}];
    dataSource.enterpriseName = enterpriseName;
    return dataSource;
}

@end
