//
//  GpsService.m
//
//  Created by Elliot.
//  Copyright (c) 2017年 Elliot. All rights reserved.
//

#import "GpsService.h"
#import <WebKit/WebKit.h>
#import "NSObject+SBJSON.h"

@import IIBLL;

@interface GpsService () <IMPWebSolutionDelegate>

@end

@implementation GpsService {
    NSString *successCallBack;
    NSString *failCallBack;
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
    if ([funcName isEqualToString:@"getInfo"]) {
        if(![jsonDict isKindOfClass:NSDictionary.class]){
            return ;
        }
        successCallBack = [jsonDict objectForKey:@"callback"];
        NSString *type = [jsonDict objectForKey:@"type"];
        if ([type isEqualToString:@"gd"]) {
            [self getInfo_GD];
        }
        else {
            [self getInfo];
        }
    }
    else if ([funcName isEqualToString:@"getAddress"]) {
        successCallBack = [jsonDict objectForKey:@"success"];
        failCallBack = [jsonDict objectForKey:@"fail"];
        [[self getService] bll_GpsService_getAddressWithDelegate:self param:jsonDict];
    }
    else if ([funcName isEqualToString:@"open"]) {
        [self open];
    }
    else if ([funcName isEqualToString:@"close"]) {
        [self close];
    }
}

- (void)open {
    [[self getService] bll_GpsService_openGps];
}

- (void)close {
    [[self getService] bll_GpsService_closeGps];
}

- (void)getInfo {
    [[self getService] bll_GpsService_getInfoWithDelegate:self];
}

- (void)getInfo_GD {
    [[self getService] bll_GpsService_getGDInfoWithDelegate:self];
}

#pragma mark - IMPWebSolutionDelegate
- (void)returnToWeb:(nullable NSDictionary *)dic {
    if (dic) {
        NSString *locationStr = [dic JSONFragment];
        if (locationStr != nil) {
            [self getTargetData:locationStr andCallBack:successCallBack isDataChange:NO];
        }
    }
    else {
        [self getTargetData:@"数据或网络异常" andCallBack:successCallBack isDataChange:NO];
    }
}

- (void)jsonCallBackString:(NSString *)jsonStr {
    if (jsonStr != nil) {
        [self getTargetData:jsonStr andCallBack:successCallBack isDataChange:YES];
    }
    else {
        //新版报错
        NSDictionary *dic = @{ @"errorMessage" : @"数据或网络异常"};
        [self getTargetData:[dic JSONFragment] andCallBack:failCallBack isDataChange:YES];
    }
}

- (void)getTargetData:(NSString *)jsonStr andCallBack:(NSString *)callBack isDataChange:(BOOL)isDataChange {
    NSString *jsStr = @"";
    if (isDataChange) {
        jsStr = [[[callBack stringByAppendingString: @"(" ] stringByAppendingString:jsonStr] stringByAppendingString:@")"];
    }
    else {
        jsStr = [[[callBack stringByAppendingString: @"('" ] stringByAppendingString:jsonStr] stringByAppendingString:@"')"];
    }
    jsStr = [jsStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    else {
        [(WKWebView *)self.currentWebView evaluateJavaScript:jsStr completionHandler:nil];
    }
    [self resetCallBack];
}

- (void)resetCallBack {
    if (successCallBack) {
        successCallBack = nil;
    }
    if (failCallBack) {
        failCallBack = nil;
    }
}

- (void)dealloc {
    //停止定位服务
    [[self getService] bll_GpsService_closeGps];
}

@end
