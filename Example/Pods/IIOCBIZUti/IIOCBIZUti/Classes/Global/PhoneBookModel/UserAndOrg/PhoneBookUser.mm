//
//  PhoneBookUser.mm
//  impcloud_dev
//
//  Created by 许阳 on 2018/12/26.
//  Copyright © 2018 Elliot. All rights reserved.
//

#import "PhoneBookUser+WCTTableCoding.h"
#import "PhoneBookUser.h"
#import <WCDB/WCDB.h>

#define blankOrJSONObjectForKey(JSON_, KEY_) [JSON_ objectForKey:KEY_] == [NSNull null] ? @"" : [JSON_ valueForKeyPath:KEY_];

@implementation PhoneBookUser

//初始化init
-(id) initWithDictionary:(NSDictionary *)dictionary queryTime:(NSString *)time {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.id_p = blankOrJSONObjectForKey(dictionary, @"id_p");
    self.realName = blankOrJSONObjectForKey(dictionary, @"realName");
    self.nameGlobal = blankOrJSONObjectForKey(dictionary, @"nameGlobal");
    self.pinyin = blankOrJSONObjectForKey(dictionary, @"pinyin");
    self.mobile = blankOrJSONObjectForKey(dictionary, @"mobile");
    self.email = blankOrJSONObjectForKey(dictionary, @"email");
    self.parentId = blankOrJSONObjectForKey(dictionary, @"parentId");
    self.office = blankOrJSONObjectForKey(dictionary, @"office");
    self.tel = blankOrJSONObjectForKey(dictionary, @"tel");
    self.hasHead = [[dictionary objectForKey:@"hasHead"] integerValue];
    self.sortOrder = [[dictionary objectForKey:@"sortOrder"] integerValue];
    self.lastQueryTime = time;
    return self;
}

WCDB_IMPLEMENTATION(PhoneBookUser)
WCDB_SYNTHESIZE(PhoneBookUser, id_p)
WCDB_SYNTHESIZE(PhoneBookUser, realName)
WCDB_SYNTHESIZE(PhoneBookUser, nameGlobal)
WCDB_SYNTHESIZE(PhoneBookUser, pinyin)
WCDB_SYNTHESIZE(PhoneBookUser, mobile)
WCDB_SYNTHESIZE(PhoneBookUser, email)
WCDB_SYNTHESIZE(PhoneBookUser, parentId)
WCDB_SYNTHESIZE(PhoneBookUser, office)
WCDB_SYNTHESIZE(PhoneBookUser, tel)
WCDB_SYNTHESIZE(PhoneBookUser, hasHead)
WCDB_SYNTHESIZE(PhoneBookUser, sortOrder)
WCDB_SYNTHESIZE(PhoneBookUser, lastQueryTime)

WCDB_INDEX(PhoneBookUser, "_id_p", id_p)
WCDB_INDEX(PhoneBookUser, "_realName", realName)
WCDB_INDEX(PhoneBookUser, "_nameGlobal", nameGlobal)
WCDB_INDEX(PhoneBookUser, "_pinyin", pinyin)
WCDB_INDEX(PhoneBookUser, "_mobile", mobile)
WCDB_INDEX(PhoneBookUser, "_email", email)
WCDB_INDEX(PhoneBookUser, "_tel", tel)

WCDB_PRIMARY(PhoneBookUser, id_p)

@end
