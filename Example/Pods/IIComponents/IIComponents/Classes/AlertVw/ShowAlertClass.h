//
//  ShowAlertClass.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^sureBtnClickBlock) (void);
typedef void (^CancelBlock) (void);

@interface ShowAlertClass : NSObject

//弹出确认、警告窗口
+ (void)showAlert:(NSString *)msg;
+ (UIAlertController *)showAlert:(NSString *)msg withClickSureBtnHandler:(sureBtnClickBlock)handler;

//判断相机权限
+ (UIAlertController *)getCameraSettingAlertWithCancelHandler:(CancelBlock)cancelHandler ;

@end

NS_ASSUME_NONNULL_END
