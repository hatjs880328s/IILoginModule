//
//  BaseBody.h
//  impcloud
//
//  Created by Jacky Zang on 2016/12/14.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseBody : NSObject

- (void)setValue:(id)value forKey:(NSString *)key;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
