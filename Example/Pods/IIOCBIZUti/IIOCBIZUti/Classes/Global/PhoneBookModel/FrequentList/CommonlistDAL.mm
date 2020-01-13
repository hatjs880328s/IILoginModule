//
//  NewCommonlistModel.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/1/31.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "CommonlistDAL.h"
#import <WCDB/WCDB.h>
#import "IIDataBase.h"
#import "CommonlistUserId+WCTTableCoding.h"

//WCDB-常用联系人表
#define CommonlistUserTableName @"CommonlistUser"

@implementation CommonlistDAL

//判断常用联系人表是否存在
+ (BOOL)commonlistUserTableExist {
    return [[IIDataBase instance] createTableAndIndexesOfName:CommonlistUserTableName withClass:CommonlistUserId.class];
}

//存储用户信息
+(void)editCommonlistTablebyUserId:(NSString *)userId clickTimes:(NSInteger)times {
    if (![self commonlistUserTableExist]) {
        return;
    }
    CommonlistUserId *model = [[CommonlistUserId alloc] init];
    model.userId = userId;
    model.clickTimes = times;
    BOOL isSaveSuccess = [[IIDataBase instance] insertOrReplaceObject:model into:CommonlistUserTableName];
    if (isSaveSuccess) {
        //NSLog(@"111111111111111111111");
    }
}

+(void)removeCommonListTableByUserId: (NSString *)userid {
    [[IIDataBase instance] deleteObjectsFromTable:CommonlistUserTableName where:CommonlistUserId.userId == userid ];
}

+(NSArray *)getlimitUserIdNum:(int)limit {
    NSArray<CommonlistUserId *> *arr = [[IIDataBase instance] getObjectsOfClass:CommonlistUserId.class fromTable:CommonlistUserTableName orderBy:CommonlistUserId.clickTimes.order(WCTOrderedDescending) limit:limit];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i=0; i<arr.count; i++) {
        CommonlistUserId *model = [arr objectAtIndex:i];
        if(model.userId != nil){
            [tempArr addObject:model.userId];
        }
    }
    NSArray *targetArr = [tempArr copy];
    return targetArr;
}

+(CommonlistUserId *)getCommonlistUserModel:(NSString *)userId {
    CommonlistUserId *model = [[IIDataBase instance] getOneObjectOfClass:CommonlistUserId.class fromTable:CommonlistUserTableName where:CommonlistUserId.userId == userId];
    return model;
}

@end
