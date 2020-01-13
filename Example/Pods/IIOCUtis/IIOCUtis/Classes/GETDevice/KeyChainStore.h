//
//  KeyChainStore.h
//  impcloud
//
//  Created by Elliot on 15/7/27.
//  Copyright (c) 2015年 Elliot. All rights reserved.
//

#import<Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)IIPRIVATE_load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
