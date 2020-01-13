//
//  DeviceService.m
//
//  Created by Elliot.
//  Copyright (c) 2018年 Elliot. All rights reserved.
//

#import "DeviceService.h"
@import IIBLL;
#import <WebKit/WebKit.h>

@implementation DeviceService {
    NSDictionary *jsonDict;
    NSString *callBackJSName_Success;
}

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    jsonDict = [params objectForKey:@"param"];
    if(![jsonDict isKindOfClass:NSDictionary.class]){
        return ;
    }
    if ([funcName isEqualToString:@"getInfo"]) {
        [self getDeviceInfo];
    }
}

- (void)getDeviceInfo {
    callBackJSName_Success = [jsonDict objectForKey:@"success"];

    NSString *deviceInfoStr = [[[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)] bll_DeviceService_getDeviceInfo];

    if (deviceInfoStr != nil) {
        NSString *jsStr = [[[callBackJSName_Success stringByAppendingString: @"(" ] stringByAppendingString:deviceInfoStr] stringByAppendingString:@")"];
        if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
            [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:jsStr];
        }
        else {
            [(WKWebView *)self.currentWebView evaluateJavaScript:jsStr completionHandler:nil];
        }
    }
    callBackJSName_Success = nil;
}

@end
