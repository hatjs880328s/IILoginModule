//
//  ShowUploadPictureView.h
//  impcloud_dev
//
//  Created by 衣凡 on 2018/9/29.
//  Copyright © 2018年 Elliot. All rights reserved.
//

#import <UIKit/UIKit.h>
@import IIBaseComponents;

typedef void (^ShowPictureSureHandler)(UIImage *image);
typedef void (^ShowPictureCancelHandler)(void);

@interface ShowUploadPictureViewController : BaseViewController

@property (nonatomic, strong) UIImage *image;
@property (copy, nonatomic) ShowPictureSureHandler sureHandler;
@property (copy, nonatomic) ShowPictureCancelHandler cancelHandler;

- (void)setBlockWithSureBlock: (ShowPictureSureHandler)sureBlock
                withCancelBlock: (ShowPictureCancelHandler)cancelBlock;

@end
