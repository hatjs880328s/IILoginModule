//
//  GetTabMeConfigClass.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/26.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetTabMeConfigClass : NSObject

//获取“我”相关配置
+(NSArray *)getMeConfig;

//获取"我"默认配置
+ (NSArray *)getDefaultMeConfigArr;

@end

NS_ASSUME_NONNULL_END
