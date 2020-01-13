//
//  PhoneBookOrg+WCTTableCoding.h
//  impcloud_dev
//
//  Created by 许阳 on 2018/12/26.
//  Copyright © 2018 Elliot. All rights reserved.
//

#import "PhoneBookOrg.h"
#import <WCDB/WCDB.h>

@interface PhoneBookOrg (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(id_p)
WCDB_PROPERTY(name)
WCDB_PROPERTY(nameGlobal)
WCDB_PROPERTY(pinyin)
WCDB_PROPERTY(parentId)
WCDB_PROPERTY(sortOrder)

@end
