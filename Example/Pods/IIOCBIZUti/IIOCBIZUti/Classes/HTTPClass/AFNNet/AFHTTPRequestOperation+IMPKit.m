//
//  AFHTTPRequestOperation+IMPKit.m
//  impcloud
//
//  Created by 王振 on 16/6/19.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import "AFHTTPRequestOperation+IMPKit.h"
#import <objc/runtime.h>

static const char *attachedIdentifier = "attachedIdentifier";
@implementation AFHTTPRequestOperation (IMPKit)

- (NSString *)attachedIdentifier {
    return  objc_getAssociatedObject(self, attachedIdentifier);
}

- (void)setAttachedIdentifier:(NSString *)attachedId{
    objc_setAssociatedObject(self, attachedIdentifier,attachedId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
