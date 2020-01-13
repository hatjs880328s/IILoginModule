//
//  GetDeviceUUIDClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "GetDeviceUUIDClass.h"
#import "KeyChainStore.h"

static GetDeviceUUIDClass *instance = nil;

@implementation GetDeviceUUIDClass
//创建单例
+(instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法，因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

// 防止外部调用alloc或者new
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    return [GetDeviceUUIDClass shareInstance];
}

// 防止外部调用copy
-(id)copyWithZone:(nullable NSZone *)zone {
    return [GetDeviceUUIDClass shareInstance];
}

// 防止外部调用mutableCopy
-(id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [GetDeviceUUIDClass shareInstance];
}

//获取设备UUID
- (NSString *)getDeviceUUID {
    NSString * strUUID = (NSString *)[KeyChainStore IIPRIVATE_load:@"com.inspur.impcloud.uuid"];
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID) {
        strUUID = [self.delegate value];
        //将该uuid保存到keychain
        [KeyChainStore save:@"com.inspur.impcloud.uuid" data:strUUID];
    }
    return strUUID;
}

@end
