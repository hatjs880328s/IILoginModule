//
//  PhotoService.m
//  iPhone_hybrid
//
//  Created by Elliot on 17-2-16.
//  Copyright (c) 2017年 Elliot. All rights reserved.
//

#import "PhotoService.h"
#import "IMPWebSolutionIBLL.h"
#import <WebKit/WebKit.h>

@interface PhotoService()<IMPWebSolutionDelegate> {

    id<IMPWebSolutionIBLL> plugBll;
}

@end

@implementation PhotoService
@synthesize jsonDict;

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {

    self.currentWebView = webView;
    self.jsonDict = params;
    NSString* methodName = [jsonDict objectForKey:@"methodName"];
    NSDictionary* args = [params objectForKey:@"param"];
    NSDictionary* options = [args objectForKey:@"options"];
    //初始化配置
    [[self getService] bll_PhotoService_initData:self.jsonDict params:args options:options currentWebView:self.currentWebView currentWindow:[self getWindowOfWebView:self.currentWebView] jsCallBackDelegate:self];

    if ([methodName isEqualToString:@"takePhotoAndUpload"]) {
        [[self getService] bll_PhotoService_takePhotoAndUpload];
    }
    else if ([methodName isEqualToString:@"selectAndUpload"]) {
        [[self getService] bll_PhotoService_getPicture];
    }else if([methodName isEqualToString:@"viewImage"]) {
        //预览图片
        [[self getService] bll_PhotoService_viewImage:[self getWindowOfWebView:self.currentWebView]];
        
    }
}

- (id<IMPWebSolutionIBLL>)getService {
    if (plugBll == nil){
        plugBll= [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    }
    return plugBll;
}

- (void)customCameraViewFor:(UIView *)camera {
}

- (void)jsCallBack:(UIView *)webView andParams:(NSString*)params {
    if ([webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)webView stringByEvaluatingJavaScriptFromString:params];
    }
    else {
        [(WKWebView *)webView evaluateJavaScript:params completionHandler:nil];
    }
}

@end


