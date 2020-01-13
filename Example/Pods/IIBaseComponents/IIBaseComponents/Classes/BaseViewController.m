//
//  BaseViewController.m
//  impcloud
//
//  Created by Elliot on 15/7/15.
//  Copyright (c) 2015年 Elliot. All rights reserved.
//

#import "BaseViewController.h"
@import IIUIAndBizConfig;

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize navLeftButton;
@synthesize navRightButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initNavTitleAttributes];

    self.navigationController.navigationBar.translucent = YES;
    UIScreenEdgePanGestureRecognizer *gesTur = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handLeftSwipe:)];
    gesTur.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gesTur];

    [UIApplication sharedApplication].statusBarStyle = APPUIConfig.useDefaultStatusBarStyle ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (void)initNavTitleAttributes {
    //修改导航栏背景色、字体大小
    self.navigationController.navigationBar.barTintColor = APPUIConfig.cloudThemeColorVersion3;
    self.navigationController.navigationBar.tintColor = APPUIConfig.navCharColor;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:APPUIConfig.navCharColor, NSForegroundColorAttributeName, [APPUIConfig uiFontWith:18], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)darkNightNavTitleAttributes {
    self.navigationController.navigationBar.barTintColor = RGBA(50, 60, 73, 1);
    self.navigationController.navigationBar.tintColor = RGBA(255, 252, 250, 1);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:RGBA(255, 252, 250, 1), NSForegroundColorAttributeName, [APPUIConfig uiFontWith:18], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)handLeftSwipe:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self rectBack];
    }
}

- (void)rectBack {
    [self.navigationController popViewControllerAnimated:YES];
}

//导航栏标题
-(void)addNavTitle:(NSString *)navTitle {
    [self.navigationItem setTitle:navTitle];
}

//新导航栏标题-UI3.0-导航栏侧边标题
-(void)addNewNavSideTitle:(NSString *)title {
    [self.navigationItem setTitle:@""];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:APPUIConfig.navCharColor,NSForegroundColorAttributeName, [UIFont systemFontOfSize:20], NSFontAttributeName, nil];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:nil]];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateDisabled];
}

///导航栏标题View
-(void)changeNaviTitleView:(UIButton *)btn {
    self.navigationItem.titleView = btn;
    self.navigationItem.titleView.tintColor = APPUIConfig.navCharColor;
}

///新导航栏标题-UI3.0-导航栏侧边标题View
-(void)changeNewNaviSideTitleView:(UIButton *)btn {
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
}

//导航栏左侧按钮
-(void)addNavLeftButtonNormalImage:(UIImage *)normalImage navLeftButtonSelectedImage:(UIImage *)selectedImage {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
}

//back按钮返回
-(void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//导航栏右侧按钮
-(void)addNavRightButtonNormalImage:(UIImage *)normalImage navRightButtonSelectedImage:(UIImage *)selectedImage
{
    /*
    //添加导航栏右侧按钮
    navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //按钮的显示区域
    if (normalImage == nil) {
        [navRightButton setFrame: CGRectMake(0, 0, 50, 40)];
    }
    else{
        [navRightButton setFrame: CGRectMake(0, 0, 35, 40)];
    }
    //按钮的前景显示图
    [navRightButton setImage:normalImage forState:UIControlStateNormal];
    [navRightButton setImage:selectedImage forState:UIControlStateHighlighted];
    [navRightButton setImage:selectedImage forState:UIControlStateSelected];
    navRightButton.titleLabel.font =[UIFont systemFontOfSize:17];
    [navRightButton addTarget:self action:@selector(rightNavButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //加载导航栏中
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightButton];
     */
    if(normalImage == nil){
        self.navigationItem.rightBarButtonItem = nil;
        return ;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStylePlain target:self action:@selector(rightNavButtonClick:)];
}

- (void)addNavRightButtonWithImage:(UIImage *)normalImage action:(SEL)action {
    if(normalImage == nil){
        self.navigationItem.rightBarButtonItem = nil;
        return ;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStylePlain target:self action:action];
}

//导航栏右侧有两个按钮的
- (void)addTwoNavRightButtonWithRightImage:(UIImage *)rightImage leftImage:(UIImage *)leftImage {

    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightNavButtonClickRight:)], [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(rightNavButtonClickLeft:)]];
}

-(void)addNavRightButtonTitle:(NSString *)title
{
    //添加导航栏右侧按钮
    navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //按钮的显示区域
    [navRightButton setFrame: CGRectMake(0, 0, 50, 40)];
    //按钮的前景显示图
    [navRightButton setTitle:title forState:UIControlStateNormal];
    navRightButton.selected = NO;
    [navRightButton setTitleColor:APPUIConfig.navRightTextColor forState:UIControlStateNormal];
    navRightButton.titleLabel.font = [UIFont systemFontOfSize:17];

    [navRightButton addTarget:self action:@selector(rightNavButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightButton];
}

- (void)addNavLeftButtonTitle:(NSString *)title action:(SEL)action{
    navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navLeftButton setFrame:CGRectMake(0, 0, 60, 30)];
    [navLeftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [navLeftButton setTitle:title forState:UIControlStateNormal];
    [navLeftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];//左对齐
    navLeftButton.selected = NO;
    [navLeftButton setTitleColor:APPUIConfig.navRightTextColor forState:UIControlStateNormal];
    navLeftButton.titleLabel.font = [UIFont systemFontOfSize:17];//字号
    [navLeftButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.navLeftButton];
}

- (void)rightNavButtonClick:(UIButton *)btn {

}

///导航栏右侧两个按钮 右侧按钮点击事件
- (void)rightNavButtonClickRight:(UIButton *)btn {

}

///导航栏右侧两个按钮 左侧按钮点击事件
- (void)rightNavButtonClickLeft:(UIButton *)btn {

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
