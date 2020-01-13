//
//  ColorScheme.h
//  impcloud_dev
//
//  Created by 衣凡 on 2019/2/14.
//  Copyright © 2019年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, ColorSchemeTheme) {
    ColorThemeWhite = 0,
    ColorThemeBlue,
    ColorThemeGray
};

@interface ColorScheme : NSObject
@property (assign, nonatomic) ColorSchemeTheme schemeId;
//@property (strong, nonatomic) NSString *schemeTitle;
@property (strong, nonatomic) UIColor *navColor;
@property (strong, nonatomic) UIColor *navCharColor;
@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) UIColor *navRightTextColor;
@property (strong, nonatomic) UIColor *myChatBgColor;
@property (strong, nonatomic) UIColor *otherChatBgColor;
@property (strong, nonatomic) UIColor *blueThemeColor;
@property (strong, nonatomic) UIColor *switchButtonBgColor;
@property (assign, nonatomic) BOOL useDefaultStatusBar;
@property (strong, nonatomic) UIColor *tabBarTextNormalColor;
@property (strong, nonatomic) UIColor *tabBarTextSelectedColor;
@property (strong, nonatomic) UIColor *bottomButtonColor;
@property (strong, nonatomic) UIColor *extraActionsBgColor;
@property (assign, nonatomic) CGFloat appFooterWeight;
@property (assign, nonatomic) CGFloat appLineHeaderWeight;
@property (assign, nonatomic) CGFloat appLabelHeaderWeight;
@property (strong, nonatomic) UIColor *workNaviSubTextColor;

@end

NS_ASSUME_NONNULL_END
