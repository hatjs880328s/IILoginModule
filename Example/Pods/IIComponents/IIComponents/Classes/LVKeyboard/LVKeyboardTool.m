//
//  LVKeyboardTool.m
//  字母键盘
//
//  Created by PBOC CS on 15/4/11.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVKeyboardTool.h"

@implementation LVKeyboardTool

#pragma mark - 添加基础按钮
+ (UIButton *)setupBasicButtonsWithTitle:(NSString *)title image:(UIImage *)image highImage:(UIImage *)highImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:22];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highImage forState:UIControlStateHighlighted];
    return button;
}

//字母表
+ (UIButton *)setupNumButtonsWithTitle:(NSString *)title image:(UIImage *)image highImage:(UIImage *)highImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:22];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highImage forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    return button;
}

#pragma mark - 添加功能按钮
+ (UIButton *)setupSureButtonWithTitle:(NSString *)title image:(UIImage *)image highImage:(UIImage *)highImage {
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn setTitle:title forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sureBtn setBackgroundImage:image forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    return sureBtn;
}

+ (UIButton *)setupFunctionButtonWithTitle:(NSString *)title image:(UIImage *)image highImage:(UIImage *)highImage {
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [otherBtn setTitle:title forState:UIControlStateNormal];
    [otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [otherBtn setBackgroundImage:image forState:UIControlStateNormal];
    [otherBtn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    otherBtn.layer.cornerRadius = 5;
    otherBtn.layer.masksToBounds = YES;
    return otherBtn;
}

+ (UIButton *)setupFunctionButtonWithImage:(UIImage *)image highImage:(UIImage *)highImage {
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBtn setImage:image forState:UIControlStateNormal];
    [imgBtn setImage:highImage forState:UIControlStateHighlighted];
    return imgBtn;
}

@end
