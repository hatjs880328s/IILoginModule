//
//  IILoginModuleAction.m
//  impcloud_dev
//
//  Created by xin on 2020/1/10.
//  Copyright © 2020 Elliot. All rights reserved.
//

#import "IILoginModuleAction.h"
#import "BeeHive.h"
#import "IILoginServiceModule.h"
#import "IILoginServiceProtocol.h"

@implementation IILoginModuleAction

//获取IILoginModuleAction单例对象
static IILoginModuleAction *actionObject;
+ (IILoginModuleAction *)sharedObject{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actionObject = [[self alloc] init];
        //服务自注册
        [[BeeHive shareInstance] registerService:@protocol(IILoginServiceProtocol) service:IILoginServiceModule.class];
    });
    return actionObject;
}

@end
