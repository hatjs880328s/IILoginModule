//
//  ChannelBody+WCTColumnCoding.mm
//  impcloud
//
//  Created by Jacky Zang on 2017/8/16.
//  Copyright © 2017年 Elliot. All rights reserved.
//

#import "MessageBody.h"
#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

#import "Utilities.h"
#import "MJExtension.h"

@interface ChannelBody (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation ChannelBody (WCTColumnCoding)

+ (instancetype)unarchiveWithWCTValue:(NSString *)value {
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        return nil;
    }
    ChannelBody *channel = [[ChannelBody alloc] init];
    [channel setValuesForKeysWithDictionary:(NSDictionary *)[Utilities dicFromJSONStr:value]];

    return channel;
}

- (NSString *)archivedWCTValue {
    return [Utilities JSONStrFromDic:self.mj_keyValues];
}

+ (WCTColumnType)columnTypeForWCDB {
    return WCTColumnTypeString;
}

@end

@interface MessageBody (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation MessageBody (WCTColumnCoding)
//unarchiveWithWCTValue:接口定义从数据库类型反序列化到类的转换方式
+ (instancetype)unarchiveWithWCTValue:(NSString *)value {
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        return nil;
    }
    MessageBody *message = [[MessageBody alloc] init];
    [message setValuesForKeysWithDictionary:(NSDictionary *)[Utilities dicFromJSONStr:value]];

    return message;
}
//archivedWCTValue接口定义从类序列化到数据库类型的转换方式
- (NSString *)archivedWCTValue {

    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:self.mj_keyValues];
    [tmp addEntriesFromDictionary:@{@"isAutoIncrement":@0}];

    //[Utilities JSONStrFromDic:self.mj_keyValues];
    return [Utilities JSONStrFromDic:tmp];
}
//columnTypeForWCDB接口定义类对应数据库中的类型
+ (WCTColumnType)columnTypeForWCDB {
    return WCTColumnTypeString;
}

@end

@implementation IIPRIVATE_MessageBodyV1 (WCTColumnCoding)
//unarchiveWithWCTValue:接口定义从数据库类型反序列化到类的转换方式
+ (instancetype)unarchiveWithWCTValue:(NSString *)value {
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        return nil;
    }
    IIPRIVATE_MessageBodyV1 *messageV1 = [[IIPRIVATE_MessageBodyV1 alloc] init];
    [messageV1 setValuesForKeysWithDictionary:(NSDictionary *)[Utilities dicFromJSONStr:value]];

    return messageV1;
}
//archivedWCTValue接口定义从类序列化到数据库类型的转换方式
- (NSString *)archivedWCTValue {

    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:self.mj_keyValues];
    [tmp addEntriesFromDictionary:@{@"isAutoIncrement":@0}];

    //[Utilities JSONStrFromDic:self.mj_keyValues];
    return [Utilities JSONStrFromDic:tmp];
}
//columnTypeForWCDB接口定义类对应数据库中的类型
+ (WCTColumnType)columnTypeForWCDB {
    return WCTColumnTypeString;
}

@end

@interface BotBody (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation BotBody (WCTColumnCoding)

+ (instancetype)unarchiveWithWCTValue:(NSString *)value {
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        return nil;
    }
    BotBody *bot = [[BotBody alloc] init];
    [bot setValuesForKeysWithDictionary:(NSDictionary *)[Utilities dicFromJSONStr:value]];
    
    return bot;
}

- (NSString *)archivedWCTValue {
    return [Utilities JSONStrFromDic:self.mj_keyValues];
}

+ (WCTColumnType)columnTypeForWCDB {
    return WCTColumnTypeString;
}

@end
