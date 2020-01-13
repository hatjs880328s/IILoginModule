//
//  IILoginServiceProtocol.h
//  impcloud_dev
//
//  Created by xin on 2020/1/9.
//  Copyright © 2020 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

//IILoginVCBLL网络请求错误信息
typedef void(^FinishWithErrorBlock)(NSError * _Nullable error);

@protocol IILoginServiceProtocol <NSObject, BHServiceProtocol>

/// 当前VC,保存用于跳转和提示
@property (nonatomic, weak) UIViewController *currentVC;

/// 获取登录VC
- (UIViewController *)getLoginVC;

/// 直接登录获取用户信息
- (void)directQueryUserProfile;

/// 登录获取token
- (void)IIPRIVATE_checkLoginForUser:(NSString *)user IIPRIVATE_withPassword:(NSString *)password finishBlock:(FinishWithErrorBlock)finishBlock;

/// 获取用户信息
- (void)queryUserProfileWithFinishBlock:(FinishWithErrorBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
