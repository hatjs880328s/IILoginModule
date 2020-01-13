//
//  ColorSchemeData.m
//  impcloud_dev
//
//  Created by 衣凡 on 2019/2/28.
//  Copyright © 2019年 Elliot. All rights reserved.
//

#import "ColorSchemeData.h"
#import <UIKit/UIKit.h>
//@import IIOCUtis;


#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface ColorSchemeData(){
    NSMutableArray *schemeArray;
}
@end

@implementation ColorSchemeData

static ColorSchemeData *sharedInstance;

+ (instancetype)sharedInstance {
    static dispatch_once_t once;

    dispatch_once(&once, ^{

        sharedInstance = [[self alloc] init];
        [sharedInstance initColorSchemeArray];

    });

    return sharedInstance;
}

- (void)initColorSchemeArray {

    schemeArray = [[NSMutableArray alloc] init];

    ColorScheme *whiteTheme = [[ColorScheme alloc] init];
    whiteTheme.schemeId = ColorThemeWhite;
    whiteTheme.navColor = [UIColor whiteColor];
    whiteTheme.navCharColor = RGBA(51, 51, 51, 1);
    whiteTheme.bgColor = RGBA(248, 249, 251, 1);
    whiteTheme.navRightTextColor = RGBA(54, 165, 246, 1);
    whiteTheme.myChatBgColor = RGBA(54, 165, 246, 1);
    whiteTheme.otherChatBgColor = RGBA(236, 238, 242, 1);
    whiteTheme.blueThemeColor = RGBA(54,165,246,1);
    whiteTheme.switchButtonBgColor = RGBA(54,165,246,1);
    whiteTheme.useDefaultStatusBar = true;
    whiteTheme.tabBarTextNormalColor = RGBA(151,158,163,1);
    whiteTheme.tabBarTextSelectedColor = RGBA(54,165,246,1);
    whiteTheme.bottomButtonColor = RGBA(54,165,246,1);
    whiteTheme.extraActionsBgColor = RGBA(248, 249, 251, 1);
    whiteTheme.appFooterWeight = 10;
    whiteTheme.appLineHeaderWeight = 10;
    whiteTheme.appLabelHeaderWeight = 0;
    whiteTheme.workNaviSubTextColor = RGBA(136, 136, 136, 1);

    ColorScheme *blueTheme = [[ColorScheme alloc] init];
    blueTheme.schemeId = ColorThemeBlue;
    blueTheme.navColor = RGBA(15, 123, 202, 1);
    blueTheme.navCharColor = [UIColor whiteColor];
    blueTheme.bgColor = RGBA(248, 249, 251, 1);
    blueTheme.navRightTextColor = [UIColor whiteColor];
    blueTheme.myChatBgColor = RGBA(54,165,246,1);//RGBA(15, 123, 202, 1);
    blueTheme.otherChatBgColor = [UIColor whiteColor];
    blueTheme.blueThemeColor = RGBA(54,165,246,1);//RGBA(15, 123, 202, 1);
    blueTheme.switchButtonBgColor = RGBA(54,165,246,1);//RGBA(15, 123, 202, 1);
    blueTheme.useDefaultStatusBar = false;
    blueTheme.tabBarTextNormalColor = RGBA(151,158,163,1);
    blueTheme.tabBarTextSelectedColor = RGBA(54,165,246,1);
    blueTheme.bottomButtonColor = RGBA(54,165,246,1);//RGBA(74, 144, 246, 1);
    blueTheme.extraActionsBgColor = RGBA(237, 237, 237, 1);
    blueTheme.appFooterWeight = 0;
    blueTheme.appLineHeaderWeight = 16;
    blueTheme.appLabelHeaderWeight = 6;
    blueTheme.workNaviSubTextColor = RGBA(139, 187, 223, 1);

    ColorScheme *grayTheme = [[ColorScheme alloc] init];
    grayTheme.schemeId = ColorThemeGray;
    grayTheme.navColor = RGBA(242, 242, 242, 1);
    grayTheme.navCharColor = RGBA(51, 51, 51, 1);
    grayTheme.bgColor = RGBA(248, 249, 251, 1);
    grayTheme.navRightTextColor = RGBA(54, 165, 246, 1);
    grayTheme.myChatBgColor = RGBA(54, 165, 246, 1);
    grayTheme.otherChatBgColor = RGBA(236, 238, 242, 1);
    grayTheme.blueThemeColor = RGBA(54,165,246,1);
    grayTheme.switchButtonBgColor = RGBA(54,165,246,1);
    grayTheme.useDefaultStatusBar = true;
    grayTheme.tabBarTextNormalColor = RGBA(102,102,102,1);
    grayTheme.tabBarTextSelectedColor = RGBA(54,165,246,1);
    grayTheme.bottomButtonColor = RGBA(54,165,246,1);
    grayTheme.extraActionsBgColor = [UIColor whiteColor];
    grayTheme.appFooterWeight = 0;
    grayTheme.appLineHeaderWeight = 16;
    grayTheme.appLabelHeaderWeight = 6;
    grayTheme.workNaviSubTextColor = RGBA(136, 136, 136, 1);

    [schemeArray addObject:whiteTheme];
    [schemeArray addObject:grayTheme];
    [schemeArray addObject:blueTheme];
}

- (ColorScheme *)getColorSchemeById:(ColorSchemeTheme)themeName {
    if(schemeArray == nil || schemeArray.count == 0){
        return [[ColorScheme alloc] init];
    }
    ColorScheme *scheme = schemeArray[0];

    for(int i = 0; i < schemeArray.count; i++){
        ColorScheme *data = schemeArray[i];
        if(data.schemeId == themeName){
            scheme = data;
            break;
        }
    }
    return scheme;
}

- (NSArray *)getColorSchemeArray {
    return schemeArray;
}
@end
