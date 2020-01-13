//
//  ShowAlertClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "ShowAlertClass.h"
@import II18N;

@implementation ShowAlertClass

//弹出确认、警告窗口[点击确认无操作]
+ (void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg
                                                   delegate:nil cancelButtonTitle:IMPLocalizedString(@"common_sure") otherButtonTitles:nil];
    [alert show];
}

//弹出确认、警告窗口[点击确认有操作]
+ (UIAlertController *)showAlert:(NSString *)msg withClickSureBtnHandler:(sureBtnClickBlock)handler {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:IMPLocalizedString(@"common_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }]];
    return alertController;
}

//判断相机权限
+ (UIAlertController *)getCameraSettingAlertWithCancelHandler:(CancelBlock)cancelHandler {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:IMPLocalizedString(@"App_Cam_Tips") message: nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:IMPLocalizedString(@"Face_Psw_SetCameraPermissions") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:IMPLocalizedString(@"common_cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cancelHandler();
    }]];
    return alertController;
}

@end
