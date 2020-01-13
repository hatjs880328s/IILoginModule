//
//  NetworkService.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/8/9.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "NetworkService.h"
#import <WebKit/WebKit.h>
@import IIBLL;

@interface NetworkService () <IMPWebSolutionDelegate>

@end

@implementation NetworkService {
    id <IMPWebSolutionIBLL> plugBll;
    NSString *callBackJSName;
}

- (id <IMPWebSolutionIBLL> )getService {
    if (plugBll == nil) {
        plugBll = [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    }
    return plugBll;
}

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    if ([funcName isEqualToString:@"getNetWorkType"]) {
        callBackJSName = [[params objectForKey:@"param"] objectForKey:@"success"];
        [self getNetWorkType];
    }
}

- (void)getNetWorkType {
    [[self getService] bll_NetworkService_getNetWorkTypeWithDelegate:self callBackName:callBackJSName];
}

#pragma mark - IMPWebSolutionDelegate
- (void)jsonCallBackString:(NSString *)jsonStr {
    if (jsonStr != nil) {
        if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
            [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:jsonStr];
        }
        else {
            [(WKWebView *)self.currentWebView evaluateJavaScript:jsonStr completionHandler:nil];
        }
    }
    callBackJSName  = nil;
}

@end
