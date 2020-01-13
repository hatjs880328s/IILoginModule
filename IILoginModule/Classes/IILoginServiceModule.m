//
//  IILoginServiceModule.m
//  impcloud_dev
//
//  Created by xin on 2020/1/9.
//  Copyright © 2020 Elliot. All rights reserved.
//

#import "IILoginServiceModule.h"
#import "LoginViewController.h"
#import "IILoginVCBLL.h"
#import "IILoginModuleAction.h"

@interface IILoginServiceModule()

@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) IILoginVCBLL *loginVCBLL;

@end

@implementation IILoginServiceModule

/// 获取登录VC
- (UIViewController *)getLoginVC{
    return self.loginVC;
}

/// input,直接登录获取用户信息
- (void)directQueryUserProfile{
    [self.loginVC directQueryUserProfile];
}

/// 登录获取token
- (void)IIPRIVATE_checkLoginForUser:(NSString *)user IIPRIVATE_withPassword:(NSString *)password finishBlock:(FinishWithErrorBlock)finishBlock{
    [self.loginVCBLL IIPRIVATE_checkLoginForUser:user IIPRIVATE_withPassword:password finishBlock:finishBlock];
}

/// 获取用户信息
- (void)queryUserProfileWithFinishBlock:(FinishWithErrorBlock)finishBlock{
    [self.loginVCBLL queryUserProfileWithFinishBlock:finishBlock];
}

#pragma mark - set
- (void)setCurrentVC:(UIViewController *)currentVC{
    _currentVC = currentVC;
    [IILoginModuleAction sharedObject].currentVC = currentVC;
}

#pragma mark - lazy load
-(IILoginVCBLL *)loginVCBLL{
    if (!_loginVCBLL) {
        _loginVCBLL = [IILoginVCBLL new];
    }
    return _loginVCBLL;
}

- (LoginViewController *)loginVC{
    if (!_loginVC) {
        _loginVC = [[LoginViewController alloc] initWithNibName:NSStringFromClass(LoginViewController.class) bundle:nil];
    }
    return _loginVC;
}


@end
