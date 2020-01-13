//
//  SelectPictureConfirmManager.m
//  impcloud_dev
//
//  Created by 衣凡 on 2019/3/7.
//  Copyright © 2019年 Elliot. All rights reserved.
//

#import "SelectPictureConfirmManager.h"

@implementation SelectPictureConfirmManager

- (void)showPictureConfirmPage:(UIImage *)image confirmHandler:(ShowPictureSureHandler)handler {
    __block UIWindow *scanWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scanWindow.windowLevel = UIWindowLevelStatusBar;
    scanWindow.hidden = NO;
    scanWindow.rootViewController = [[BaseViewController alloc] init];
    ShowUploadPictureViewController *pictureVC = [[ShowUploadPictureViewController alloc] init];
    pictureVC.image = image;
    pictureVC.view.frame = scanWindow.bounds;
    //__weak typeof(self) weakSelf = self;
    [pictureVC setBlockWithSureBlock:^(UIImage *resultImage) {
        scanWindow.hidden = YES;
        scanWindow = nil;
        handler(resultImage);
        //[weakSelf dealWithImageFromPicker:info image:image dateStr:currentDateStr];
    } withCancelBlock:^{
        scanWindow.hidden = YES;
        scanWindow = nil;
    }];
    [scanWindow.rootViewController presentViewController:pictureVC animated:NO completion:^{

    }];
}
@end
