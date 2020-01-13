//
//  IIDataBaseManage.mm
//  impcloud_dev
//
//  Created by 衣凡 on 2018/12/21.
//  Copyright © 2018年 Elliot. All rights reserved.
//

#import "IIDataBaseManage.h"
#import "IIDataBase.h"

@implementation IIDataBaseManage
+ (IIDataBaseManage *)instance {
    static IIDataBaseManage *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (void)closeDataBase {
    [[IIDataBase instance] close];
}
@end
