//
//  QueryUserDisplayInfoClass.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/26.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoDisplayConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QueryUserDisplayInfoClass : NSObject

/*个人信息相关*/
//获取个人信息
+(nullable UserInfoDisplayConfigModel *)queryUserDisplayInfo;

@end

NS_ASSUME_NONNULL_END
