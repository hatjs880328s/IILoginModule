//
//  ColorSchemeData.h
//  impcloud_dev
//
//  Created by 衣凡 on 2019/2/28.
//  Copyright © 2019年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorScheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorSchemeData : NSObject

+ (instancetype)sharedInstance;
- (ColorScheme *)getColorSchemeById:(ColorSchemeTheme)themeName;
- (NSArray *)getColorSchemeArray;
@end

NS_ASSUME_NONNULL_END

