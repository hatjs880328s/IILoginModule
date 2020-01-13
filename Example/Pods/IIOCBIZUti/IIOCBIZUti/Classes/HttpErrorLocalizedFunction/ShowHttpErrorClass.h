//
//  ShowHttpErrorClass.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowHttpErrorClass : NSObject

//处理Http Error
+(NSString *)fromHttpError:(int)HttpCode andErrorCode:(int)errorCode;

@end

NS_ASSUME_NONNULL_END
