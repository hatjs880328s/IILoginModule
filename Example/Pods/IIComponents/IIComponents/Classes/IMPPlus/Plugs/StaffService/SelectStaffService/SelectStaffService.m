//
//  SelectStaffService.m
//
//  Created by Elliot.
//  Copyright (c) 2018年 Elliot. All rights reserved.
//

#import "SelectStaffService.h"
#import <WebKit/WebKit.h>

@import IIBLL;

@interface SelectStaffService ()<IMPWebSolutionDelegate>

@end

@implementation SelectStaffService {
    NSDictionary *jsonDict;
    NSString *callBackJSName_Success;
    id<IMPWebSolutionIBLL> plugBll;
}

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    jsonDict = [params objectForKey:@"param"];
    if(![jsonDict isKindOfClass:NSDictionary.class]){
        return ;
    }
    BOOL isMultiSelect = [[[jsonDict objectForKey:@"options"] objectForKey:@"multiSelection"] boolValue];
    callBackJSName_Success = [jsonDict objectForKey:@"success"];
    if ([funcName isEqualToString:@"select"]) {
        [self selectStaff:isMultiSelect];
    }
}

- (void)selectStaff:(BOOL)isMultiSelect {
    plugBll = [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    [plugBll bll_StaffService_selectStaff:isMultiSelect currentWindow:[self getWindowOfWebView:self.currentWebView] delegate:self];
}

#pragma mark IMPWebSolutionDelegate
- (void)jsonCallBackString:(NSString *)jsonStr {
    if (jsonStr != nil) {
        NSString *jsStr = [[[callBackJSName_Success stringByAppendingString: @"(" ] stringByAppendingString:jsonStr] stringByAppendingString:@")"];
        if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
            [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:jsStr];
        }
        else {
            [(WKWebView *)self.currentWebView evaluateJavaScript:jsStr completionHandler:nil];
        }
    }
    callBackJSName_Success  = nil;
}

@end
