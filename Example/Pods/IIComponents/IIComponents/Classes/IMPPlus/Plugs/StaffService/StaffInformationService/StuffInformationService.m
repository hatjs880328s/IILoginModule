//
//  StuffInformationService.m
//
//  Created by Elliot.
//  Copyright (c) 2018年 Elliot. All rights reserved.
//

#import "StuffInformationService.h"
@import IIBLL;
#import <WebKit/WebKit.h>

@interface StuffInformationService ()<IMPWebSolutionDelegate>

@end

@implementation StuffInformationService {
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
    if ([funcName isEqualToString:@"view"]) {
        [self viewStaff];
    }
    else if ([funcName isEqualToString:@"userInfo"]) {
        [self userInfo];
    }
}

- (void)viewStaff {
    NSString *staffID = [[jsonDict objectForKey:@"options"] objectForKey:@"inspurId"];

    [[[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)] bll_StaffService_viewStaff:staffID currentWindow:[self getWindowOfWebView:self.currentWebView]];
}

- (void)userInfo {
    callBackJSName_Success = [jsonDict objectForKey:@"success"];

    [[[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)] bll_StaffService_userInfoWithDelegate:self];
}

#pragma mark - IMPWebSolutionDelegate
- (void)jsonCallBackString:(NSString *)jsonStr {
    NSString *jsStr = [[[callBackJSName_Success stringByAppendingString: @"(" ] stringByAppendingString:jsonStr] stringByAppendingString:@")"];
    if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    else {
        [(WKWebView *)self.currentWebView evaluateJavaScript:jsStr completionHandler:nil];
    }
    callBackJSName_Success = nil;
}

@end
