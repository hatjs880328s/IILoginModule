//
//  IILoginVCBLL.h
//  CloudLoginModule
//
//  Created by xin on 2020/1/3.
//  Copyright © 2020 xin. All rights reserved.
//  登录VC数据处理

#import <UIKit/UIKit.h>
#import "IMPUserModel.h"
#import "IILoginServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface IILoginVCBLL : NSObject

/// 登录获取token
- (void)IIPRIVATE_checkLoginForUser:(NSString *)user IIPRIVATE_withPassword:(NSString *)password finishBlock:(FinishWithErrorBlock)finishBlock;

/// 获取用户信息
- (void)queryUserProfileWithFinishBlock:(FinishWithErrorBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
