//
//  NewPhoneBookModel.h
//  impcloud_dev
//
//  Created by 许阳 on 2018/12/26.
//  Copyright © 2018 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneBookUser.h"
#import "PhoneBookOrg.h"

@interface PhoneBookDAL : NSObject

/********************联系人信息数据操作********************/
//存储联系人信息
+ (BOOL)savePersonInfoArray:(NSMutableArray *)arr lastQueryTime:(NSString *)time;
//更改或删除联系人信息
+(BOOL)changePersonInfoArray:(NSMutableArray *)changeArr deletePersonInfoArray:(NSArray *)deleteArr lastQueryTime:(NSString *)time;
/********************联系人信息数据操作********************/

/********************组织信息数据操作********************/
//存储组织信息
+(BOOL)saveOrgInfoArray:(NSMutableArray *)arr lastQueryTime:(NSString *)time rootId:(NSString *)uid;
//更改或删除组织信息
+(BOOL)changeOrgInfoArray:(NSMutableArray *)changeArr deleteOrgInfoArray:(NSArray *)deleteArr lastQueryTime:(NSString *)time rootId:(NSString *)rootId;
/********************组织信息数据操作********************/

//获取parentId下一定数量且包含Key的联系人信息
+(NSArray *)getPersonArraybyKey:(NSString *)str limitNum:(int)limit;
//根据ID获取联系人模型
+ (PhoneBookUser *)getUserModelByID:(NSString *)uid;
//根据ID获取子用户
+(NSArray *)getUserArrlbyID:(NSString *)uid;
//根据ID获取组织信息
+(PhoneBookOrg *)getOrgModelbyID:(NSString *)uid;
//根据ParentID获取组织信息
+(PhoneBookOrg *)getOrgModelbyParentID:(NSString *)pid;
//根据ID获取子组织
+(NSArray *)getOrgArrlbyID:(NSString *)uid;
//根据名称获取联系人
+(NSArray *)getPersonArraybyName:(NSString *)name;
//根据邮箱获取联系人模型
+ (PhoneBookUser *)getPhoneBookUserModelByMail:(NSString *)mail;
//根据联系人ID数组获取联系人信息-排序
+(NSArray *)getPersonArraybyUserIDArray:(NSArray *)arr;
//根据联系人ID数组获取联系人信息-不排序
+(NSArray *)getPersonArraybyUserIDArrayNoOrder:(NSArray *)arr;
//通讯录实时搜索-获取根据拼音排序后的用户ID数组内的联系人信息
+(NSArray *)getPersonArraybyUserIDArray:(NSArray *)arr searchKey:(NSString *)key;
//获取全部联系人数据
+(NSArray *)getAllUserData;
//更新用户的lastquerytime
+(void)updateUserData:(NSString *)userId withLastQueryTime:(NSString *)time;
//更新用户信息
+(BOOL)updateUserModel:(PhoneBookUser *)model;

@end
