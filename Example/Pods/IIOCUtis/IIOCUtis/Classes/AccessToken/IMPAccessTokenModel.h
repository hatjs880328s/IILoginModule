// ==============================================================================
//
// This file is part of the IMP Cloud.
//
// Create by Shiguang <shiguang@richingtech.com>
// Copyright (c) 2016-2017 inspur.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================


#import <Foundation/Foundation.h>

@interface IMPAccessTokenModel : NSObject

+ (IMPAccessTokenModel *)activeToken;
+ (void)IIPRIVATE_setActiveToken:(IMPAccessTokenModel *)token;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *tokenType;
@property (nonatomic)       BOOL     isExpired;
@property (nonatomic, copy) NSDate   *expireDate;

- (void)exeofsetUserToken:(NSDictionary *)dic;

- (BOOL)isValid;
- (void)reset;

@end
