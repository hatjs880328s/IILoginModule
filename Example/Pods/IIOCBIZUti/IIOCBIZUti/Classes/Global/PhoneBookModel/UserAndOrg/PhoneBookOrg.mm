//
//  PhoneBookOrg.mm
//  impcloud_dev
//
//  Created by 许阳 on 2018/12/26.
//  Copyright © 2018 Elliot. All rights reserved.
//

#import "PhoneBookOrg+WCTTableCoding.h"
#import "PhoneBookOrg.h"
#import <WCDB/WCDB.h>

#define blankOrJSONObjectForKey(JSON_, KEY_) [JSON_ objectForKey:KEY_] == [NSNull null] ? @"" : [JSON_ valueForKeyPath:KEY_];

@implementation PhoneBookOrg

//初始化init
-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.id_p = blankOrJSONObjectForKey(dictionary, @"id_p");
    self.name = blankOrJSONObjectForKey(dictionary, @"name");
    self.nameGlobal = blankOrJSONObjectForKey(dictionary, @"nameGlobal");
    self.pinyin = blankOrJSONObjectForKey(dictionary, @"pinyin");
    self.parentId = blankOrJSONObjectForKey(dictionary, @"parentId");
    self.sortOrder = [[dictionary objectForKey:@"sortOrder"] integerValue];
    return self;
}

WCDB_IMPLEMENTATION(PhoneBookOrg)
WCDB_SYNTHESIZE(PhoneBookOrg, id_p)
WCDB_SYNTHESIZE(PhoneBookOrg, name)
WCDB_SYNTHESIZE(PhoneBookOrg, nameGlobal)
WCDB_SYNTHESIZE(PhoneBookOrg, pinyin)
WCDB_SYNTHESIZE(PhoneBookOrg, parentId)
WCDB_SYNTHESIZE(PhoneBookOrg, sortOrder)

WCDB_PRIMARY(PhoneBookOrg, id_p)
  
@end
