//
//  MeConfigModel.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/1/24.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "MeConfigModel.h"

#define blankObjectForKey(JSON_, KEY_) [JSON_ objectForKey:KEY_] == [NSNull null] ? @"" : [JSON_ valueForKeyPath:KEY_];

@implementation MeConfigModel

//初始化init
-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.id = blankObjectForKey(dictionary, @"id");
    if (self.id == nil) {
        self.id = @"";
    }
    self.ico = blankObjectForKey(dictionary, @"ico");
    if (self.ico == nil) {
        self.ico = @"";
    }
    self.uri = blankObjectForKey(dictionary, @"uri");
    if (self.uri == nil) {
        self.uri = @"";
    }
    self.title = [dictionary objectForKey:@"title"];
    return self;
}

@end
