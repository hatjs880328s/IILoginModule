//
//  VideoService.m
//  impcloud_dev
//
//  Created by 许阳.
//  Copyright (c) 2019. All rights reserved.
//

#import "VideoService.h"
#import <WebKit/WebKit.h>
@import IIBLL;

@interface VideoService () <IMPWebSolutionDelegate>

@end

@implementation VideoService {
    id <IMPWebSolutionIBLL> plugBll;
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
    NSDictionary *dic_Param = [params objectForKey:@"param"];
    NSString *funcName = [params objectForKey:@"methodName"];
    if ([funcName isEqualToString:@"recordVideo"]) {
        NSString *successCallBack = [dic_Param objectForKey:@"success"];
        [self recordVideo:[dic_Param objectForKey:@"options"] callBackName:successCallBack withVC:[self getWindowOfWebView:self.currentWebView]];
    }
    if ([funcName isEqualToString:@"playVideo"]) {
        [self playVideo:[dic_Param objectForKey:@"options"] withVC:[self getWindowOfWebView:self.currentWebView]];
    }
}

- (void)recordVideo:(NSDictionary *)dic callBackName:(NSString *)name withVC:(UIViewController *)vc {
    [[self getService] bll_VideoService_recordVideoWithDelegate:self param:dic callBackName:name withVC:vc];
}

- (void)playVideo:(NSDictionary *)dic withVC:(UIViewController *)vc {
    [[self getService] bll_VideoService_playVideoWithDelegate:self param:dic withVC:vc];
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
}

@end
