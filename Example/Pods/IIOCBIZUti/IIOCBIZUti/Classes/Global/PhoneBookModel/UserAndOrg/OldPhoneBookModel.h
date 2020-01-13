//
//  PhoneBookModel.h
//  impcloud
//
//  Created by Elliot on 16/2/17.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldPhoneBookModel : NSObject

-(id) initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic,strong) NSString    *id;
@property(nonatomic,strong) NSString    *id_new;
@property(nonatomic,strong) NSString    *name;
@property(nonatomic,strong) NSString    *parent_id;
@property(nonatomic,strong) NSString    *code;
@property(nonatomic,strong) NSString    *email;
@property(nonatomic,strong) NSString    *head;
@property(nonatomic,strong) NSString    *name_global;
@property(nonatomic,strong) NSString    *inspur_id;
@property(nonatomic,strong) NSString    *mobile;
@property(nonatomic,strong) NSString    *org_name;
@property(nonatomic,strong) NSString    *real_name;
@property(nonatomic,strong) NSString    *pinyin;
@property(nonatomic,strong) NSString    *type;
@property(nonatomic,strong) NSString    *full_path;
@property(nonatomic,strong) NSString    *office;
@property(nonatomic,strong) NSString    *tel;
@property(nonatomic,assign) NSInteger   has_head;
@property(nonatomic,assign) NSInteger   sort_order;
@property(nonatomic,assign) double      update_time;

@end
