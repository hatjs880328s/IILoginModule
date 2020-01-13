//
//  LVKeyboard.m
//  字母键盘
//
//  Created by PBOC CS on 15/4/11.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVKeyboard.h"
#import "LVSymbolKeyboard.h"
#import "LVLetterKeyboard.h"
#import "LVNumberKeyboard.h"
#import "LVKeyboardTool.h"
#define LVScreen_Size [UIScreen mainScreen].bounds.size
@import II18N;
@import IIOCUtis;

@interface LVKeyboard () <LVCustomKeyboardDelegate> {
    UILabel *headerViewLabel;
    UIButton *safeModeboardBtn;
    BOOL isLetterKeyboard;
    BOOL isSymbolKeyboard;
    BOOL isNumberKeyboard;
    BOOL isNeedRandom;
}

@property (nonatomic, strong) LVLetterKeyboard *letterKeyboard;
@property (nonatomic, strong) LVSymbolKeyboard *symbolKeyboard;
@property (nonatomic, strong) LVNumberKeyboard *numberKeyboard;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation LVKeyboard

- (LVLetterKeyboard *)letterKeyboard {
    if (!_letterKeyboard) {
        _letterKeyboard = [LVLetterKeyboard alloc];
        _letterKeyboard = [_letterKeyboard initWithFrame:CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height) needRandom:isNeedRandom];
        _letterKeyboard.delegate = self;
        _letterKeyboard.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _letterKeyboard;
}

- (LVSymbolKeyboard *)symbolKeyboard {
    if (!_symbolKeyboard) {
        _symbolKeyboard = [[LVSymbolKeyboard alloc] initWithFrame:CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height)];
        _symbolKeyboard.delegate = self;
    }
    return _symbolKeyboard;
}

- (LVNumberKeyboard *)numberKeyboard {
    if (!_numberKeyboard) {
        _numberKeyboard = [LVNumberKeyboard alloc];
        _numberKeyboard = [_numberKeyboard initWithFrame:CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height) needRandom:isNeedRandom];
        _numberKeyboard.delegate = self;
    }
    return _numberKeyboard;
}

- (UIView *)headerView {
    if(!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LVScreen_Size.width, 40)];
        _headerView.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1];
        headerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LVScreen_Size.width, 40)];
        headerViewLabel.text = [NSString stringWithFormat:@"%@%@",IMPLocalizedString(@"LoginKeyBoard_title"),IMPLocalizedString(@"LoginKeyBoard_normalMode")];
        headerViewLabel.backgroundColor = [UIColor clearColor];
        headerViewLabel.textColor = [UIColor whiteColor];
        headerViewLabel.font = [UIFont systemFontOfSize:17];
        headerViewLabel.textAlignment = NSTextAlignmentCenter;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height-0.4, _headerView.frame.size.width, 0.4)];
        lineView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [_headerView addSubview:lineView];
        UIButton *changeKeyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(_headerView.frame.size.width-10-40, 0, 40, 40)];
        [changeKeyboardBtn setImage:[UIImage imageNamed:@"keyboard_change"] forState:UIControlStateNormal];
        [changeKeyboardBtn addTarget:self action:@selector(changeKeyboardClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:changeKeyboardBtn];
        safeModeboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
        [safeModeboardBtn setImage:[UIImage imageNamed:@"keyboard_common"] forState:UIControlStateNormal];
        [safeModeboardBtn addTarget:self action:@selector(clickSafeModeButton:) forControlEvents:UIControlEventTouchUpInside];
        safeModeboardBtn.hidden = NO;
        [_headerView addSubview:safeModeboardBtn];
        [_headerView addSubview:headerViewLabel];
    }
    return _headerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if ([Utilities getDeviceSeries] == iPhoneX_Series_2436x1125 || [Utilities getDeviceSeries] == iPhoneXr_Series_1792x828 || [Utilities getDeviceSeries] == iPhoneXsMax_Series_2688x1242) {
            self.frame = CGRectMake(0, LVScreen_Size.height - 320, LVScreen_Size.width, 320);
        }
        else {
            self.frame = CGRectMake(0, LVScreen_Size.height - 256, LVScreen_Size.width, 256 );
        }
        self.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1];
        isLetterKeyboard = YES;
        isSymbolKeyboard = NO;
        isNumberKeyboard = NO;
        isNeedRandom = NO;
        [self addSubview:self.headerView];
        [self addSubview:self.letterKeyboard];
    }
    return self;
}

- (void)letterKeyboard:(LVLetterKeyboard *)letter didClickButton:(UIButton *)button {
    if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_symbol")]) {
        [letter removeFromSuperview];
        safeModeboardBtn.hidden = YES;
        isLetterKeyboard = NO;
        isSymbolKeyboard = YES;
        isNumberKeyboard = NO;
        [self addSubview:self.symbolKeyboard];
    } else if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_number")]) {
        [self.letterKeyboard removeFromSuperview];
        safeModeboardBtn.hidden = NO;
        isLetterKeyboard = NO;
        isSymbolKeyboard = NO;
        isNumberKeyboard = YES;
        [self addSubview:self.numberKeyboard];
    } else if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_done")]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboard:didClickSureButton:string:)]) {
            [self.delegate keyboard:self didClickSureButton:button string:@""];
        }
    } else {
        [self appendString:button];
    }
}

- (void)symbolKeyboard:(LVSymbolKeyboard *)symbol didClickButton:(UIButton *)button {
    if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_englishWords")]) {
        [symbol removeFromSuperview];
        safeModeboardBtn.hidden = NO;
        isLetterKeyboard = YES;
        isSymbolKeyboard = NO;
        isNumberKeyboard = NO;
        [self addSubview:self.letterKeyboard];
    } else if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_number")]) {
        [symbol removeFromSuperview];
        safeModeboardBtn.hidden = NO;
        isLetterKeyboard = NO;
        isSymbolKeyboard = NO;
        isNumberKeyboard = YES;
        [self addSubview:self.numberKeyboard];
    } else if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_done")]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboard:didClickSureButton:string:)]) {
            [self.delegate keyboard:self didClickSureButton:button string:@""];
        }
    } else {
        [self appendString:button];
    }
}

- (void)numberKeyboard:(LVNumberKeyboard *)number didClickButton:(UIButton *)button {
    if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_symbol")]) {
        [number removeFromSuperview];
        safeModeboardBtn.hidden = YES;
        isLetterKeyboard = NO;
        isSymbolKeyboard = YES;
        isNumberKeyboard = NO;
        [self addSubview:self.symbolKeyboard];
    } else if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_englishWords")]) {
        [number removeFromSuperview];
        safeModeboardBtn.hidden = NO;
        isLetterKeyboard = YES;
        isSymbolKeyboard = NO;
        isNumberKeyboard = NO;
        [self addSubview:self.letterKeyboard];
    } else if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_done")]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboard:didClickSureButton:string:)]) {
            [self.delegate keyboard:self didClickSureButton:button string:@""];
        }
    } else {
        [self appendString:button];
    }
}

// 删除方法
- (void)customKeyboardDidClickDeleteButton:(UIButton *)deleteBtn {
    
    //删除textInput文本内容
    [self deleteTextAction];
    
    //删除代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboard:didClickDeleteButton:string:)]) {
        [self.delegate keyboard:self didClickDeleteButton:deleteBtn string:@""];
    }
    
    //文本内容改变代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardDidChangeText:)]) {
        [self.delegate keyboardDidChangeText:self];
    }
}

// textInput文本内容执行删除
-(void)deleteTextAction{
    if (self.textInput == nil) {
        return;
    }
    
    id<UITextInput> textInput = self.textInput;
    
    //判断是否有选择内容
    if (textInput.selectedTextRange.isEmpty) {
        //没有选择的内容,删除光标前一位
        //获取光标的位置,判断是否在首位,前面有无可删除元素
        NSInteger rangeLocal = [textInput offsetFromPosition:textInput.beginningOfDocument toPosition:textInput.selectedTextRange.start];
        
        if (rangeLocal > 0) { //有可删除的内容,不在首位
            //获取光标位置的前一位
            UITextPosition *deleteBeginPosition = [textInput positionFromPosition:textInput.selectedTextRange.start offset:-1];
            //设定删除的范围
            UITextRange *deleteRange = [textInput textRangeFromPosition:deleteBeginPosition toPosition:textInput.selectedTextRange.start];
            //删除选择的删除范围
            [textInput replaceRange:deleteRange withText:@""];
        }
        
    }else{//有选择的内容,直接删除选择的内容
        [textInput replaceRange:textInput.selectedTextRange withText:@""];
    }
}

- (void)appendString:(UIButton *)button {
    NSString *inputString = button.currentTitle ? button.currentTitle : @"";
    if ([button.currentTitle isEqualToString:IMPLocalizedString(@"LoginKeyBoard_space")]) {
        inputString = @" ";
    }
    
    //修改输入框内容
    if (self.textInput) {
        [self.textInput replaceRange:self.textInput.selectedTextRange withText:inputString];
    }
    
    //点按文字代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboard:didClickTextButton:string:)]) {
        [self.delegate keyboard:self didClickTextButton:button string:inputString];
    }
    
    //文本内容改变代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardDidChangeText:)]) {
        [self.delegate keyboardDidChangeText:self];
    }
}

// 点击了切换键盘按钮
- (void)changeKeyboardClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardDidClickChangeKeyboard:)]) {
        [self.delegate keyboardDidClickChangeKeyboard:self];
    }
}

//点击安全模式按钮
- (IBAction)clickSafeModeButton:(UIButton *)sender {
    if (sender.selected) {
        headerViewLabel.text = [NSString stringWithFormat:@"%@%@",IMPLocalizedString(@"LoginKeyBoard_title"),IMPLocalizedString(@"LoginKeyBoard_normalMode")];
        [safeModeboardBtn setImage:[UIImage imageNamed:@"keyboard_common"] forState:UIControlStateNormal];
        sender.selected = NO;
        isNeedRandom = NO;
    }
    else {
        headerViewLabel.text = [NSString stringWithFormat:@"%@%@",IMPLocalizedString(@"LoginKeyBoard_title"),IMPLocalizedString(@"LoginKeyBoard_randomMode")];
        [safeModeboardBtn setImage:[UIImage imageNamed:@"keyboard_safe"] forState:UIControlStateNormal];
        sender.selected = YES;
        isNeedRandom = YES;
    }
    if (_letterKeyboard) {
        [_letterKeyboard removeFromSuperview];
        _letterKeyboard = nil;
        if (isLetterKeyboard) {
            [self addSubview:[self letterKeyboard]];
        }
    }
    if (_symbolKeyboard) {
        [_symbolKeyboard removeFromSuperview];
        _symbolKeyboard = nil;
        if (isSymbolKeyboard) {
            [self addSubview:[self symbolKeyboard]];
        }
    }
    if (_numberKeyboard) {
        [_numberKeyboard removeFromSuperview];
        _numberKeyboard = nil;
        if (isNumberKeyboard) {
            [self addSubview:[self numberKeyboard]];
        }
    }
}

@end
