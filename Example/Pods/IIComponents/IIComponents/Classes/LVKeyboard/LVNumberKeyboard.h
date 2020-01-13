//
//  LVNumberKeyboard.h
//  字母键盘
//
//  Created by PBOC CS on 15/4/11.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKeyboardTool.h"
@interface LVNumberKeyboard : UIView

- (id)initWithFrame:(CGRect)frame needRandom:(BOOL)random;
@property (nonatomic, assign) id<LVCustomKeyboardDelegate> delegate;

@end
