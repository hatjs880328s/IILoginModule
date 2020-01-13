//
//  LoginViewController.h
//  impcloud
//
//  Created by Elliot on 15/6/1.
//  Copyright (c) 2015年 Elliot. All rights reserved.
//

//登录页面

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

/// input,直接登录获取用户信息
-(void)directQueryUserProfile;


//用户名TextField
@property (nonatomic, weak) IBOutlet UITextField *pTextField_Username;
//密码TextField
@property (nonatomic, weak) IBOutlet UITextField *pTextField_Password;

//登录按钮
@property (nonatomic, weak) IBOutlet UIButton *pButton_Login;
@property (nonatomic, weak) IBOutlet UIButton *pButton_ShowPassword;
-(IBAction)showPasswordButtonClicked:(UIButton *)sender;

//登录按钮点击函数
-(IBAction)loginButtonClicked:(id)sender;

-(IBAction)forgetPasswordButtonClicked:(id)sender;

//快速登录
@property (nonatomic, weak) IBOutlet UIButton *pButton_AuthCode;
-(IBAction)authCodeButtonClicked:(id)sender;

//忘记密码
@property (nonatomic, weak) IBOutlet UIButton *pButton_ForgetPassword;

//登录系统
@property (nonatomic, weak) IBOutlet UILabel *pLabel_LogSys;

//更多
@property (nonatomic, weak) IBOutlet UIButton *pButton_More;
-(IBAction)moreButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIView *accountLine;
@property (weak, nonatomic) IBOutlet UIView *passwordLine;

//登录Cover
//@property (nonatomic, strong) IBOutlet UIImageView *pImageView_Cover;

@end
