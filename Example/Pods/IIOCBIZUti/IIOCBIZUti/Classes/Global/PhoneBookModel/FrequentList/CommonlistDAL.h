//
//  NewCommonlistModel.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/1/31.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonlistUserId.h"

@interface CommonlistDAL : NSObject

+(void)editCommonlistTablebyUserId:(NSString *)userId clickTimes:(NSInteger)times;
+(NSArray *)getlimitUserIdNum:(int)limit;
+(CommonlistUserId *)getCommonlistUserModel:(NSString *)userId;
+(void)removeCommonListTableByUserId: (NSString *)userid;

@end
