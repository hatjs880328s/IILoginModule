//
//  CommonlistUserId.mm
//  impcloud_dev
//
//  Created by 许阳 on 2019/1/31.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "CommonlistUserId+WCTTableCoding.h"
#import "CommonlistUserId.h"
#import <WCDB/WCDB.h>

@implementation CommonlistUserId

WCDB_IMPLEMENTATION(CommonlistUserId)
WCDB_SYNTHESIZE(CommonlistUserId, userId)
WCDB_SYNTHESIZE(CommonlistUserId, clickTimes)

WCDB_PRIMARY(CommonlistUserId, userId)
  
@end
