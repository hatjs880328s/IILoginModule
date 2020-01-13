//
//  PhotoImageDataModel.m
//  impcloud
//
//  Created by Elliot on 16/3/24.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import "PhotoImageDataDAL.h"
#import "GlobalAction.h"
#import "TakeRouterSocketAdressClass.h"
#import "Utilities.h"

@implementation PhotoImageDataDAL

-(id)initWithUserID:(NSString *)uid {
    self = [super init];
    if (!self) {
        return nil;
    }
    if ([[GlobalAction shareInstance] getPBAvatarExist:uid] == 1) {
        //服务端有设置头像
        NSString *iconUT = [[GlobalAction shareInstance] getPBUpdateTimeById:uid];
        self.url = [NSString stringWithFormat:@"%@%@%@?%@",[TakeRouterSocketAdressClass getAppEMMIP],@"/api/sys/v3.0/img/userhead/", uid, iconUT];
    }
    else {
        //服务端无头像
        if ([[GlobalAction shareInstance] getPBRealNameById:uid].length != 0) {
            self.img = [Utilities getAvatarByText:[[GlobalAction shareInstance] getPBRealNameById:uid]];
        }
        else {
            self.img = [UIImage imageNamed:@"Personal Large"];
        }
    }
    return self;
}

@end
