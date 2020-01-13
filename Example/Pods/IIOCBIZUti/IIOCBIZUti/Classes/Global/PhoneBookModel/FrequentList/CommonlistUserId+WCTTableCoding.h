//
//  CommonlistUserId+WCTTableCoding.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/1/31.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "CommonlistUserId.h"
#import <WCDB/WCDB.h>

@interface CommonlistUserId (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(userId)
WCDB_PROPERTY(clickTimes)

@end
