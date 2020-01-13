//
//  ShareSocialService.m
//
//  Created by Elliot.
//  Copyright (c) 2017年 Elliot. All rights reserved.
//

#import "ShareSocialService.h"
#import <WebKit/WebKit.h>

@import IIBLL;

@interface ShareSocialService () <IMPWebSolutionDelegate>

@end

@implementation ShareSocialService {
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
    if ([funcName isEqualToString:@"shareText"]) {
        [[self getService] bll_ShareSocialService_shareTextWithDelegate:self param:jsonDict];
    }
    else if ([funcName isEqualToString:@"shareUrl"]) {
        [[self getService] bll_ShareSocialService_shareUrlWithDelegate:self param:jsonDict];
    }
    else if ([funcName isEqualToString:@"shareImage"]) {
        [[self getService] bll_ShareSocialService_shareImageWithDelegate:self param:jsonDict];
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
