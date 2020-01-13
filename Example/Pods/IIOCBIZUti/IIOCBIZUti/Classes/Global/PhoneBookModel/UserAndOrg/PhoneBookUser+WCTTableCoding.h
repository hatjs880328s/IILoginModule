//
//  PhoneBookUser+WCTTableCoding.h
//  impcloud_dev
//
//  Created by 许阳 on 2018/12/26.
//  Copyright © 2018 Elliot. All rights reserved.
//

#import "PhoneBookUser.h"
#import <WCDB/WCDB.h>

@interface PhoneBookUser (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(id_p)
WCDB_PROPERTY(realName)
WCDB_PROPERTY(nameGlobal)
WCDB_PROPERTY(pinyin)
WCDB_PROPERTY(mobile)
WCDB_PROPERTY(email)
WCDB_PROPERTY(parentId)
WCDB_PROPERTY(office)
WCDB_PROPERTY(tel)
WCDB_PROPERTY(hasHead)
WCDB_PROPERTY(sortOrder)
WCDB_PROPERTY(lastQueryTime)

@end
