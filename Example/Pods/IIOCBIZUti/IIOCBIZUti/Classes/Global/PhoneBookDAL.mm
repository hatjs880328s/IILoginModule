//
//  NewPhoneBookModel.m
//  impcloud_dev
//
//  Created by 许阳 on 2018/12/26.
//  Copyright © 2018 Elliot. All rights reserved.
//

#import "PhoneBookDAL.h"
#import <WCDB/WCDB.h>
#import "Contacts.pbobjc.h"
#import "ContactLoadScreen.h"
#import "PhoneBookUser+WCTTableCoding.h"
#import "PhoneBookOrg+WCTTableCoding.h"
#import "IIDataBase.h"
#import "IMPUserModel.h"
#import "Constants.h"
#import "GlobalAction.h"

//WCDB-联系人表
#define PhoneBookUserTableName @"PhoneBookUser"
//WCDB-组织表
#define PhoneBookOrgTableName  @"PhoneBookOrg"

@implementation PhoneBookDAL

/********************联系人信息数据操作********************/
//判断联系人数据表是否存在
+ (BOOL)phoneBookUserTableExist {
    return [[IIDataBase instance] createTableAndIndexesOfName:PhoneBookUserTableName withClass:PhoneBookUser.class];
}

//存储用户信息
+ (BOOL)savePersonInfoArray:(NSMutableArray *)arr lastQueryTime:(NSString *)time {
    if (![self phoneBookUserTableExist]) {
        //关闭Loading页面
        [self closeLoadingPageofLogin];
        return NO;
    }
    BOOL isSaveSuccess = [[IIDataBase instance] insertOrReplaceObjectsByTransaction:[arr copy] into:PhoneBookUserTableName];
    if (isSaveSuccess) {
        //如果存储事务执行成功，记录查询时间
        [self saveToNSUserDefaultsObject:time Key:WCDBUserQueryTime];
    }
    else {
        //关闭Loading页面
        [self closeLoadingPageofLogin];
    }
    return isSaveSuccess;
}
//更改或删除联系人信息
+ (BOOL)changePersonInfoArray:(NSMutableArray *)changeArr deletePersonInfoArray:(NSArray *)deleteArr lastQueryTime:(NSString *)time {
    /*
     更新或者删除联系人,这里有四种逻辑：
     一，如果是changeArr和deleteArr都不为空，则走同时执行更新和删除的事务，若事务执行成功记录查询时间
     二，如果是changeArr不为空，而deleteArr为空，则走更新数据事务，若事务执行成功记录查询时间
     三，如果是changeArr为空，而deleteArr不为空，则走删除数据事务，若事务执行成功记录查询时间
     四，如果是changeArr和deleteArr都为空，则记录查询时间
     */
    if (![self phoneBookUserTableExist]) {
        //关闭Loading页面
        [self closeLoadingPageofLogin];
        return NO;
    }
    if (changeArr.count>0&&deleteArr.count>0) {
        BOOL isChangeAndDeleteSuccess = [[IIDataBase instance] transactionWithInsertObjects:[changeArr copy] insertInto:PhoneBookUserTableName deleteObjectsFrom:PhoneBookUserTableName deleteWhere:PhoneBookUser.id_p.in(deleteArr)];
        if (isChangeAndDeleteSuccess) {
            //成功，记录查询时间
            [self saveToNSUserDefaultsObject:time Key:WCDBUserQueryTime];
        }
        return isChangeAndDeleteSuccess;
    }
    else if (changeArr.count>0&&deleteArr.count==0) {
        BOOL isChangeSuccess = [[IIDataBase instance] insertOrReplaceObjectsByTransaction:[changeArr copy] into:PhoneBookUserTableName];
        if (isChangeSuccess) {
            //成功，记录查询时间
            [self saveToNSUserDefaultsObject:time Key:WCDBUserQueryTime];
        }
        return isChangeSuccess;
    }
    else if (changeArr.count==0&&deleteArr.count>0) {
        BOOL isDeleteSuccess = [[IIDataBase instance] deleteObjectsFromTableByTransaction:PhoneBookUserTableName where:PhoneBookUser.id_p.in(deleteArr)];
        if (isDeleteSuccess) {
            //成功，记录查询时间
            [self saveToNSUserDefaultsObject:time Key:WCDBUserQueryTime];
        }
        return isDeleteSuccess;
    }
    else {
        //记录查询时间
        [self saveToNSUserDefaultsObject:time Key:WCDBUserQueryTime];
        return YES;
    }
}
//关闭Loading页面
+(void)closeLoadingPageofLogin {
    if (![[ContactLoadScreen sharedInstance] isHidden]) {
        [[ContactLoadScreen sharedInstance] finishContact];
    }
}
/********************联系人信息数据操作********************/

/********************组织信息数据操作********************/
//判断组织数据表是否存在
+ (BOOL)phoneBookOrgTableExist {
    return [[IIDataBase instance] createTableAndIndexesOfName:PhoneBookOrgTableName withClass:PhoneBookOrg.class];
}
//存储组织信息
+(BOOL)saveOrgInfoArray:(NSMutableArray *)arr lastQueryTime:(NSString *)time rootId:(NSString *)uid {
    if (![self phoneBookOrgTableExist]) {
        //关闭Loading页面
        [self closeLoadingPageofLogin];
        return NO;
    }
    BOOL isSaveSuccess = [[IIDataBase instance] insertOrReplaceObjectsByTransaction:[arr copy] into:PhoneBookOrgTableName];
    if (isSaveSuccess) {
        //如果存储事务执行成功，记录查询时间，记录用户可查看的组织RootID
        [self saveToNSUserDefaultsObject:time Key:WCDBOrgQueryTime];
        [self saveToNSUserDefaultsObject:uid Key:WCDBUserOrgRootID];
    }
    return isSaveSuccess;
}
//更改或删除组织信息
+(BOOL)changeOrgInfoArray:(NSMutableArray *)changeArr deleteOrgInfoArray:(NSArray *)deleteArr lastQueryTime:(NSString *)time rootId:(NSString *)rootId {
    /*
     更新或者删除组织,这里有四种逻辑：
     一，如果是changeArr和deleteArr都不为空，则走同时执行更新和删除的事务，若事务执行成功记录查询时间
     二，如果是changeArr不为空，而deleteArr为空，则走更新数据事务，若事务执行成功记录查询时间
     三，如果是changeArr为空，而deleteArr不为空，则走删除数据事务，若事务执行成功记录查询时间
     四，如果是changeArr和deleteArr都为空，则记录查询时间
     */
    if (![self phoneBookOrgTableExist]) {
        return NO;
    }
    //存储WCDBUserOrgRootID
    [self saveToNSUserDefaultsObject:rootId Key:WCDBUserOrgRootID];
    if (changeArr.count>0&&deleteArr.count>0) {
        BOOL isChangeAndDeleteSuccess = [[IIDataBase instance] transactionWithInsertObjects:[changeArr copy] insertInto:PhoneBookOrgTableName deleteObjectsFrom:PhoneBookOrgTableName deleteWhere:PhoneBookUser.id_p.in(deleteArr)];
        if (isChangeAndDeleteSuccess) {
            //成功，记录查询时间
            [self saveToNSUserDefaultsObject:time Key:WCDBOrgQueryTime];
        }
        return isChangeAndDeleteSuccess;
    }
    else if (changeArr.count>0&&deleteArr.count==0) {
        BOOL isChangeSuccess = [[IIDataBase instance] insertOrReplaceObjectsByTransaction:[changeArr copy] into:PhoneBookOrgTableName];
        if (isChangeSuccess) {
            //成功，记录查询时间
            [self saveToNSUserDefaultsObject:time Key:WCDBOrgQueryTime];
        }
        return isChangeSuccess;
    }
    else if (changeArr.count==0&&deleteArr.count>0) {
        BOOL isDeleteSuccess = [[IIDataBase instance] deleteObjectsFromTableByTransaction:PhoneBookOrgTableName where:PhoneBookOrg.id_p.in(deleteArr)];
        if (isDeleteSuccess) {
            //成功，记录查询时间
            [self saveToNSUserDefaultsObject:time Key:WCDBOrgQueryTime];
        }
        return isDeleteSuccess;
    }
    else {
        //记录查询时间
        [self saveToNSUserDefaultsObject:time Key:WCDBOrgQueryTime];
        return YES;
    }
}
/********************组织信息数据操作********************/

//存储NSUserDefaults
+(void)saveToNSUserDefaultsObject:(NSString *)obj Key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([key isEqualToString:WCDBUserQueryTime]) {
        //关闭Loading页面
        [[GlobalAction shareInstance] loadPhonebook];
        [self closeLoadingPageofLogin];
    }
}

//获取parentId下一定数量且包含Key的联系人信息
+(NSArray *)getPersonArraybyKey:(NSString *)str limitNum:(int)limit {
    NSString *newKey = [self setNewStr:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    //判断是否为全数字
    if (newKey.length > 3 && [self deptNumInputShouldNumber:newKey]) {
        return [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:(PhoneBookUser.mobile.like([NSString stringWithFormat:@"%%%@%%",newKey]) || PhoneBookUser.realName.like([NSString stringWithFormat:@"%%%@%%",newKey])) limit:limit];
    }
    NSMutableArray<PhoneBookUser *> *targetArr = [[NSMutableArray alloc] init];
    NSArray<PhoneBookUser *> *arr1 = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:(PhoneBookUser.realName == newKey || PhoneBookUser.pinyin == newKey || PhoneBookUser.nameGlobal == newKey || PhoneBookUser.email == newKey) limit:limit];
    [targetArr addObjectsFromArray:arr1];
    if (limit == -1 || targetArr.count < limit) {
        NSArray<PhoneBookUser *> *arr2 = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:((PhoneBookUser.realName.like([NSString stringWithFormat:@"%@%%",newKey]) || PhoneBookUser.pinyin.like([NSString stringWithFormat:@"%@%%",newKey]) || PhoneBookUser.nameGlobal.like([NSString stringWithFormat:@"%@%%",newKey]) || PhoneBookUser.email.like([NSString stringWithFormat:@"%@%%",newKey])) && (PhoneBookUser.id_p.notIn([self getUserID:targetArr]))) limit:limit];
        [targetArr addObjectsFromArray:arr2];
    }
    if (limit == -1 || targetArr.count < limit) {
        NSArray<PhoneBookUser *> *arr3 = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:((PhoneBookUser.realName.like([NSString stringWithFormat:@"%%%@",newKey]) || PhoneBookUser.pinyin.like([NSString stringWithFormat:@"%%%@",newKey]) || PhoneBookUser.nameGlobal.like([NSString stringWithFormat:@"%%%@",newKey]) || PhoneBookUser.email.like([NSString stringWithFormat:@"%%%@",newKey])) && (PhoneBookUser.id_p.notIn([self getUserID:targetArr]))) limit:limit];
        [targetArr addObjectsFromArray:arr3];
    }
    if (limit == -1 || targetArr.count < limit) {
        NSArray<PhoneBookUser *> *arr4 = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:((PhoneBookUser.realName.like([NSString stringWithFormat:@"%%%@%%",newKey]) || PhoneBookUser.pinyin.like([NSString stringWithFormat:@"%%%@%%",newKey]) || PhoneBookUser.nameGlobal.like([NSString stringWithFormat:@"%%%@%%",newKey]) || PhoneBookUser.email.like([NSString stringWithFormat:@"%%%@%%",newKey])) && (PhoneBookUser.id_p.notIn([self getUserID:targetArr]))) limit:limit];
        [targetArr addObjectsFromArray:arr4];
    }
    if (limit == -1 || targetArr.count < limit) {
        NSString *str = newKey;
        int length = (int)[str length];
        NSMutableString *newStr = [[NSMutableString alloc] init];
        for (int i=0; i<length; i++) {
            NSString *target  = [NSString stringWithFormat:@"%@%%",[str substringWithRange:NSMakeRange(i, 1)]];
            [newStr appendString:target];
        }
        NSArray<PhoneBookUser *> *arr5 = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:((PhoneBookUser.realName.like(newStr) || PhoneBookUser.pinyin.like(newStr) || PhoneBookUser.nameGlobal.like(newStr) || PhoneBookUser.email.like(newStr)) && (PhoneBookUser.id_p.notIn([self getUserID:targetArr]))) limit:limit];
        [targetArr addObjectsFromArray:arr5];
    }
    NSArray *arr = [targetArr copy];
    return arr;
}

//根据ID获取联系人模型
+ (PhoneBookUser *)getUserModelByID:(NSString *)uid {
    PhoneBookUser *model = [[IIDataBase instance] getOneObjectOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:PhoneBookUser.id_p == uid];
    return model;
}

//根据ID获取子用户
+(NSArray *)getUserArrlbyID:(NSString *)uid {
    NSArray<PhoneBookUser *> *targetArr = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:PhoneBookUser.parentId == uid orderBy:PhoneBookUser.sortOrder.order(WCTOrderedAscending)];
    return targetArr;
}

//根据ID获取组织信息
+(PhoneBookOrg *)getOrgModelbyID:(NSString *)uid {
    PhoneBookOrg *model = [[IIDataBase instance] getOneObjectOfClass:PhoneBookOrg.class fromTable:PhoneBookOrgTableName where:PhoneBookOrg.id_p == uid];
    return model;
}

//根据ParentID获取组织信息
+(PhoneBookOrg *)getOrgModelbyParentID:(NSString *)pid {
    PhoneBookOrg *model = [[IIDataBase instance] getOneObjectOfClass:PhoneBookOrg.class fromTable:PhoneBookOrgTableName where:PhoneBookOrg.parentId == pid];
    return model;
}

//根据ID获取子组织
+(NSArray *)getOrgArrlbyID:(NSString *)uid {
    NSArray<PhoneBookOrg *> *targetArr = [[IIDataBase instance] getObjectsOfClass:PhoneBookOrg.class fromTable:PhoneBookOrgTableName where:PhoneBookOrg.parentId == uid orderBy:PhoneBookOrg.sortOrder.order(WCTOrderedAscending)];
    return targetArr;
}

//根据名称获取联系人
+(NSArray *)getPersonArraybyName:(NSString *)name {
    NSArray<PhoneBookUser *> *targetArr = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:PhoneBookUser.realName == name || PhoneBookUser.nameGlobal == name];
    return targetArr;
}

//根据邮箱获取联系人模型
+ (PhoneBookUser *)getPhoneBookUserModelByMail:(NSString *)mail {
    PhoneBookUser *model = [[IIDataBase instance] getOneObjectOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:PhoneBookUser.email == mail];
    return model;
}

//根据联系人ID数组获取联系人信息-排序
+(NSArray *)getPersonArraybyUserIDArray:(NSArray *)arr {
    NSArray<PhoneBookUser *> *targetArr = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:PhoneBookUser.id_p.in(arr) orderBy:PhoneBookUser.sortOrder.order(WCTOrderedAscending)];
    return targetArr;
}

//根据联系人ID数组获取联系人信息-不排序
+(NSArray *)getPersonArraybyUserIDArrayNoOrder:(NSArray *)arr {
    NSArray<PhoneBookUser *> *targetArr = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:PhoneBookUser.id_p.in(arr)];
    return targetArr;
}

//通讯录实时搜索-获取根据拼音排序后的用户ID数组内的联系人信息
+(NSArray *)getPersonArraybyUserIDArray:(NSArray *)arr searchKey:(NSString *)key {
    NSString *newKey = [self setNewStr:[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    int length = (int)[newKey length];
    NSMutableString *newStr = [[NSMutableString alloc] init];
    for (int i=0; i<length; i++) {
        NSString *target  = [NSString stringWithFormat:@"%@%%",[newKey substringWithRange:NSMakeRange(i, 1)]];
        [newStr appendString:target];
    }
    //@"SELECT * FROM PhoneBook where inspur_id IN %@ and (pinyin like '%%%@' or real_name like '%%%@') ORDER BY pinyin"
    NSArray<PhoneBookUser *> *targetArr = [[IIDataBase instance] getObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName where:PhoneBookUser.id_p.in(arr) && (PhoneBookUser.realName.like(newStr) || PhoneBookUser.nameGlobal.like(newStr) || PhoneBookUser.pinyin.like(newStr)) orderBy:PhoneBookUser.pinyin.order(WCTOrderedAscending) limit:200];
    return targetArr;
}

//获取全部联系人数据
+(NSArray *)getAllUserData {
    return [[IIDataBase instance] getAllObjectsOfClass:PhoneBookUser.class fromTable:PhoneBookUserTableName];
}

//更新用户的lastquerytime
+(void)updateUserData:(NSString *)userId withLastQueryTime:(NSString *)time {
    PhoneBookUser *model = [[PhoneBookUser alloc] init];
    model.id_p = userId;
    model.lastQueryTime = time;
    [[IIDataBase instance] updateRowsInTable:PhoneBookUserTableName onProperty:PhoneBookUser.lastQueryTime withObject:model where:PhoneBookUser.id_p == userId];
}

//过滤Key，可能含有\\s、\U0000202d、\U0000202c影响查询
+ (NSString *)setNewStr:(NSString *)str {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"\U0000202d" withString:@""];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"\U0000202c" withString:@""];
    NSString *newKey = modifiedString;
    return newKey;
}

+ (NSArray *)getUserID:(NSMutableArray *)arr {
    NSMutableArray *tempArr = [NSMutableArray new];
    for (int i = 0; i < arr.count; i++) {
        PhoneBookUser *model = arr[i];
        [tempArr addObject:model.id_p];
    }
    NSArray *targetArr = [tempArr copy];
    return targetArr;
}

//判断是否均是数字
+ (BOOL)deptNumInputShouldNumber:(NSString *)str {
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

//更新用户信息
+(BOOL)updateUserModel:(PhoneBookUser *)model {
    return [[IIDataBase instance] insertOrReplaceObject:model into:PhoneBookUserTableName];
}


@end
