//
//  EMMService.m
//  iOS
//
//  Created by Elliot on 16-12-20.
//  Copyright (c) 2016年 Inspur Group. All rights reserved.
//

#import "EMMService.h"
@import IIBLL;

@implementation EMMService {
    NSDictionary *jsonDict;
    NSString *callBackJSName;
    id<IMPWebSolutionIBLL> plugBll;
}

#pragma mark - ImpPluginDelegate
-(void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    jsonDict = [params objectForKey:@"param"];
    plugBll = [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    if ([funcName isEqualToString:@"getDeviceInfo" ]) {
        if(![jsonDict isKindOfClass:NSDictionary.class]){
            return ;
        }
        callBackJSName = [jsonDict objectForKey:@"callback"];
        [self getDeviceInfo];
    }
    else if ([funcName isEqualToString:@"webviewReload"]) {
        [self webviewReload];
    }
    else if ([funcName isEqualToString:@"returnEMMstate"]) {
        if(![jsonDict isKindOfClass:NSDictionary.class]){
            return ;
        }
        [self returnEMMstate];
    }
}

-(void)getDeviceInfo {
    NSString *jsStr = [plugBll bll_EMMService_getDeviceInfo:callBackJSName];
    [self jsCallBack:self.currentWebView andParams:jsStr];
    callBackJSName  = nil;
}

-(void)webviewReload {
    [plugBll bll_EMMService_webviewReload];
}

-(void)returnEMMstate {
    [plugBll bll_EMMService_returnEMMstate:jsonDict];
}

@end
