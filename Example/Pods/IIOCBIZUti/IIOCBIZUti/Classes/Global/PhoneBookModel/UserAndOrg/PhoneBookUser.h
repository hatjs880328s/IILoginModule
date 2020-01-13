//
//  PhoneBookUser.h
//  impcloud_dev
//
//  Created by 许阳 on 2018/12/26.
//  Copyright © 2018 Elliot. All rights reserved.
//  用户信息

#import <Foundation/Foundation.h>

@interface PhoneBookUser : NSObject

//初始化init
-(id) initWithDictionary:(NSDictionary *)dictionary queryTime:(NSString *)time;

//id
@property(nonatomic, retain) NSString *id_p;
//名称
@property(nonatomic, retain) NSString *realName;
//国际化名称
@property(nonatomic, retain) NSString *nameGlobal;
//名称拼音
@property(nonatomic, retain) NSString *pinyin;
//手机号
@property(nonatomic, retain) NSString *mobile;
//邮箱
@property(nonatomic, retain) NSString *email;
//parentId
@property(nonatomic, retain) NSString *parentId;
//职位
@property(nonatomic, retain) NSString *office;
//办公电话
@property(nonatomic, retain) NSString *tel;
//是否设置了头像
@property(nonatomic, assign) NSInteger hasHead;
//排序
@property(nonatomic, assign) NSInteger sortOrder;
//上次查询时间
@property(nonatomic, retain) NSString *lastQueryTime;

@end
