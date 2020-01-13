//
//  ATQRCodeManager.h
//  艾特智家
//
//  Created by asame_liao on 16/8/15.
//  Copyright © 2016年 aite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATQRCodeManager : UIView

+ (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString;

+ (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage andSize:(CGFloat)size;

/*
 @param urlString 传入要生成w二维码的字符串
 
  @param size 大小

 */
+ (UIImage *)creatQRcodeWithUrlstring:(NSString *)urlString size:(CGFloat )size;
/*
 @param img 要加水印的二维码
 
  @param logo 图片水印

 */
+ (UIImage *)addImageLogo:(UIImage *)img text:(UIImage *)logo;

@end
