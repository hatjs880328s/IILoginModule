//
//  CameraReplaceSystemTakePhotoButtonClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "CameraReplaceSystemTakePhotoButtonClass.h"
#import <UIKit/UIKit.h>

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation CameraReplaceSystemTakePhotoButtonClass

//使用方法为在调用系统相机的类的 - (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated 里调用该方法
+ (void)replaceSystemTakePhotoButtons:(UIViewController *)viewController {
    UIView *PLCropOverlay = [self findView:viewController.view withName:@"PLCropOverlay"];
    if(PLCropOverlay == nil){
        return ;
    }
    [PLCropOverlay setValue:@"" forKey:@"_defaultOKButtonTitle"];
    UIView *PLCropOverlayBottomBar = [self findView:PLCropOverlay withName:@"PLCropOverlayBottomBar"];
    if(PLCropOverlayBottomBar !=nil) {
        UIView *PLCropOverlayPreviewBottomBar = [self findView:PLCropOverlayBottomBar withName:@"PLCropOverlayPreviewBottomBar"];
        PLCropOverlayPreviewBottomBar.backgroundColor = [UIColor blackColor];
        //获得系统的重拍按钮
        UIButton *retakeButton = PLCropOverlayPreviewBottomBar.subviews.firstObject;
        [retakeButton setTitle:@"" forState:UIControlStateNormal];
        //获得系统的使用照片按钮
        UIButton *systemSureButton = PLCropOverlayPreviewBottomBar.subviews.lastObject;
        [systemSureButton setTitle:@"" forState:UIControlStateNormal];
        //自己创建按钮
        UIButton *myReTakeButton = [[UIButton alloc] initWithFrame:CGRectMake(40, -20, 70, 70)];
        myReTakeButton.layer.cornerRadius = 70/2;
        myReTakeButton.backgroundColor = RGBA(244,244,244,0.9);
        [myReTakeButton setImage:[UIImage imageNamed:@"takephoto_retake"] forState:UIControlStateNormal];
        myReTakeButton.layer.masksToBounds = YES;
        [myReTakeButton setTitle:@"" forState:UIControlStateNormal];
        UIButton *myUsePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 70 - 40, -20, 70, 70)];
        myUsePhotoButton.layer.cornerRadius = 70/2;
        myUsePhotoButton.backgroundColor = RGBA(244,244,244,0.9);
        [myUsePhotoButton setImage:[UIImage imageNamed:@"takephoto_ok"] forState:UIControlStateNormal];
        myUsePhotoButton.layer.masksToBounds = YES;
        [myUsePhotoButton setTitle:@"" forState:UIControlStateNormal];
        //将重拍和使用照片的点击事件复制到自己新建的按钮上
        for (id target in retakeButton.allTargets) {
            NSArray *actions = [retakeButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            for (NSString *action in actions) {
                [myReTakeButton addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        for (id target in systemSureButton.allTargets) {
            NSArray *actions = [systemSureButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            for (NSString *action in actions) {
                [myUsePhotoButton addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [PLCropOverlayPreviewBottomBar addSubview:myReTakeButton];
        [PLCropOverlayPreviewBottomBar addSubview:myUsePhotoButton];
    }
}

+ (UIView *)findView:(UIView *)aView withName:(NSString *)name {
    if ([name isEqualToString:NSStringFromClass(aView.class)]) {
        return aView;
    }
    for (UIView *view in aView.subviews) {
        if ([name isEqualToString:NSStringFromClass(view.class)]) {
            return view;
        }
    }
    return nil;
}

@end
