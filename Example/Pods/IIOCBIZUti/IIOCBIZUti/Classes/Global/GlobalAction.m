//
//  GlobalAction.m
//  impcloud
//
//  Created by hctek on 16/11/11.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import "GlobalAction.h"
#import "ContactLoadScreen.h"
#import "Contacts.pbobjc.h"
#import "PhoneBookUser.h"
#import "PhoneBookOrg.h"
#import "OldPhoneBookModel.h"
#import "PhoneBookDAL.h"
#import "IMPUserModel.h"
#import "Constants.h"
#import "TakeRouterSocketAdressClass.h"
#import "IMPHttpSvc.h"

@interface GlobalAction () {
    UIView                   *loadingView;
    UIActivityIndicatorView  *indicatorView;
    UILabel                  *titleLabel;
    CheckQuerySuccessHandler getPhoneBookUserHandler;
    CheckQuerySuccessHandler getPhoneBookOrgHandler;
}

@end

@implementation GlobalAction

+ (GlobalAction *)shareInstance {
    static dispatch_once_t once;
    static GlobalAction *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)getPhonebookUserWithSuccessHandler:(CheckQuerySuccessHandler)handler {
    getPhoneBookUserHandler = handler;
    [self getUserPhonebook];
}

- (void)getPhonebookOrgWithSuccessHandler:(CheckQuerySuccessHandler)handler {
    getPhoneBookOrgHandler = handler;
    [self getOrgPhonebook];
}

- (NSString *)getPBUpdateTimeById:(NSString *)uid {
    if (!_phonebookDic[uid] || !_phonebookDic[uid][@"head"]) {
        return @"";
    }
    return _phonebookDic[uid][@"head"];
}

- (BOOL)getPBAvatarExist:(NSString *)uid {
    if (!_phonebookDic[uid] || !_phonebookDic[uid][@"avatarExist"]) {
        return NO;
    }
    return [_phonebookDic[uid][@"avatarExist"] integerValue] > 0 ? YES : NO;
}

- (NSString *)getPBRealNameById:(NSString *)uid {
    if (!_phonebookDic || !_phonebookDic[uid] || !_phonebookDic[uid][@"name"]) {
        return @"";
    }
    return _phonebookDic[uid][@"name"];
}

- (void)updatePBRealName:(NSString *)name byId:(NSString *)uid {
    if (!_phonebookDic) {
        _phonebookDic = [[NSMutableDictionary alloc] init];
    }
    if (!_phonebookDic[uid]) {
        [_phonebookDic setValue:[[NSMutableDictionary alloc] init] forKey:uid];
    }
    [_phonebookDic[uid] setValue:name forKey:@"name"];
}

- (void)updatePBUpdateTime:(NSString *)updateTime byId:(NSString *)uid {
    if (!_phonebookDic) {
        _phonebookDic = [[NSMutableDictionary alloc] init];
    }
    if (!_phonebookDic[uid]) {
        [_phonebookDic setValue:[[NSMutableDictionary alloc] init] forKey:uid];
    }
    [_phonebookDic[uid] setValue:updateTime forKey:@"head"];
}

- (void)loadPhonebook {
    _phonebookDic = [[NSMutableDictionary alloc] init];
    NSArray *arr = [PhoneBookDAL getAllUserData];
    for (int i=0; i<arr.count; i++) {
        PhoneBookUser *model = [arr objectAtIndex:i];
        if (model.id_p != nil) {
            NSString *updateTime = model.lastQueryTime;
            if (updateTime == nil) {
                updateTime = @"";
            }
            NSString *name = model.realName;
            if (updateTime == nil) {
                updateTime = @"";
            }
            BOOL avatarExist = model.hasHead;
            NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:@{@"head":updateTime, @"name":name, @"avatarExist" : avatarExist ? @1 : @0}];
            [_phonebookDic setValue:info forKey:model.id_p];
        }
    }
    _finishLoadPhoneBook = YES;
}

//获取联系人信息
-(void)getUserPhonebook {
    /*
     获取联系人,这里有两种逻辑：
     一，如果是本地不存在上次查询时间，则走获取全部联系人信息API，数据返回类型为Proto数据
     二，如果是本地存在上次查询时间，则走一般更新删除联系人信息API，数据返回类型为JSON数据
     */
    NSString *queryTime = [[NSUserDefaults standardUserDefaults] objectForKey:WCDBUserQueryTime];
    if (queryTime == nil) {
        [self getUserAllInfo];
    }
    else {
        [self getUserChangeorDeleteInfo:queryTime];
    }
}
-(void)getUserAllInfo {
    //获取全部联系人
    NSString *url = [NSString stringWithFormat:@"%@%@",[TakeRouterSocketAdressClass getAppEMMIP],@"/api/sys/v4.0/contacts/users"];
    __weak typeof(self) weakSelf = self;
    [IMPHttpSvc POST:url parameters:nil isHTTPResponseSerializer:YES success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        users *protobuf = [users parseFromData:(NSData *)responseObject error:&error];
        if (error) {
            //关闭Loading页面
            [self closeLoadingPageofLogin];
            return;
        }
        NSString *lastQueryTime = [NSString stringWithFormat:@"%lld",protobuf.lastQueryTime];
        NSMutableArray *targetArr = [[NSMutableArray alloc] init];
        for (int i=0; i<protobuf.usersArray.count; i++) {
            user *userProto = protobuf.usersArray[i];
            PhoneBookUser *data = [[PhoneBookUser alloc] init];
            data.id_p = userProto.id_p;
            data.realName = userProto.realName;
            data.nameGlobal = userProto.nameGlobal;
            data.pinyin = userProto.pinyin;
            data.mobile = userProto.mobile;
            data.email = userProto.email;
            data.parentId = userProto.parentId;
            data.office = userProto.office;
            data.tel = userProto.tel;
            data.hasHead = userProto.hasHead;
            data.sortOrder = userProto.sortOrder;
            data.lastQueryTime = lastQueryTime;
            [targetArr addObject:data];
        }
        BOOL dbSaveSuccess = [PhoneBookDAL savePersonInfoArray:targetArr lastQueryTime:lastQueryTime];
        if(dbSaveSuccess) {
            self->getPhoneBookUserHandler(YES);
        }
        else {
            self->getPhoneBookUserHandler(NO);
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        //关闭Loading页面
        [weakSelf closeLoadingPageofLogin];
        self->getPhoneBookUserHandler(NO);
    }];
}
-(void)getUserChangeorDeleteInfo:(NSString *)lastQueryTime {
    //一般更新删除联系人
    NSDictionary *dict = @{@"lastQueryTime":lastQueryTime};
    NSString *url = [NSString stringWithFormat:@"%@%@",[TakeRouterSocketAdressClass getAppEMMIP],@"/api/sys/v3.0/contacts/users"];
    __weak typeof(self) weakSelf = self;
    [IMPHttpSvc POST:url parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            //关闭Loading页面
            [self closeLoadingPageofLogin];
            return;
        }
        NSDictionary *dic = responseObject;
        NSArray *arr = [dic objectForKey:@"changed"];
        NSString *queryTime = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"lastQueryTime"] integerValue]];
        NSMutableArray *changeData = [[NSMutableArray alloc] init];
        for (int i=0; i<arr.count; i++) {
            OldPhoneBookModel *tempModel = [[OldPhoneBookModel alloc] initWithDictionary:[arr objectAtIndex:i]];
            PhoneBookUser *data = [[PhoneBookUser alloc] init];
            data.id_p = tempModel.inspur_id;
            data.realName = tempModel.real_name;
            data.nameGlobal = tempModel.name_global;
            data.pinyin = tempModel.pinyin;
            data.mobile = tempModel.mobile;
            data.email = tempModel.email;
            data.parentId = tempModel.parent_id;
            data.office = tempModel.office;
            data.tel = tempModel.tel;
            data.hasHead = tempModel.has_head;
            data.sortOrder = tempModel.sort_order;
            data.lastQueryTime = queryTime;
            [changeData addObject:data];
        }
        NSArray *deleteData = [dic objectForKey:@"deleted"];
        BOOL dbSaveSuccess = [PhoneBookDAL changePersonInfoArray:changeData deletePersonInfoArray:deleteData  lastQueryTime:queryTime];
        if(dbSaveSuccess) {
            self->getPhoneBookUserHandler(YES);
        }
        else {
            self->getPhoneBookUserHandler(NO);
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        //关闭Loading页面
        [weakSelf closeLoadingPageofLogin];
        self->getPhoneBookUserHandler(NO);
    }];
}

//获取组织信息
-(void)getOrgPhonebook {
    /*
     获取组织,这里有两种逻辑：
     一，如果是本地不存在上次查询时间，则走获取全部组织信息API，数据返回类型为Proto数据
     二，如果是本地存在上次查询时间，则走一般更新删除组织信息API，数据返回类型为JSON数据
     */
    NSString *queryTime = [[NSUserDefaults standardUserDefaults] objectForKey:WCDBOrgQueryTime];
    if (queryTime == nil) {
        [self getOrgAllInfo];
    }
    else {
        [self getOrgChangeorDeleteInfo:queryTime];
    }
}
-(void)getOrgAllInfo {
    //获取全部组织信息
    NSString *url = [NSString stringWithFormat:@"%@%@",[TakeRouterSocketAdressClass getAppEMMIP],@"/api/sys/v4.0/contacts/orgs"];
    [IMPHttpSvc POST:url parameters:nil isHTTPResponseSerializer:YES success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        orgs *protobuf = [orgs parseFromData:(NSData *)responseObject error:&error];
        if (error) {
            //关闭Loading页面
            [self closeLoadingPageofLogin];
            return;
        }
        NSString *lastQueryTime = [NSString stringWithFormat:@"%lld",protobuf.lastQueryTime];
        NSString *rootId = protobuf.rootId;
        NSMutableArray *targetArr = [[NSMutableArray alloc] init];
        for (int i=0; i<protobuf.orgsArray.count; i++) {
            org *orgProto = protobuf.orgsArray[i];
            PhoneBookOrg *data = [[PhoneBookOrg alloc] init];
            data.id_p = orgProto.id_p;
            data.name = orgProto.name;
            data.nameGlobal = orgProto.nameGlobal;
            data.pinyin = orgProto.pinyin;
            data.parentId = orgProto.parentId;
            data.sortOrder = orgProto.sortOrder;
            [targetArr addObject:data];
        }
        BOOL dbSaveSuccess = [PhoneBookDAL saveOrgInfoArray:targetArr lastQueryTime:lastQueryTime rootId:rootId];
        if(dbSaveSuccess) {
            self->getPhoneBookOrgHandler(YES);
        }
        else {
            self->getPhoneBookOrgHandler(NO);
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        self->getPhoneBookOrgHandler(NO);
    }];
}
-(void)getOrgChangeorDeleteInfo:(NSString *)lastQueryTime {
    //一般更新删除组织信息
    NSDictionary *dict = @{@"lastQueryTime":lastQueryTime};
    NSString *url = [NSString stringWithFormat:@"%@%@",[TakeRouterSocketAdressClass getAppEMMIP],@"/api/sys/v3.0/contacts/orgs"];
    [IMPHttpSvc POST:url parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSDictionary *dic = responseObject;
        NSArray *arr = [dic objectForKey:@"changed"];
        NSString *queryTime = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"lastQueryTime"] integerValue]];
        NSMutableArray *changeData = [[NSMutableArray alloc] init];
        for (int i=0; i<arr.count; i++) {
            OldPhoneBookModel *tempModel = [[OldPhoneBookModel alloc] initWithDictionary:[arr objectAtIndex:i]];
            PhoneBookOrg *data = [[PhoneBookOrg alloc] init];
            data.id_p = tempModel.id;
            data.name = tempModel.name;
            data.nameGlobal = tempModel.name_global;
            data.pinyin = tempModel.pinyin;
            data.parentId = tempModel.parent_id;
            data.sortOrder = tempModel.sort_order;
            [changeData addObject:data];
        }
        NSArray *deleteData = [dic objectForKey:@"deleted"];
        NSString *rootId = [dic objectForKey:@"rootID"];
        BOOL dbSaveSuccess = [PhoneBookDAL changeOrgInfoArray:changeData deleteOrgInfoArray:deleteData  lastQueryTime:queryTime rootId:rootId];
        if(dbSaveSuccess) {
            self->getPhoneBookOrgHandler(YES);
        }
        else {
            self->getPhoneBookOrgHandler(NO);
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        self->getPhoneBookOrgHandler(NO);
    }];
}

//关闭Loading页面
-(void)closeLoadingPageofLogin {
    if (![[ContactLoadScreen sharedInstance] isHidden]) {
        [[ContactLoadScreen sharedInstance] finishContact];
    }
}

@end
