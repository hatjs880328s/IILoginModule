//
//  HttpService.m
//
//  Created by Elliot.
//  Copyright (c) 2017年 Elliot. All rights reserved.
//

#import "HttpService.h"
#import <WebKit/WebKit.h>

@import IIBLL;

@interface HttpService () <IMPWebSolutionDelegate>

@end

@implementation HttpService {
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
    if ([funcName isEqualToString:@"get"]) {
        [[self getService] bll_HttpService_getWithDelegate:self param:jsonDict];
    }
}

#pragma mark - IMPWebSolutionDelegate
- (void)jsonCallBackString:(NSString *)jsonStr {
    if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:jsonStr];
    }
    else {
        [(WKWebView *)self.currentWebView evaluateJavaScript:jsonStr completionHandler:nil];
    }
}

@end
