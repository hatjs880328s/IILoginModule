//
//  SelectPictureConfirmManager.h
//  impcloud_dev
//
//  Created by 衣凡 on 2019/3/7.
//  Copyright © 2019年 Elliot. All rights reserved.
//
// 提供从系统相册选择图片后出现的确认界面的调用方法

#import <Foundation/Foundation.h>
#import "ShowUploadPictureViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectPictureConfirmManager : NSObject

- (void)showPictureConfirmPage:(UIImage *)image confirmHandler:(ShowPictureSureHandler)handler;

@end

NS_ASSUME_NONNULL_END
