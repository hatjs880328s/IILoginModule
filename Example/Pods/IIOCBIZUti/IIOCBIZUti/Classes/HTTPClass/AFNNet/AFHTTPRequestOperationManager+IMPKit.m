//
//  AFHTTPRequestOperationManager+IMPKit.m
//  impcloud
//
//  Created by larry on 6/17/16.
//  Copyright © 2016 Elliot. All rights reserved.
//

#import "AFHTTPRequestOperationManager+IMPKit.h"
#import <objc/runtime.h>

static const char *retryCount = "retryCount";
static const char *attachedIdentifier = "attachedIdentifier";
@implementation AFHTTPRequestOperationManager (IMPKit)

- (int)retryCount {
    NSNumber *count = objc_getAssociatedObject(self, retryCount);
    return [count intValue];
}

- (void)setRetryCount:(int)count{
    objc_setAssociatedObject(self, retryCount,@(count), OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)attachedIdentifier {
    return  objc_getAssociatedObject(self, attachedIdentifier);
}

- (void)setAttachedIdentifier:(NSString *)attachedId{
    objc_setAssociatedObject(self, attachedIdentifier,attachedId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



@end
