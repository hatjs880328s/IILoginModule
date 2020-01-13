//
//  ContactLoadScreen.h
//  impcloud_dev
//
//  Created by Elliot on 2018/5/14.
//  Copyright © 2018年 Elliot. All rights reserved.
//

#import "ContactLoadScreen.h"
#import "BaseViewController.h"
#import "IMPUserModel.h"
#import "Constants.h"

@interface ContactLoadScreen() {
    BOOL tabBarFlag;
    BOOL contactFlag;
}

@end

@implementation ContactLoadScreen

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static ContactLoadScreen *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _contactLoadScreenWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        BaseViewController * vc = [[BaseViewController alloc] init];
        _contactLoadScreenWindow.rootViewController = vc;
        vc.view.frame = _contactLoadScreenWindow.bounds;
        _contactLoadScreenWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return self;
}

- (void) resetContactViewController {
    _contactProgress = [[ContactProgress alloc] init];
}

- (void)show{
    if(![self shouldShow]){
        return;
    }
    _contactLoadScreenWindow.windowLevel = UIWindowLevelStatusBar;
    _contactLoadScreenWindow.hidden = NO;
    if (_contactProgress == nil) {
        [self resetContactViewController];
    }
    if (!_contactProgress.presentingViewController) {
        
        [_contactLoadScreenWindow.rootViewController presentViewController:_contactProgress animated:NO completion:^{}];
    }
    contactFlag = FALSE;
    tabBarFlag = FALSE;
}

- (BOOL)shouldShow {
    //显示初始化界面的条件为:通讯录人员、组织等信息至少有一方未获取过
    if([[NSUserDefaults standardUserDefaults] objectForKey:WCDBUserQueryTime] == nil && [[NSUserDefaults standardUserDefaults] objectForKey:WCDBOrgQueryTime] == nil) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

- (void)hide {
    [_contactLoadScreenWindow.rootViewController dismissViewControllerAnimated:NO completion:^{
        if(self->_contactProgress) {
            self->_contactProgress = nil;
        }
        self->_contactLoadScreenWindow.windowLevel = UIWindowLevelNormal;
        self->_contactLoadScreenWindow.hidden = YES;
    }];
}

- (BOOL)isHidden {
    if(_contactLoadScreenWindow == nil){
        return YES;
    }
    return _contactLoadScreenWindow.hidden;
}

- (void)finishContact {
    contactFlag = TRUE;
    NSLog(@"完成通讯录请求");
    [self tryHide];
}

- (void)finishTabBar {
    tabBarFlag = TRUE;
    NSLog(@"完成tabbar请求");
    [self tryHide];
    
}

- (void)tryHide {
    if(contactFlag && tabBarFlag){
        [self hide];
    }
}

- (void)dealloc {
    if (_contactLoadScreenWindow) {
        _contactLoadScreenWindow = nil;
    }
    if(_contactProgress) {
        _contactProgress = nil;
    }
}

@end
