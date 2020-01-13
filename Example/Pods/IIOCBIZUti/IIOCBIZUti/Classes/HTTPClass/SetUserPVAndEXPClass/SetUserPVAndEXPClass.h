//
//  SetUserPVAndEXPClass.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetUserPVAndEXPClass : NSObject

//用户异常信息收集
+ (void)getUserEXPContentErrorLevel:(NSString *)level ErrorUrl:(NSString *)url ErrorInfo:(NSString *)info errorCode:(NSString *)code;

//用户行为分析收集
+ (void)getUserActionContent:(NSString *)functionID FunctionType:(NSString *)functionType;

@end

NS_ASSUME_NONNULL_END
