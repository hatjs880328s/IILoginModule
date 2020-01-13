//
//  IMPEnterpriseModel.m
//  impcloud
//
//  Created by larry on 6/12/16.
//  Copyright © 2016 Elliot. All rights reserved.
//

#import "IMPEnterpriseModel.h"

@implementation IMPEnterpriseModel

+(NSDictionary *) mj_replacedKeyFromPropertyName {
    return @{
             @"id" : @"id",
             @"code" : @"code",
             @"name" : @"name",
             @"createdAt" : @"creation_date",
             @"licenseCopy" : @"license_copy",
             @"licenseSN" : @"license_sn",
             @"clusters" : @"clusters"
             };
}
@end
