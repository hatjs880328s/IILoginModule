//
//  ShowUploadPictureViewController.m
//  impcloud_dev
//
//  Created by 衣凡 on 2018/9/29.
//  Copyright © 2018年 Elliot. All rights reserved.
//

#import "ShowUploadPictureViewController.h"
@import IIOCUtis;

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kScreenWidth                    CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight                   CGRectGetHeight([[UIScreen mainScreen] bounds])
#define IS_IPHONE_X ([Utilities getDeviceSeries] == iPhoneX_Series_2436x1125)
//判断iPHoneXr
#define IS_IPHONE_Xr ([Utilities getDeviceSeries] == iPhoneXr_Series_1792x828)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([Utilities getDeviceSeries] == iPhoneXsMax_Series_2688x1242)
#define SafeAreaBottomHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs_Max == YES) ? 34 : 0)

@implementation ShowUploadPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.frame = [[UIScreen mainScreen] bounds];

    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    myImageView.contentMode = UIViewContentModeScaleAspectFit;
    myImageView.image = _image;


    [self.view addSubview:myImageView];

    CGFloat bottomHeight = 100 + SafeAreaBottomHeight;

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - bottomHeight, kScreenWidth, bottomHeight)];
    bottomView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:bottomView];

    //创建按钮
    UIButton *myReTakeButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 70, 70)];
    myReTakeButton.layer.cornerRadius = 70/2;
    myReTakeButton.backgroundColor = RGBA(244,244,244,0.9);
    [myReTakeButton setImage:[UIImage imageNamed:@"takephoto_retake"] forState:UIControlStateNormal];
    myReTakeButton.layer.masksToBounds = YES;
    [myReTakeButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [myReTakeButton setTitle:@"" forState:UIControlStateNormal];

    UIButton *myUsePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 70 - 40, 0, 70, 70)];
    myUsePhotoButton.layer.cornerRadius = 70/2;
    myUsePhotoButton.backgroundColor = RGBA(244,244,244,0.9);
    [myUsePhotoButton setImage:[UIImage imageNamed:@"takephoto_ok"] forState:UIControlStateNormal];
    myUsePhotoButton.layer.masksToBounds = YES;

    [myUsePhotoButton setTitle:@"" forState:UIControlStateNormal];
    [myUsePhotoButton addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];

    [bottomView addSubview:myReTakeButton];
    [bottomView addSubview:myUsePhotoButton];
}

- (void)setBlockWithSureBlock: (ShowPictureSureHandler)sureBlock
              withCancelBlock: (ShowPictureCancelHandler)cancelBlock {

    _sureHandler = sureBlock;
    _cancelHandler = cancelBlock;
}

- (void)clickSure {
    _sureHandler(_image);
}

- (void)clickCancel {
    _cancelHandler();
}

@end
