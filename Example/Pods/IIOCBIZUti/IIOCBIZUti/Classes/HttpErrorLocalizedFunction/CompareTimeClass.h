//
//  CompareTimeClass.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CompareTimeClass : NSObject

//获取时间戳的本地描述,同上边的方法一样    --Add by Jacky zang.
+ (NSString *)showDescriptionForTimestamp:(NSTimeInterval)timestamp;
//将UTC日期字符串转为本地时间字符串
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;
//和当前时间比较
+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *)formate;
//日期转星期
+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate;

@end

NS_ASSUME_NONNULL_END
