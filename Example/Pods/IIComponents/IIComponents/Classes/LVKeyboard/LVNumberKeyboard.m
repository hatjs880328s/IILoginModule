//
//  LVNumberKeyboard.m
//  字母键盘
//
//  Created by PBOC CS on 15/4/11.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVNumberKeyboard.h"
#import "UIView+LVExtension.h"
#import "NSArray+Random.h"
@import II18N;

@interface LVNumberKeyboard () {
    BOOL isNeedRandom;
}

/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteBtn;

/** 符号按钮 */
@property (nonatomic, strong) UIButton *switchSymbolBtn;

/** ABC 文字按钮 */
@property (nonatomic, strong) UIButton *switchLetterBtn;

@property (nonatomic, strong) NSTimer *deleteActionTimer;

@end

@implementation LVNumberKeyboard

- (id)initWithFrame:(CGRect)frame needRandom:(BOOL)random {
    isNeedRandom = random;
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"c_character_keyboardSwitchButtonSel"];
        UIImage *highImage = [UIImage imageNamed:@"c_character_keyboardSwitchButton"];
        [self setupNumberButtonsWithImage:image highImage:highImage];
        [self setupBottomButtonsWithImage:highImage highImage:image];
    }
    return self;
}

#pragma mark - 数字按钮
- (void)setupNumberButtonsWithImage:(UIImage *)image highImage:(UIImage *)highImage {
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM removeAllObjects];
    for (int i = 0 ; i < 10; i++) {
        NSNumber *number = [[NSNumber alloc] initWithInt:i];
        if ([arrM containsObject:number]) {
            i--;
            continue;
        }
        [arrM addObject:number];
    }
    NSArray *targetArr = [[NSArray alloc] init];
    if (isNeedRandom) {
        targetArr = [[arrM copy] randomizedArray];
    }
    else {
        targetArr = [arrM copy];
    }
    for (int i = 0; i < targetArr.count; i++) {
        NSNumber *number = targetArr[i];
        NSString *title = number.stringValue;
        UIButton *numBtn = [LVKeyboardTool setupNumButtonsWithTitle:title image:image highImage:highImage];
        [numBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:numBtn];
    }
}

- (void)numBtnClick:(UIButton *)numBtn {
    if ([self.delegate respondsToSelector:@selector(numberKeyboard:didClickButton:)]) {
        [self.delegate numberKeyboard:self didClickButton:numBtn];
    }
}

#pragma mark - 删除按钮可以点击 符号、ABC按钮不能点击
- (void)setupBottomButtonsWithImage:(UIImage *)image highImage:(UIImage *)highImage {
    // 此处Button显示名称变更，字母和符号键盘点击按钮互换
    self.switchSymbolBtn = [LVKeyboardTool setupFunctionButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_englishWords") image:image highImage:highImage];
    self.switchLetterBtn = [LVKeyboardTool setupFunctionButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_symbol")  image:image highImage:highImage];
    self.deleteBtn = [LVKeyboardTool setupFunctionButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_delete") image:[UIImage imageNamed:@"c_character_keyboardSwitchButton"] highImage:[UIImage imageNamed:@"c_character_keyboardSwitchButtonSel"]];
    
    // 切换至字符键盘切换至ABC键盘
    [self.switchSymbolBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchLetterBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backDeleteButtonClick:)]];
    
    [self addSubview:self.switchSymbolBtn];
    [self addSubview:self.switchLetterBtn];
    [self addSubview:self.deleteBtn];
    
}

#pragma mark - 切换键盘
- (void)functionBtnClick:(UIButton *)switchBtn {
    if ([self.delegate respondsToSelector:@selector(numberKeyboard:didClickButton:)]) {
        [self.delegate numberKeyboard:self didClickButton:switchBtn];
    }
}

#pragma mark - 点击删除按钮
- (void)backDeleteButtonClick:(UILongPressGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self.deleteActionTimer invalidate];
            self.deleteActionTimer = nil;
            break;
        case UIGestureRecognizerStateBegan:
            self.deleteActionTimer = [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(deleteBtnClick:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.deleteActionTimer forMode:NSRunLoopCommonModes];

            break;
        case UIGestureRecognizerStateChanged:


        default:
            break;
    }
}
- (void)deleteBtnClick:(UIButton *)deleteBtn {
    if ([self.delegate respondsToSelector:@selector(customKeyboardDidClickDeleteButton:)]) {
        [self.delegate customKeyboardDidClickDeleteButton:deleteBtn];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

    CGFloat topMargin = 10;
    CGFloat bottomMargin = 8;
    CGFloat leftMargin = 3;
    CGFloat colMargin = 5;
    CGFloat rowMargin = 10;
    
    CGFloat topBtnW = (self.lvkb_width - 2 * leftMargin - 2 * colMargin) / 3;
    CGFloat topBtnH = (self.lvkb_height - topMargin - bottomMargin - 3 * rowMargin) / 4;
    
    NSUInteger count = self.subviews.count;
    
    // 布局数字按钮
    for (NSUInteger i = 0; i < count; i++) {
        if (i == 0 ) { // 0
            UIButton *buttonZero = self.subviews[i];
            buttonZero.lvkb_height = topBtnH;
            buttonZero.lvkb_width = topBtnW;
            buttonZero.lvkb_centerX = self.lvkb_centerX;
            buttonZero.lvkb_centerY = 185;
            
            // 符号、文字及删除按钮的位置
            self.deleteBtn.lvkb_x = CGRectGetMaxX(buttonZero.frame) + colMargin;
            self.deleteBtn.lvkb_y = buttonZero.lvkb_y;
            self.deleteBtn.lvkb_width = buttonZero.lvkb_width;
            self.deleteBtn.lvkb_height = topBtnH;
            
            self.switchSymbolBtn.lvkb_x = leftMargin;
            self.switchSymbolBtn.lvkb_y = buttonZero.lvkb_y;
            self.switchSymbolBtn.lvkb_width = buttonZero.lvkb_width / 2 - colMargin / 2;
            self.switchSymbolBtn.lvkb_height = topBtnH;
            
            self.switchLetterBtn.lvkb_x = CGRectGetMaxX(self.switchSymbolBtn.frame) + colMargin;
            self.switchLetterBtn.lvkb_y = buttonZero.lvkb_y;
            self.switchLetterBtn.lvkb_width = self.switchSymbolBtn.lvkb_width;
            self.switchLetterBtn.lvkb_height = topBtnH;
            
        }
        if (i > 0 && i < 10) { // 0 ~ 9
            
            UIButton *topButton = self.subviews[i];
            CGFloat row = (i - 1) / 3;
            CGFloat col = (i - 1) % 3;
            
            topButton.lvkb_x = leftMargin + col * (topBtnW + colMargin);
            topButton.lvkb_y = topMargin + row * (topBtnH + rowMargin);
            topButton.lvkb_width = topBtnW;
            topButton.lvkb_height = topBtnH;
        }
        
    }
    
}

- (void)dealloc {
    [self.deleteActionTimer invalidate];
    self.deleteActionTimer = nil;
}

@end
