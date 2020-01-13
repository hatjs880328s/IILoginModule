//
//  LVLetterKeyboard.h
//  字母键盘
//
//  Created by PBOC CS on 15/4/9.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKeyboardTool.h"

@interface LVLetterKeyboard : UIView

- (id)initWithFrame:(CGRect)frame needRandom:(BOOL)random;
@property (nonatomic, assign) id<LVCustomKeyboardDelegate> delegate;

@end
