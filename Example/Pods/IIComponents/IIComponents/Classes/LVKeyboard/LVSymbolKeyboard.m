//
//  LVSymbolKeyboard.m
//  字母键盘
//
//  Created by PBOC CS on 15/4/11.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVSymbolKeyboard.h"
#import "UIView+LVExtension.h"
#import "IMPI18N.h"

@interface LVSymbolKeyboard ()

@property (nonatomic, copy)  NSString *title;
@property (nonatomic, strong) NSMutableArray *symbolBtnArrM;

/** 其他按钮 删除按钮 */
@property (nonatomic, strong) UIButton *deleteBtn;
/** 其他按钮 切换至数字键盘 */
@property (nonatomic, strong) UIButton *switchNumBtn;
/** 其他按钮 切换至符号按钮 */
@property (nonatomic, strong) UIButton *switchLetterBtn;
/** 其他按钮 登录 */
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) NSTimer *deleteActionTimer;

@end
@implementation LVSymbolKeyboard

- (NSMutableArray *)symbolBtnArrM {
    if (!_symbolBtnArrM) {
        _symbolBtnArrM = [NSMutableArray array];
    }
    return _symbolBtnArrM;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = @"~`!@#$%^&*()_-+={}[]|\\:;\"'<,>.?/";
        [self setupControls];
    }
    return self;
}

// 添加子控件
- (void)setupControls {
    
    UIImage *image = [UIImage imageNamed:@"c_symbolKeyboardButton"];
    UIImage *highImage = [UIImage imageNamed:@"c_chaKeyboardButtonSel"];
    highImage = [highImage stretchableImageWithLeftCapWidth:highImage.size.width * 0.5 topCapHeight:highImage.size.height * 0.5];
    
    NSUInteger length = self.title.length;
    // 字母按钮
    for (NSUInteger i = 0; i < length; i++) {
        unichar c = [self.title characterAtIndex:i];
        NSString *text = [NSString stringWithFormat:@"%c", c];
        UIButton *symbolBtn = [LVKeyboardTool setupBasicButtonsWithTitle:text image:image highImage:highImage];
        [self addSubview:symbolBtn];
        
        [symbolBtn addTarget:self action:@selector(symbolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.symbolBtnArrM addObject:symbolBtn];
    }
    
    // 其他按钮 ABC、123、回退、login
    // 此处Button显示名称变更，字母和数字键盘点击按钮互换
    self.switchNumBtn = [LVKeyboardTool setupFunctionButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_englishWords") image:[UIImage imageNamed:@"c_character_keyboardSwitchButton"] highImage:[UIImage imageNamed:@"c_character_keyboardSwitchButtonSel"]];
    self.switchLetterBtn = [LVKeyboardTool setupFunctionButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_number") image:[UIImage imageNamed:@"c_character_keyboardSwitchButton"] highImage:[UIImage imageNamed:@"c_character_keyboardSwitchButtonSel"]];

    self.deleteBtn = [LVKeyboardTool setupFunctionButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_delete") image:[UIImage imageNamed:@"c_character_keyboardSwitchButton"] highImage:[UIImage imageNamed:@"c_character_keyboardSwitchButtonSel"]];
    self.loginBtn = [LVKeyboardTool setupSureButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_done") image:[UIImage imageNamed:@"login_c_character_keyboardLoginButton"] highImage:highImage];
    
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backDeleteButtonClick:)]];
    [self.loginBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchNumBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchLetterBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.deleteBtn];
    [self addSubview:self.loginBtn];
    [self addSubview:self.switchNumBtn];
    [self addSubview:self.switchLetterBtn];
    
}

// 符号按钮
- (void)symbolBtnClick:(UIButton *)symbolBtn {
    if ([self.delegate respondsToSelector:@selector(symbolKeyboard:didClickButton:)]) {
        [self.delegate symbolKeyboard:self didClickButton:symbolBtn];
    }
}

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

- (void)functionBtnClick:(UIButton *)switchBtn {
    if ([self.delegate respondsToSelector:@selector(symbolKeyboard:didClickButton:)]) {
        [self.delegate symbolKeyboard:self didClickButton:switchBtn];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat topMargin = 10;
    CGFloat bottomMargin = 8;
    CGFloat leftMargin = 3;
    CGFloat colMargin = 5;
    CGFloat rowMargin = 10;
    
    CGFloat buttonH = (self.lvkb_height - (topMargin + bottomMargin + 3 * rowMargin)) / 4;
    CGFloat buttonW = (self.lvkb_width - 9 * colMargin - leftMargin * 2) / 10;
    
    
    NSUInteger count = self.symbolBtnArrM.count;
    for (NSUInteger i = 0; i < count; i++) {

        UIButton *symbolBtn = (UIButton *)self.symbolBtnArrM[i];
        NSUInteger row = i / 10;
        NSUInteger col = i % 10;
        
        symbolBtn.lvkb_x = leftMargin + (buttonW + colMargin) * col;
        symbolBtn.lvkb_y = topMargin + (buttonH + rowMargin) * row;
        symbolBtn.lvkb_width = buttonW;
        symbolBtn.lvkb_height = buttonH;
    }
    
    CGFloat otherBtnW = 2 * buttonW + colMargin;
    CGFloat otherBtnY = self.lvkb_height - bottomMargin - buttonH;
    self.loginBtn.frame = CGRectMake(self.lvkb_width - leftMargin - otherBtnW, otherBtnY, otherBtnW, buttonH);
    self.deleteBtn.frame = CGRectMake(self.lvkb_width - leftMargin - colMargin - 2 * otherBtnW, otherBtnY, otherBtnW, buttonH);
    self.switchLetterBtn.frame = CGRectMake(self.lvkb_width - leftMargin - 2 * colMargin - 3 * otherBtnW, otherBtnY, otherBtnW, buttonH);
    self.switchNumBtn.frame = CGRectMake(self.lvkb_width - leftMargin - 3 * colMargin - 4 * otherBtnW, otherBtnY, otherBtnW, buttonH);
}

- (void)dealloc {
    [self.deleteActionTimer invalidate];
    self.deleteActionTimer = nil;
}


@end
