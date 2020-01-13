//
//  LVKeyboard.h
//  字母键盘
//
//  Created by PBOC CS on 15/4/11.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LVKeyboard;
@protocol LVKeyboardDelegate <NSObject>

@optional
/**
 *  点击了文字或字符数字按钮
 */
- (void)keyboard:(LVKeyboard *)keyboard didClickTextButton:(UIButton *)textBtn string:(NSString *)string;
/**
 *  点击了删除按钮
 */
- (void)keyboard:(LVKeyboard *)keyboard didClickDeleteButton:(UIButton *)deleteBtn string:(NSString *)string;
/**
 *  点击了确定按钮
 */
- (void)keyboard:(LVKeyboard *)keyboard didClickSureButton:(UIButton *)sureBtn string:(NSString *)string;
/**
 *  点击了改变文本的按钮(删除\文字\字符\...其他非功能性按钮),用于刷新view
 */
- (void)keyboardDidChangeText:(LVKeyboard *)keyboard;
/**
 *  点击了切换键盘按钮
 */
- (void)keyboardDidClickChangeKeyboard:(LVKeyboard *)keyboard;

@end

@interface LVKeyboard : UIView
/**
 *  触发的输入框,可选
 *  UITextField | UITextView
 */
@property(nonatomic, weak) id<UITextInput> textInput;

///键盘事件代理
@property (nonatomic, weak) id<LVKeyboardDelegate> delegate;

@end
