//
//  PhoneBookModel.m
//  impcloud
//
//  Created by Elliot on 16/2/17.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import "OldPhoneBookModel.h"

#define blankOrJSONObjectForKey(JSON_, KEY_) [JSON_ objectForKey:KEY_] == [NSNull null] ? @"" : [JSON_ valueForKeyPath:KEY_];

@implementation OldPhoneBookModel

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.id                 = blankOrJSONObjectForKey(dictionary, @"id");
    self.id_new             = blankOrJSONObjectForKey(dictionary, @"new_id");
    self.name               = blankOrJSONObjectForKey(dictionary, @"name");
    self.parent_id          = blankOrJSONObjectForKey(dictionary, @"parent_id");
    self.code               = blankOrJSONObjectForKey(dictionary, @"code");
    self.email              = blankOrJSONObjectForKey(dictionary, @"email");
    self.head               = blankOrJSONObjectForKey(dictionary, @"head");
    self.inspur_id          = blankOrJSONObjectForKey(dictionary, @"inspur_id");
    self.mobile             = blankOrJSONObjectForKey(dictionary, @"mobile");
    self.org_name           = blankOrJSONObjectForKey(dictionary, @"org_name");
    self.real_name          = blankOrJSONObjectForKey(dictionary, @"real_name");
    NSString *str_sort_order   = blankOrJSONObjectForKey(dictionary, @"sort_order");
    self.sort_order         = [str_sort_order integerValue];
    self.name_global        = blankOrJSONObjectForKey(dictionary, @"name_global");
    NSString *str_has_head  = blankOrJSONObjectForKey(dictionary, @"has_head");
    self.has_head           = [str_has_head integerValue];
    self.pinyin             = blankOrJSONObjectForKey(dictionary, @"pinyin");
    self.type               = blankOrJSONObjectForKey(dictionary, @"type");
    self.full_path          = blankOrJSONObjectForKey(dictionary, @"full_path");
    self.office             = blankOrJSONObjectForKey(dictionary, @"office");
    self.tel                = blankOrJSONObjectForKey(dictionary, @"tel");
    return self;
}

@end
