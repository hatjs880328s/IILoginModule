//
//  SetSDImageHeaderClass.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetSDImageHeaderClass : NSObject

//图片请求增加身份验证所需参数
+(void)setSDWebImageHeader;

@end

NS_ASSUME_NONNULL_END
