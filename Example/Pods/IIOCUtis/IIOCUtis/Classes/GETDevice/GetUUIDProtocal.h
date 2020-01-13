//
//  GetUUIDProtocal.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/4/8.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN

/*
 此接口作用；
 放到POD管理
 引入此GetUUIDProtocal之后调用接口方法，启动服务时，进行处理
 */

@protocol GetUUIDProtocal <NSObject>

//获取设备UUID
+ (NSString *)value;

@end


//NS_ASSUME_NONNULL_END
