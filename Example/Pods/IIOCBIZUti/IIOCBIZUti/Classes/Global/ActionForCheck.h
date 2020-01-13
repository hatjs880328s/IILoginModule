//
//  ActionForCheck.h
//  impcloud
//
//  Created by Jacky Zang on 2017/7/6.
//  Copyright © 2017年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CheckQuerySuccessHandler)(BOOL success);

@interface ActionForCheck : NSObject

+ (instancetype)sharedInstance;
- (void)queryClientId;
- (BOOL)getNeedRefreshApplication;
- (void)setNeedRefreshApplication:(BOOL)ifNeed;
- (void)needQuery3DTouch:(BOOL)ifNeed withSuccessHandler:(CheckQuerySuccessHandler)handler;
- (void)needQueryMainTab:(BOOL)ifNeed withSuccessHandler:(CheckQuerySuccessHandler)handler;
- (void)needQueryAdvert:(BOOL)ifNeed withSuccessHandler:(CheckQuerySuccessHandler)handler;
- (void)needQueryMultipleLayoutWithSuccessHandler:(CheckQuerySuccessHandler)handler;

@end
