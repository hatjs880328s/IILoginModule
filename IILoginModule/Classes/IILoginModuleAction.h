//
//  IILoginModuleAction.h
//  impcloud_dev
//
//  Created by xin on 2020/1/10.
//  Copyright © 2020 Elliot. All rights reserved.
//  登录模块 Action block,单例类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMPUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IILoginModuleAction : NSObject

//获取IILoginModuleAction单例对象
+ (IILoginModuleAction *)sharedObject;

/// 上一次登录保存的手机号,用于默认显示
@property (nonatomic, copy) NSString *(^getLastPhoneNum)(void);

/// 登录成功
@property (nonatomic, copy) void(^loginSuccessBlock)(void);

/// 点击忘记密码
@property (nonatomic, copy) void(^clickForgetPasswordBlock)(void);

/// 点击短信登录
@property (nonatomic, copy) void(^clickSMSLoginBlock)(void);

/// 点击更多
@property (nonatomic, copy) void(^clickMoreBlock)(void);

/// HTTPCollection统计信息
@property (nonatomic, copy) void(^httpCollectBlock)(NSString *url, NSTimeInterval startTime, NSTimeInterval endTime);

/// 保存上一次登录的用户名
@property (nonatomic, copy) void(^saveLastLoginUserNameBlock)(NSString *userName);

/// 保存用户信息,设置上次登录用户的信息
@property (nonatomic, copy) void(^saveUserModelBlock)(IMPUserModel *model);

/// 当前VC,用于页面跳转
@property (nonatomic, weak) UIViewController *currentVC;

@end

NS_ASSUME_NONNULL_END
