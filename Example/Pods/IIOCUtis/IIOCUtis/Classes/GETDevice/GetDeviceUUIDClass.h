//
//  GetDeviceUUIDClass.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetUUIDProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetDeviceUUIDClass : NSObject

//创建单例
+(instancetype)shareInstance;

//获取设备UUID
- (NSString *)getDeviceUUID;

//代理
@property (strong, nonatomic) id <GetUUIDProtocal> delegate;

@end

NS_ASSUME_NONNULL_END
