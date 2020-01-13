//
//  LVLetterKeyboard.m
//  字母键盘
//
//  Created by PBOC CS on 15/4/9.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVLetterKeyboard.h"
#import "UIView+LVExtension.h"
#import "NSArray+Random.h"
@import IIOCUtis;
@import II18N;

@interface LVLetterKeyboard () {
    BOOL isNeedRandom;
}

@property (nonatomic, strong) NSArray *lettersArr;


@property (nonatomic, strong) NSArray *uppersArr;

/** 小写字母按钮 */
@property (nonatomic, strong) NSMutableArray *charBtnsArrM;

/** 其他按钮 */
@property (nonatomic, strong) NSMutableArray *tempArrM;

/** 其他按钮 切换大小写 */
@property (nonatomic, strong) UIButton *shiftBtn;
/** 其他按钮 删除按钮 */
@property (nonatomic, strong) UIButton *deleteBtn;
/** 其他按钮 切换至数字键盘 */
@property (nonatomic, strong) UIButton *switchNumBtn;
/** 其他按钮 切换至符号按钮 */
@property (nonatomic, strong) UIButton *switchSymbolBtn;
/** 其他按钮 登录 */
@property (nonatomic, strong) UIButton *loginBtn;
/** 空格按钮 */
@property (nonatomic, strong) UIButton *spaceBtn;

@property (nonatomic, assign) BOOL isUpper;

@property (nonatomic, strong) NSTimer *deleteActionTimer;

@end


@implementation LVLetterKeyboard

- (NSArray *)lettersArr {
    if (!_lettersArr) {
        NSArray *dataArr = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"];
        if (isNeedRandom) {
            _lettersArr = [dataArr randomizedArray];
        }
        else {
            _lettersArr = dataArr;
        }
    }
    return _lettersArr;
}

- (NSArray *)uppersArr {
    if (!_uppersArr) {
        _uppersArr = [self convertUpChar:_lettersArr];
    }
    return _uppersArr;
}

- (NSArray *)convertUpChar:(NSArray *)arr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i=0; i<arr.count; i++) {
        NSString *upStr = [arr objectAtIndex:i];
        upStr = [upStr uppercaseString];
        [tempArr addObject:upStr];
    }
    NSArray *targetArr = [tempArr copy];
    return targetArr;
}

- (NSMutableArray *)charBtnsArrM {
    if (!_charBtnsArrM) {
        _charBtnsArrM = [NSMutableArray array];
    }
    return _charBtnsArrM;
}

- (NSMutableArray *)tempArrM {
    if (!_tempArrM) {
        _tempArrM = [NSMutableArray array];
    }
    return _tempArrM;
}

- (id)initWithFrame:(CGRect)frame needRandom:(BOOL)random {
    self = [super initWithFrame:frame];
    isNeedRandom = random;
    if (self) {
        self.isUpper = YES;
        [self setupControls];
        
    }
    return self;
}

- (void)setupControls {

    // 添加26个字母按钮
    UIImage *image = [UIImage imageNamed:@"c_chaKeyboardButton"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    UIImage *highImage = [UIImage imageNamed:@"c_chaKeyboardButtonSel"];
    highImage = [highImage stretchableImageWithLeftCapWidth:highImage.size.width * 0.5 topCapHeight:highImage.size.height * 0.5];
    
    NSUInteger count = self.lettersArr.count;
    for (NSUInteger i = 0 ; i < count; i++) {
        
        UIButton *charBtn = [LVKeyboardTool setupBasicButtonsWithTitle:nil image:image highImage:highImage];
        [charBtn addTarget:self action:@selector(charbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:charBtn];
        [self.charBtnsArrM addObject:charBtn];
    }
    
    // 添加其他按钮 切换大小写、删除回退、确定（登录）、数字、符号
    self.shiftBtn = [LVKeyboardTool setupFunctionButtonWithImage:[UIImage imageNamed:@"c_chaKeyboardShiftButton"] highImage:[UIImage imageNamed:@"c_chaKeyboardShiftButtonSel"]];
    if ([Utilities getDeviceSeries] == iPhoneXsMax_Series_2688x1242 || [Utilities getDeviceSeries] == iPhoneXr_Series_1792x828 || [Utilities getDeviceSeries] == iPhone6p_Series_2208x1242) {
        self.deleteBtn = [LVKeyboardTool setupFunctionButtonWithImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPhone6P"] highImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPhone6PSel"]];
    }
    else if ([Utilities getDeviceSeries] == iPhone6_Series_1334x750 || [Utilities getDeviceSeries] == iPhoneX_Series_2436x1125) {
        self.deleteBtn = [LVKeyboardTool setupFunctionButtonWithImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPhone6"] highImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPhone6Sel"]];
        [self.deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -2)];
    }
    else if ([Utilities getDeviceSeries] == iPhone4_Series_960x640 || [Utilities getDeviceSeries] == iPhone5_Series_1136x640) {
        self.deleteBtn = [LVKeyboardTool setupFunctionButtonWithImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPhone5"] highImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPhone5Sel"]];
        [self.deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -3)];
    }
    else if ([Utilities getDeviceSeries] == iPad_2048x1536 || [Utilities getDeviceSeries] == iPad_2388x1668 || [Utilities getDeviceSeries] == iPad_2732x2048 || [Utilities getDeviceSeries] == iPad_2224x1668) {
        self.deleteBtn = [LVKeyboardTool setupFunctionButtonWithImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPad"] highImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPadSel"]];
    }
    else {
        self.deleteBtn = [LVKeyboardTool setupFunctionButtonWithImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPhone6"] highImage:[UIImage imageNamed:@"c_character_keyboardDeleteButtoniPhone6Sel"]];
    }
    self.deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.loginBtn = [LVKeyboardTool setupSureButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_done") image:[UIImage imageNamed:@"login_c_character_keyboardLoginButton"] highImage:highImage];
    self.spaceBtn = [LVKeyboardTool setupFunctionButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_space") image:[UIImage imageNamed:@"c_character_keyboardSwitchButtonSel"] highImage:[UIImage imageNamed:@"c_character_keyboardSwitchButton"]];
    self.switchNumBtn = [LVKeyboardTool setupFunctionButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_number") image:[UIImage imageNamed:@"c_character_keyboardSwitchButton"] highImage:[UIImage imageNamed:@"c_character_keyboardSwitchButtonSel"]];
    self.switchSymbolBtn = [LVKeyboardTool setupFunctionButtonWithTitle:IMPLocalizedString(@"LoginKeyBoard_symbol") image:[UIImage imageNamed:@"c_character_keyboardSwitchButton"] highImage:[UIImage imageNamed:@"c_character_keyboardSwitchButtonSel"]];
    
    [self.shiftBtn addTarget:self action:@selector(changeCharacteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backDeleteButtonClick:)]];
    [self.loginBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.spaceBtn addTarget:self action:@selector(spaceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchNumBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchSymbolBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.shiftBtn];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.loginBtn];
    [self addSubview:self.spaceBtn];
    [self addSubview:self.switchNumBtn];
    [self addSubview:self.switchSymbolBtn];
    
    [self changeCharacteBtnClick:nil];
    
}

- (void)charbuttonClick:(UIButton *)charButton {
    if ([self.delegate respondsToSelector:@selector(letterKeyboard:didClickButton:)]) {
        [self.delegate letterKeyboard:self didClickButton:charButton];
    }
}

- (void)changeCharacteBtnClick:(UIButton *)shiftBtn {
    
    [self.tempArrM removeAllObjects];
    NSUInteger count = self.charBtnsArrM.count;

    if (self.isUpper) {
        [self.shiftBtn setImage:[UIImage imageNamed:@"c_chaKeyboardShiftButton"] forState:UIControlStateNormal];
        self.tempArrM = [NSMutableArray arrayWithArray:self.lettersArr];
        self.isUpper = NO;
    } else {
        [self.shiftBtn setImage:[UIImage imageNamed:@"c_chaKeyboardShiftButtonSel"] forState:UIControlStateNormal];
        self.tempArrM = [NSMutableArray arrayWithArray:self.uppersArr];
        self.isUpper = YES;
    }
    for (int i = 0; i < count; i++) {
        UIButton *charBtn = (UIButton *)self.charBtnsArrM[i];
        NSString *upperTitle = self.tempArrM[i];
        [charBtn setTitle:upperTitle forState:UIControlStateNormal];
        [charBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    if ([self.delegate respondsToSelector:@selector(letterKeyboard:didClickButton:)]) {
        [self.delegate letterKeyboard:self didClickButton:switchBtn];
    }
}

- (void)spaceBtnClick:(UIButton *)btn {
    [self.delegate letterKeyboard:self didClickButton:btn];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat topMargin = 10;
    CGFloat bottomMargin = 8;
    CGFloat leftMargin = 3;
    CGFloat colMargin = 5;
    CGFloat rowMargin = 10;
    
    // 布局字母按钮
    CGFloat buttonW = (self.lvkb_width - 2 * leftMargin - 9 * colMargin) / 10;
    CGFloat buttonH = (self.lvkb_height - topMargin - bottomMargin - 3 * rowMargin) / 4;
    
    NSUInteger count = self.charBtnsArrM.count;
    
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = (UIButton *)self.charBtnsArrM[i];
        button.lvkb_width = buttonW;
        button.lvkb_height = buttonH;
        
        if (i < 10) { // 第一行
            button.lvkb_x = (colMargin + buttonW) * i + leftMargin;
            button.lvkb_y = topMargin;
        } else if (i < 19) { // 第二行
            button.lvkb_x = (colMargin + buttonW) * (i - 10) + leftMargin + buttonW / 2 + colMargin;
            button.lvkb_y = topMargin + rowMargin + buttonH;
        } else if (i < count) {
            button.lvkb_y = topMargin + 2 * rowMargin + 2 * buttonH;
            button.lvkb_x = (colMargin + buttonW) * (i - 19) + leftMargin + buttonW / 2 + colMargin + buttonW + colMargin-5;
        }
    }
    
    // 布局其他功能按钮  切换大小写、删除回退、确定（登录）、 数字、符号
    CGFloat shiftBtnW = buttonW / 2 + colMargin + buttonW;
    CGFloat shiftBtnY = topMargin + 2 * rowMargin + 2 * buttonH;
    self.shiftBtn.frame = CGRectMake(leftMargin, shiftBtnY, shiftBtnW-6, buttonH);

    CGFloat deleteBtnW = buttonW / 2 + buttonW;
    self.deleteBtn.frame = CGRectMake(self.lvkb_width - leftMargin - deleteBtnW-4, shiftBtnY, deleteBtnW, buttonH);

    CGFloat loginBtnW = 2 * buttonW + colMargin;
    CGFloat loginBtnY = self.lvkb_height - bottomMargin - buttonH;
    CGFloat loginBtnX = self.lvkb_width - leftMargin - loginBtnW;
    
    self.loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, buttonH);
    
    CGFloat switchBtnW = (loginBtnX - 2 * colMargin - leftMargin) / 6;
    
    self.switchNumBtn.frame = CGRectMake(leftMargin, loginBtnY, switchBtnW, buttonH);
    self.switchSymbolBtn.frame = CGRectMake(CGRectGetMaxX(self.switchNumBtn.frame) + colMargin, loginBtnY, switchBtnW, buttonH);
    self.spaceBtn.frame = CGRectMake(CGRectGetMaxX(self.switchSymbolBtn.frame) + colMargin, loginBtnY, CGRectGetMaxX(self.loginBtn.frame) - colMargin - CGRectGetMaxX(self.switchSymbolBtn.frame) - colMargin - loginBtnW, buttonH);
}

- (void)dealloc {
    [self.deleteActionTimer invalidate];
    self.deleteActionTimer = nil;
}

@end
