//
//  SetSDImageHeaderClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "SetSDImageHeaderClass.h"
#import "IMPUserModel.h"
#import "Utilities.h"
#import "GetDeviceUUIDClass.h"
#import "IMPAccessTokenModel.h"
#import "SDWebImageManager.h"

@implementation SetSDImageHeaderClass

//图片请求增加身份验证所需参数
+(void)setSDWebImageHeader {
    SDWebImageDownloader *sdmanager = [SDWebImageManager sharedManager].imageDownloader;
    [sdmanager setValue:[NSString stringWithFormat:@"iOS/%@(Apple %@) CloudPlus_Phone/%@",[Utilities getDeviceiOSVersion],[Utilities getDeviceKey],[Utilities getAPPCurrentVersion]] forHTTPHeaderField:@"User-Agent"];
    [sdmanager setValue:[[GetDeviceUUIDClass shareInstance] getDeviceUUID] forHTTPHeaderField:@"X-Device-ID"];
    NSString *id_Enterprise = [NSString stringWithFormat:@"%d",[IMPUserModel activeInstance].enterprise.id];
    if (id_Enterprise.length != 0) {
        [sdmanager setValue:id_Enterprise forHTTPHeaderField:@"X-ECC-Current-Enterprise"];
    }
    if ([IMPAccessTokenModel activeToken].accessToken.length > 0) {
        [sdmanager setValue:[NSString stringWithFormat:@"Bearer %@", [IMPAccessTokenModel activeToken].accessToken] forHTTPHeaderField:@"Authorization"];
    }
}

@end
