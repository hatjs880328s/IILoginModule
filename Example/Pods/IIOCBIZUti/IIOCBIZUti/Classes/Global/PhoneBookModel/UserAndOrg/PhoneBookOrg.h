//
//  PhoneBookOrg.h
//  impcloud_dev
//
//  Created by 许阳 on 2018/12/26.
//  Copyright © 2018 Elliot. All rights reserved.
//  组织信息

#import <Foundation/Foundation.h>

@interface PhoneBookOrg : NSObject

//初始化init
-(id) initWithDictionary:(NSDictionary *)dictionary;

//组织id
@property(nonatomic, retain) NSString *id_p;
//组织名称
@property(nonatomic, retain) NSString *name;
//组织国际化名称
@property(nonatomic, retain) NSString *nameGlobal;
//组织拼音
@property(nonatomic, retain) NSString *pinyin;
//组织parentId
@property(nonatomic, retain) NSString *parentId;
//组织排序
@property(nonatomic, assign) NSInteger sortOrder;

@end
