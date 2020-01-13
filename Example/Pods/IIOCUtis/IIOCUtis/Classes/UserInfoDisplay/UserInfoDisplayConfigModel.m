//
//  UserInfoDisplayConfigModel.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/1/22.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "UserInfoDisplayConfigModel.h"
#import "Constants.h"

@implementation ShowUserDisplayModel

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.value = blankOrJSONObjectForKey(dictionary, @"value");
    self.show = [[dictionary objectForKey:@"show"] boolValue];
    return self;
}

@end

@implementation UserInfoDisplayConfigModel

@end
