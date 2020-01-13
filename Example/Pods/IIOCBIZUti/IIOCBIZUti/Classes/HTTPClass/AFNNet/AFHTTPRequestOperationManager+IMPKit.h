//
//  AFHTTPRequestOperationManager+IMPKit.h
//  impcloud
//
//  Created by larry on 6/17/16.
//  Copyright © 2016 Elliot. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPRequestOperationManager (IMPKit)
@property (nonatomic, assign) int retryCount;

@end
