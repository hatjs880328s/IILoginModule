//
//  TelephoneService.m
//  iPhone_hybrid
//
//  Created by 浪潮移动应用平台(IMP)产品组 on 14-2-24.
//  Copyright (c) 2014年 浪潮移动应用平台(IMP)产品组. All rights reserved.
//

#import "TelephoneService.h"
@import IIBLL;

@interface TelephoneService () {
    NSString *funcName;
    NSDictionary *jsonDict;

    id<IMPWebSolutionIBLL> plugBll;
}

@end

@implementation TelephoneService

//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
//}

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    funcName = [params objectForKey:@"methodName"];
    jsonDict = [params objectForKey:@"param"];
    if(![jsonDict isKindOfClass:NSDictionary.class]){
        return ;
    }
    if ([@"dial" isEqualToString:funcName]) {
        [[self getService] bll_TelephoneService_dial:jsonDict];
    }
    else if ([@"call" isEqualToString:funcName]) {
        [[self getService] bll_TelephoneService_call:jsonDict];
    }
}

- (id<IMPWebSolutionIBLL>)getService {
    if (plugBll == nil){
        plugBll= [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    }
    return plugBll;
}

- (void)dealloc {
    funcName = nil;
    jsonDict = nil;
}


@end
