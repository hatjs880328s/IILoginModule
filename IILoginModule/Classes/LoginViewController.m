//
//  LoginViewController.m
//  impcloud
//
//  Created by Elliot on 15/6/1.
//  Copyright (c) 2015年 Elliot. All rights reserved.
//

//登录页面

#import "LoginViewController.h"
#import "AFOAuth2Manager.h"
#import "IMPAccessTokenModel.h"
#import "IMPUserModel.h"
//虚拟键盘
#import "LVKeyboard.h"
#import "SetUserPVAndEXPClass.h"
#import <IIOCBIZUti/IMPHttpSvc.h>
#import <IIOCBIZUti/AFHTTPRequestOperation+IMPKit.h>
#import <IIOCBIZUti/ContactProgress.h>
#import "IMPI18N.h"
#import "Constants.h"
#import "Utilities.h"
#import "ProgressHUD.h"
#import "ShowAlertClass.h"
#import "TakeRouterSocketAdressClass.h"
#import "MJExtension.h"
#import "SetUserPVAndEXPClass.h"
#import "GetDeviceUUIDClass.h"
#import "NSString+SBJSON.h"
#import "UIView+Toast.h"
#import "IILoginVCBLL.h"
#import "IILoginModuleAction.h"

@import IIUIAndBizConfig;

@interface LoginViewController () <UIGestureRecognizerDelegate, LVKeyboardDelegate, UITextFieldDelegate> {
    
    __weak IBOutlet NSLayoutConstraint *topConstraint;
    __weak IBOutlet NSLayoutConstraint *moreButtonBottomConstraint;

    __weak IBOutlet NSLayoutConstraint *sysTopConstraint;
    
    __weak IBOutlet UILabel *welcomeLabel;

    __weak IBOutlet UIView *registerView;
    __weak IBOutlet UILabel *registerLabel;

    __weak IBOutlet UIButton *pButton_register;


    __weak IBOutlet UIImageView *accountLine;
    __weak IBOutlet UIImageView *passwordLine;
    
    UISwipeGestureRecognizer *pRecognizer_Quit;
    UITapGestureRecognizer *pRecognizer_Quit_Tap;
}
@property (nonatomic, strong) LVKeyboard *safeKeyboard;
@property (nonatomic, strong) IILoginVCBLL *loginBLL;
@end

@implementation LoginViewController
@synthesize pTextField_Username;
@synthesize pTextField_Password;
@synthesize pButton_Login;
@synthesize pButton_ShowPassword;

@synthesize pButton_ForgetPassword;
@synthesize pButton_AuthCode;
@synthesize pLabel_LogSys;
@synthesize pButton_More;
@synthesize accountLabel;
@synthesize passwordLabel;
@synthesize accountLine;
@synthesize passwordLine;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //国际化
    pTextField_Username.placeholder = IMPLocalizedString(@"Login_page_Accout");
    pTextField_Password.placeholder = IMPLocalizedString(@"Login_page_password");
    accountLabel.text = IMPLocalizedString(@"Login_page_Accout");
    accountLabel.textColor = APPUIConfig.blueThemeColor;
    passwordLabel.text = IMPLocalizedString(@"Login_page_password");
    passwordLabel.textColor = APPUIConfig.blueThemeColor;
    pTextField_Username.tag = 0;
    pTextField_Password.tag = 1;
    
    [pButton_Login setTitle:IMPLocalizedString(@"Login_page_login") forState:UIControlStateNormal];
    [pButton_Login setTitle:IMPLocalizedString(@"Login_page_login") forState:UIControlStateHighlighted];
    [pButton_Login setTitle:IMPLocalizedString(@"Login_page_login") forState:UIControlStateSelected];
    [pButton_Login setTitle:IMPLocalizedString(@"Login_page_login") forState:UIControlStateDisabled];

    [registerLabel setText:IMPLocalizedString(@"Login_page_register_label")];
    [pButton_register setTitle:IMPLocalizedString(@"Login_page_register") forState:UIControlStateNormal];
    [pButton_register setTitle:IMPLocalizedString(@"Login_page_register") forState:UIControlStateHighlighted];
    [pButton_register setTitle:IMPLocalizedString(@"Login_page_register") forState:UIControlStateSelected];
    
    [pButton_AuthCode setTitle:IMPLocalizedString(@"Login_page_quicklogin") forState:UIControlStateNormal];
    [pButton_AuthCode setTitle:IMPLocalizedString(@"Login_page_quicklogin") forState:UIControlStateHighlighted];
    [pButton_AuthCode setTitle:IMPLocalizedString(@"Login_page_quicklogin") forState:UIControlStateSelected];
    
    [pButton_ForgetPassword setTitle:IMPLocalizedString(@"Login_page_forgetPassword") forState:UIControlStateNormal];
    [pButton_ForgetPassword setTitle:IMPLocalizedString(@"Login_page_forgetPassword") forState:UIControlStateHighlighted];
    [pButton_ForgetPassword setTitle:IMPLocalizedString(@"Login_page_forgetPassword") forState:UIControlStateSelected];
    
    [pButton_More setTitle:IMPLocalizedString(@"Phonebook_page_more") forState:UIControlStateNormal];
    [pButton_More setTitle:IMPLocalizedString(@"Phonebook_page_more") forState:UIControlStateHighlighted];
    [pButton_More setTitle:IMPLocalizedString(@"Phonebook_page_more") forState:UIControlStateSelected];
    
    [pButton_ShowPassword setImage:[UIImage imageNamed:@"eye_close_"] forState:UIControlStateNormal];
    [pButton_ShowPassword setImage:[UIImage imageNamed:@"eye_open_"] forState:UIControlStateSelected];

    pTextField_Password.delegate = self;

    //初始化安全键盘
    [self initCustomKeyboard];

    NSString *appName = IMPLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist");
    [welcomeLabel setText:[NSString stringWithFormat:IMPLocalizedString(@"Login_page_Welcome"), appName]];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //修改背景色
    self.view.backgroundColor = APPUIConfig.whiteColor;//[UIColor colorWithRed:246/255.0 green:250/255.0 blue:252/255.0 alpha:1];

    //判断登录按钮是否可用
    if (pTextField_Username.text.length > 0) {
        pButton_Login.enabled = YES;
    }
    else {
        pButton_Login.enabled = NO;
    }

    //根据屏幕高度计算距离顶部的高度
    topConstraint.constant = SafeAreaTopHeight_NoNav + 56;
    if(SafeAreaTopHeight_NoNav == 44) {
        //iPhone X
        moreButtonBottomConstraint.constant = SafeAreaBottomHeight;
    }
    
    //上次登录成功的用户名需要添加上
    if ([IILoginModuleAction sharedObject].getLastPhoneNum) {
        NSString *lastPhoneNum = [IILoginModuleAction sharedObject].getLastPhoneNum();
        if (lastPhoneNum && lastPhoneNum.length > 0) {
            pTextField_Username.text = lastPhoneNum;
        }
    }
    
    //监听进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMyPasswordInput) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //BOOL-注销页面判断
    [[ProgressHUD shareInstance] remove];

    self.navigationController.navigationBar.hidden = YES;

    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation: UIStatusBarAnimationFade];

    // 添加滑动手势
    pRecognizer_Quit = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pRecognizer_Quit.direction = UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
    pRecognizer_Quit.delegate = self;
    [self.view addGestureRecognizer:pRecognizer_Quit];

    //添加点击手势
    //单击的 Recognizer
    pRecognizer_Quit_Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    //点击的次数
    pRecognizer_Quit_Tap.numberOfTapsRequired = 1; // 单击
    pRecognizer_Quit_Tap.delegate = self;
    //给self.view添加一个手势监测；
    [self.view addGestureRecognizer:pRecognizer_Quit_Tap];

    //判断登录按钮是否可用
    if (pTextField_Username.text.length > 0) {
        pButton_Login.enabled = YES;
    }
    else {
        pButton_Login.enabled = NO;
    }
    pLabel_LogSys.frame = CGRectMake(0, SafeAreaTopHeight_QR_Top+20, kScreenWidth, 20);
    pLabel_LogSys.text = @"";
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kAppMainIP];
    if (str.length != 0) {
        NSString *str_Name = [[NSUserDefaults standardUserDefaults] objectForKey:kAppMainIPName];
        pLabel_LogSys.text = [NSString stringWithFormat:@"%@:%@",IMPLocalizedString(@"Login_More_CurrentSys"),str_Name];
        pLabel_LogSys.textColor = APPUIConfig.charGrayColor;
    }
    [self clearMyPasswordInput];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.view.hidden = NO;
    // 底下是刪除手势的方法
    [self.view removeGestureRecognizer:pRecognizer_Quit];
    [self.view removeGestureRecognizer:pRecognizer_Quit_Tap];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //退出时显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer {
    // 触发手勢事件后，在这里作些事情
    [self.view endEditing:YES];
    [Utilities changeViewFrameWhenKeyboardHide:self.view];
}

//登录按钮点击函数
-(IBAction)loginButtonClicked:(id)sender
{
    [self handleSwipeFrom:nil];
    if (![sender isEqual:@"login_recover"])
    {
        [[ProgressHUD shareInstance] showProgressWithMessage:IMPLocalizedString(@"login_loading")];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.loginBLL IIPRIVATE_checkLoginForUser:pTextField_Username.text IIPRIVATE_withPassword:pTextField_Password.text finishBlock:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didFinishActionWithError:error];
    }];
}

-(IILoginVCBLL *)loginBLL{
    if (!_loginBLL) {
        _loginBLL = [[IILoginVCBLL alloc] init];
    }
    return _loginBLL;
}

/// 直接登录获取用户信息
-(void)directQueryUserProfile{
    __weak typeof(self) weakSelf = self;
    [self.loginBLL queryUserProfileWithFinishBlock:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didFinishActionWithError:error];
    }];
}

#pragma mark - ActionForLogin delegate
- (void)didFinishActionWithError:(NSError *)error {
    [[ProgressHUD shareInstance] remove];
    if (error != nil) {
        NSString *pStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (pStr.length>0 && [pStr rangeOfString:@"(400)"].location != NSNotFound) {
            if ([self getXRateLimitRemainingOrXRateLimitRetryAfterSecondsByError:error Key:@"X-Rate-Limit-Remaining"] == nil) {
                //未配置
                [self presentViewController:[ShowAlertClass showAlert:IMPLocalizedString(@"login_fail") withClickSureBtnHandler:^{
                }] animated:YES completion:nil];
            }
            else if ([[self getXRateLimitRemainingOrXRateLimitRetryAfterSecondsByError:error Key:@"X-Rate-Limit-Remaining"] intValue] == 0) {
                //次数剩余为0
                int minutes = ([[self getXRateLimitRemainingOrXRateLimitRetryAfterSecondsByError:error Key:@"X-Rate-Limit-Retry-After-Seconds"] intValue] / 60);
                if (minutes == 0 && [[self getXRateLimitRemainingOrXRateLimitRetryAfterSecondsByError:error Key:@"X-Rate-Limit-Retry-After-Seconds"] intValue] >= 0) {
                    //一分钟内 提示用秒
                    if ([[self getXRateLimitRemainingOrXRateLimitRetryAfterSecondsByError:error Key:@"X-Rate-Limit-Retry-After-Seconds"] intValue] == 0) {
                        [self presentViewController:[ShowAlertClass showAlert:[NSString stringWithFormat:@"%@%@%d%@",IMPLocalizedString(@"login_fail_lock"),IMPLocalizedString(@"login_fail_please"),1,IMPLocalizedString(@"login_fail_try_seconds")] withClickSureBtnHandler:^{
                        }] animated:YES completion:nil];
                    }
                    else {
                        [self presentViewController:[ShowAlertClass showAlert:[NSString stringWithFormat:@"%@%@%d%@",IMPLocalizedString(@"login_fail_lock"),IMPLocalizedString(@"login_fail_please"),[[self getXRateLimitRemainingOrXRateLimitRetryAfterSecondsByError:error Key:@"X-Rate-Limit-Retry-After-Seconds"] intValue],IMPLocalizedString(@"login_fail_try_seconds")] withClickSureBtnHandler:^{
                        }] animated:YES completion:nil];
                    }
                }
                else {
                    //大于一分钟 提示用分钟
                    [self presentViewController:[ShowAlertClass showAlert:[NSString stringWithFormat:@"%@%@%d%@",IMPLocalizedString(@"login_fail_lock"),IMPLocalizedString(@"login_fail_please"),minutes,IMPLocalizedString(@"login_fail_try_minutes")] withClickSureBtnHandler:^{
                    }] animated:YES completion:nil];
                }
            }
            else {
                //次数剩余不为0
                [self presentViewController:[ShowAlertClass showAlert:[NSString stringWithFormat:@"%@%@%@%@%@",IMPLocalizedString(@"login_fail"),IMPLocalizedString(@"login_fail_point"),IMPLocalizedString(@"login_fail_left"),[self getXRateLimitRemainingOrXRateLimitRetryAfterSecondsByError:error Key:@"X-Rate-Limit-Remaining"],IMPLocalizedString(@"login_fail_chance")] withClickSureBtnHandler:^{
                }] animated:YES completion:nil];
            }
        }
        else if (error.code == -1001 || error.code == -1003) {
            [self presentViewController:[ShowAlertClass showAlert:IMPLocalizedString(@"common_request_timeout") withClickSureBtnHandler:^{
            }] animated:YES completion:nil];
        }
        else if (error.code == -1009) {
            [self presentViewController:[ShowAlertClass showAlert:IMPLocalizedString(@"common_request_unConnect") withClickSureBtnHandler:^{
            }] animated:YES completion:nil];
        }
        else if (error.code == -10086) {
            //20180730,Elliot,增加当用户默认企业及多企业均为空时，不准进入并合理提示
            [self presentViewController:[ShowAlertClass showAlert:IMPLocalizedString(@"Common_Login_NoEnterprise") withClickSureBtnHandler:^{
            }] animated:YES completion:nil];
        }
        else {
            [self presentViewController:[ShowAlertClass showAlert:IMPLocalizedString(@"common_request_error") withClickSureBtnHandler:^{
            }] animated:YES completion:nil];
        }
        //Elliot Added,防止网络异常时，白板
        self.view.hidden = NO;
    }
    else {//登录成功
        if ([IILoginModuleAction sharedObject].loginSuccessBlock) {
            [IILoginModuleAction sharedObject].loginSuccessBlock();
        }
    }
}

//忘记密码
-(IBAction)forgetPasswordButtonClicked:(id)sender{
    if ([IILoginModuleAction sharedObject].clickForgetPasswordBlock) {
        [IILoginModuleAction sharedObject].clickForgetPasswordBlock();
    }
}
//快速登录
-(IBAction)authCodeButtonClicked:(id)sender{
    if ([IILoginModuleAction sharedObject].clickSMSLoginBlock) {
        [IILoginModuleAction sharedObject].clickSMSLoginBlock();
    }
}

-(IBAction)showPasswordButtonClicked:(UIButton *)sender{
    if (sender.selected)
    {
        sender.selected =NO;
        pTextField_Password.secureTextEntry = YES;
        NSString *pStr = pTextField_Password.text;
        pTextField_Password.text = @"";
        pTextField_Password.text = pStr;
    }
    else
    {
        sender.selected =YES;
        pTextField_Password.secureTextEntry = NO;
        NSString *pStr = pTextField_Password.text;
        pTextField_Password.text = @"";
        pTextField_Password.text = pStr;
    }
}

//点击更多按钮
-(IBAction)moreButtonClicked:(id)sender {
    if ([IILoginModuleAction sharedObject].clickMoreBlock) {
        [IILoginModuleAction sharedObject].clickMoreBlock();
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [Utilities changeViewFrameWhenKeyboardShow:self.view];

    if(textField.tag == 0){
        //用户名输入线颜色改变
        accountLabel.hidden = NO;
        accountLine.backgroundColor = APPUIConfig.blueThemeColor;
    }else if(textField.tag == 1){
        //密码输入线颜色改变
        passwordLabel.hidden = NO;
        passwordLine.backgroundColor = APPUIConfig.blueThemeColor;
    }
    
    //设置安全键盘
    [self initCustomKeyboard];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if(textField.tag == 0){
        //用户名输入线颜色改变
        accountLabel.hidden = YES;
        accountLine.backgroundColor = APPUIConfig.inputLineColor;
    }else if(textField.tag == 1){
        //密码输入线颜色改变
        passwordLabel.hidden = YES;
        passwordLine.backgroundColor = APPUIConfig.inputLineColor;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //判断登录按钮是否可用
    NSString * pString_Range = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == pTextField_Username)
    {
        if (pString_Range.length > 0)
        {
            pButton_Login.enabled = YES;
        }
        else
        {
            pButton_Login.enabled = NO;
        }
    }
    else
    {
        if (pTextField_Username.text.length > 0)
        {
            pButton_Login.enabled = YES;
        }
        else
        {
            pButton_Login.enabled = NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //清空则登录按钮不可用
    pButton_Login.enabled = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == pTextField_Username)
    {
        [pTextField_Password becomeFirstResponder];
    }
    else if (textField == pTextField_Password)
    {
        //执行登录过程
        [self loginButtonClicked:self];
    }
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.pTextField_Password resignFirstResponder];
}

#pragma mark - 初始化安全键盘
- (void)initCustomKeyboard {
    pTextField_Password.inputView = self.safeKeyboard;
    [pTextField_Password reloadInputViews];
}

-(LVKeyboard *)safeKeyboard{
    if (!_safeKeyboard) {
        _safeKeyboard = [LVKeyboard new];
        _safeKeyboard.delegate = self;
        _safeKeyboard.textInput = pTextField_Password;
    }
    return _safeKeyboard;
}

#pragma mark - LVKeyboardDelegate安全键盘

/**
 *  点击了改变文本的按钮
 */
- (void)keyboardDidChangeText:(LVKeyboard *)keyboard{
    [self judgeLoginButtonState];
}

/**
 *  点击了确定按钮
 */
- (void)keyboard:(LVKeyboard *)keyboard didClickSureButton:(UIButton *)sureBtn string:(NSString *)string {
    if (pTextField_Username.text.length > 0) {
        //执行登录过程
        [self loginButtonClicked:self];
    }
    else {
        [self.view makeToast:@"请输入用户名"];
    }
}
/**
 *  点击了切换键盘按钮
 */
- (void)keyboardDidClickChangeKeyboard:(LVKeyboard *)keyboard {
    //切换成系统原生键盘
    pTextField_Password.inputView = nil;
    [pTextField_Password reloadInputViews];
    [pTextField_Password becomeFirstResponder];
}

//刷新登录按钮状态
- (void)judgeLoginButtonState{
    if (pTextField_Username.text.length > 0) {
        pButton_Login.enabled = YES;
    }
    else {
        pButton_Login.enabled = NO;
    }
}

//清除密码
- (void)clearMyPasswordInput {
    pTextField_Password.text = @"";
    pButton_Login.enabled = NO;
}

//读取X-Rate-Limit-Remaining 剩余次数 读取X-Rate-Limit-Retry-After-Seconds 时间 按秒计
- (NSString *)getXRateLimitRemainingOrXRateLimitRetryAfterSecondsByError:(NSError *)error Key:(NSString *)key {
    if (error.userInfo!=nil && [[error.userInfo allKeys] containsObject:@"com.alamofire.serialization.response.error.response"]) {
        if ([[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"] isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
            NSDictionary *dic = response.allHeaderFields;
            NSString *str = [dic objectForKey:key];
            return str;
        }
        return nil;
    }
    return nil;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
