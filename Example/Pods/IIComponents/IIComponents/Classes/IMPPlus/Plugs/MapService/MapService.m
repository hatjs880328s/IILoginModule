//
//  MapService.m
//  iOS
//
//  Created by Elliot on 16-12-20.
//  Copyright (c) 2016年 Inspur Group. All rights reserved.
//

#import "MapService.h"
#import <WebKit/WebKit.h>
#import "NSObject+SBJSON.h"

@import IIBLL;

@interface MapService () <IMPWebSolutionDelegate>

@end

@implementation MapService {
    NSString *callBackJSName_Success;
    NSString *callBackJSName_Fail;
    id <IMPWebSolutionIBLL> plugBll;
}

- (id<IMPWebSolutionIBLL>)getService {
    if (plugBll == nil) {
        plugBll= [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    }
    return plugBll;
}

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    NSDictionary *jsonDict = [params objectForKey:@"param"];
    if(![jsonDict isKindOfClass:NSDictionary.class]) {
        return ;
    }
    if ([funcName isEqualToString:@"getAllMapApps"]) {
        callBackJSName_Success = [jsonDict objectForKey:@"success"];
        [self getAllMapApps];
    }
    else if ([funcName isEqualToString:@"doNaviByMapId"]) {
        callBackJSName_Fail = [jsonDict objectForKey:@"fail"];
        [self doNaviByMapId:[jsonDict objectForKey:@"mapId"] destination:[jsonDict objectForKey:@"address"]];
    }
    else if ([funcName isEqualToString:@"navigationByAutoNavi"]) {
        callBackJSName_Fail = [jsonDict objectForKey:@"fail"];
        BOOL success = [[self getService] bll_MapService_doAutoNavi:jsonDict];
        if(!success) {
            [self failedToOpenMap:YES];
        }
    }
}

- (void)getAllMapApps {
    //使用IBLL接口获取信息
    NSString *mapApps = [[self getService] bll_MapService_getAllMapApps];
    NSString *jsStr = [[[callBackJSName_Success stringByAppendingString: @"('" ] stringByAppendingString:mapApps] stringByAppendingString:@"')"];
    jsStr = [jsStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    [self jsCallBack:self.currentWebView andParams:jsStr];
    callBackJSName_Success = nil;
}

- (void)doNaviByMapId:(NSString *)mapId destination:(NSString *)destination {
    BOOL success = [[self getService] bll_MapService_doNaviByMapId:mapId destination:destination];
    if(!success) {
        [self failedToOpenMap:NO];
    }
}

- (void)failedToOpenMap:(BOOL)isNew {
    NSString *errorStr = [NSString stringWithFormat:@"%@('%@')",callBackJSName_Fail,@"未安装此地图"];
    if (isNew) {
        NSDictionary *dic = @{ @"errorMessage" : @"未安装此地图"};
        errorStr = [NSString stringWithFormat:@"%@(%@)", callBackJSName_Fail, [dic JSONFragment]];
    }
    if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:errorStr];
    }
    else {
        [(WKWebView *)self.currentWebView evaluateJavaScript:errorStr completionHandler:nil];
    }
    callBackJSName_Fail = nil;
}

@end
