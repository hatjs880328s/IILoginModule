//
//  GetCharViewControllerClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/26.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "GetCharViewControllerClass.h"

@implementation GetCharViewControllerClass

// 获取chatviewcontroller
+ (nullable UIViewController *)getCharViewController {
    // 反射，查找ChatViewController
    Class con = NSClassFromString(@"ChatViewController");
    if (con != nil) {
        UIViewController *vc = [[NSClassFromString(@"ChatViewController") alloc] init];
        // 反射，查找IIPRIVATE_SessionBody并赋值
        Class obj = NSClassFromString(@"IIPRIVATE_SessionBody");
        if (obj != nil) {
            NSObject *session = [[NSClassFromString(@"IIPRIVATE_SessionBody") alloc] init];
            // 设置peerId
            [session setValue:@"BOT6005" forKey:@"peerId"];
            // 把session给VC赋值
            [vc setValue:session forKey:@"session"];
            // 隐藏BottomBar
            vc.hidesBottomBarWhenPushed = true;
        }
        // 返回生成的VC
        return vc;
    }
    else {
        return nil;
    }
}

@end
