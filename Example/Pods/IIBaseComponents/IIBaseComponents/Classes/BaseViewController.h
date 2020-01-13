//
//  BaseViewController.h
//  impcloud
//
//  Created by Elliot on 15/7/15.
//  Copyright (c) 2015年 Elliot. All rights reserved.
//

//  基础封装主页面

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//添加左右button
@property (strong, nonatomic) UIButton *navLeftButton;
@property (strong, nonatomic) UIButton *navRightButton;

///导航栏标题
- (void)addNavTitle:(NSString *)navTitle;
///新导航栏标题-UI3.0-导航栏侧边标题
- (void)addNewNavSideTitle:(NSString *)title;

///导航栏标题View
- (void)changeNaviTitleView:(UIButton *)btn;
///新导航栏标题-UI3.0-导航栏侧边标题View
- (void)changeNewNaviSideTitleView:(UIButton *)btn;

///设置导航栏左侧按钮
- (void)addNavLeftButtonNormalImage:(UIImage *)normalImage navLeftButtonSelectedImage:(UIImage *)selectedImage;
///设置导航栏右侧按钮
- (void)addNavRightButtonNormalImage:(UIImage *)normalImage navRightButtonSelectedImage:(UIImage *)selectedImage;
///导航栏右侧按钮 自定义点击事件
- (void)addNavRightButtonWithImage:(UIImage *)normalImage action:(SEL)action;
///导航栏右侧有两个按钮 分别设置显示的按钮图片
- (void)addTwoNavRightButtonWithRightImage:(UIImage *)rightImage leftImage:(UIImage *)leftImage;
///导航栏右侧按钮名称
- (void)addNavRightButtonTitle:(NSString *)title;
///导航栏左侧按钮名称 自定义点击事件
- (void)addNavLeftButtonTitle:(NSString *)title action:(SEL)action;

///导航栏左侧按钮点击事件
- (void)rectBack;
///导航栏右侧按钮点击事件
- (void)rightNavButtonClick:(UIButton *)btn;
///导航栏右侧两个按钮 标题右侧靠右按钮的点击事件
- (void)rightNavButtonClickRight:(UIButton *)btn;
///导航栏右侧两个按钮 标题右侧靠左按钮的点击事件
- (void)rightNavButtonClickLeft:(UIButton *)btn;

///导航栏返回按钮点击事件
- (IBAction)backButtonClicked:(id)sender;

///初始化导航栏字体格式
- (void)initNavTitleAttributes;
///夜间模式导航栏字体格式
- (void)darkNightNavTitleAttributes;

@end
