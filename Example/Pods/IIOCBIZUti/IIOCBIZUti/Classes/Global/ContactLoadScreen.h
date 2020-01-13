//
//  ContactLoadScreen.h
//  impcloud_dev
//
//  Created by Elliot on 2018/5/14.
//  Copyright © 2018年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactProgress.h"

@interface ContactLoadScreen : NSObject {
@private
    UIWindow * _contactLoadScreenWindow;
    ContactProgress * _contactProgress;
}
+ (instancetype)sharedInstance;
- (void)show;
- (void)hide;
- (BOOL)isHidden;

- (void)finishContact;
- (void)finishTabBar;

@end

