//
//  CompareTimeClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "CompareTimeClass.h"
#import "IMPI18N.h"

@implementation CompareTimeClass

/**
 //和当前时间比较
 //1)一分钟以内，         显示:     刚刚
 //2)一小时以内，         显示:     X分钟前
 //3)今天或者昨天         显示:     今天 09:30   昨天 09:30
 //4)今年，              显示:     09月09日
 //5)大于本年，           显示:     2015/09/09
 **/

+ (NSString *)showDescriptionForTimestamp:(NSTimeInterval)timestamp {
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDate * nowDate = [NSDate date];
        NSDate * needFormatDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSDate *lastDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:nowDate];
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - timestamp;
        NSString *dateStr = @"";
        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        NSString *yesterday_yMd = [dateFormatter stringFromDate:lastDate];
        if (time <= 60) {
            //1分钟以内的
            dateStr = IMPLocalizedString(@"Time_recently");
        }
        else if(time <= 60*60) {
            //一个小时以内的
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d%@",mins,IMPLocalizedString(@"Time_minuteAgo")];

        }
        else if ([need_yMd isEqualToString:now_yMd]) {
            //在同一天
            [dateFormatter setDateFormat:@"HH:mm"];
            dateStr = [NSString stringWithFormat:@"%@ %@",IMPLocalizedString(@"Time_today"),[dateFormatter stringFromDate:needFormatDate]];
        }
        else if([need_yMd isEqualToString:yesterday_yMd]) {
            //昨天
            [dateFormatter setDateFormat:@"HH:mm"];
            dateStr = [NSString stringWithFormat:@"%@ %@",IMPLocalizedString(@"Time_yesterday"),[dateFormatter stringFromDate:needFormatDate]];
        }
        else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:IMPLocalizedString(@"Time_monthAndDay")];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
            else {
                [dateFormatter setDateFormat:IMPLocalizedString(@"Time_format")];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

//将UTC日期字符串转为本地时间字符串
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [self formateDate:[dateFormatter stringFromDate:dateFormatted] withFormate:@"yyyy-MM-dd HH:mm:ss"];
    return dateString;
}

/**
 //和当前时间比较
 //1)一分钟以内，         显示:     刚刚
 //2)一小时以内，         显示:     X分钟前
 //3)今天或者昨天         显示:     今天 09:30   昨天 09:30
 //4)今年，              显示:     09月09日
 //5)大于本年，           显示:     2015/09/09
 **/

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *)formate {
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formate];
        NSDate * nowDate = [NSDate date];
        //将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        //取当前时间和转换时间两个日期对象的时间间隔
        //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        //再然后，把间隔的秒数折算成天数和小时数：
        NSString *dateStr = @"";
        if (time<=60) {
            //1分钟以内的
            dateStr = IMPLocalizedString(@"Time_recently");
        }
        else if(time<=60*60) {
            //一个小时以内的
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d%@",mins,IMPLocalizedString(@"Time_minuteAgo")];
        }
        else if(time<=60*60*24) {
            //在两天内的
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //在同一天
                dateStr = [NSString stringWithFormat:@"%@ %@",IMPLocalizedString(@"Time_today"),[dateFormatter stringFromDate:needFormatDate]];
            }
            else {
                //昨天
                dateStr = [NSString stringWithFormat:@"%@ %@",IMPLocalizedString(@"Time_yesterday"),[dateFormatter stringFromDate:needFormatDate]];
            }
        }
        else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:IMPLocalizedString(@"Time_monthAndDay")];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
            else {
                [dateFormatter setDateFormat:IMPLocalizedString(@"Time_format")];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

//日期转星期
+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], IMPLocalizedString(@"MeetingList_page_Sunday"), IMPLocalizedString(@"MeetingList_page_Monday"), IMPLocalizedString(@"MeetingList_page_Tuesday"), IMPLocalizedString(@"MeetingList_page_Wednesday"), IMPLocalizedString(@"MeetingList_page_Thursday"), IMPLocalizedString(@"MeetingList_page_Friday"), IMPLocalizedString(@"MeetingList_page_Saturday"), nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

@end
