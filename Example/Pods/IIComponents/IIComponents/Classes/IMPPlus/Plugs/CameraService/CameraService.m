//
//  NewCameraService.m
//  iPhone_hybrid
//
//  Created by SunQi on 14-3-3.
//  Copyright (c) 2014年 浪潮移动应用平台(IMP)产品组. All rights reserved.
//

#import "CameraService.h"
#import <WebKit/WebKit.h>
@import IIBLL;

//#define kReturnTypeData 0
//#define kReturnTypeFileUrl 1
//#define kReturnTypeAlbumUri 2
//
//#define kImageTypeJpg 0
//#define kImageTypePng 1
//
//#define kMediaTypeImage @"public.image"
//#define kMediaTypeMovie @"public.movie"

@interface CameraService() <IMPWebSolutionDelegate>

@end

@implementation CameraService {

    id<IMPWebSolutionIBLL> plugBll;

}
@synthesize jsonDict;

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    self.jsonDict = [params objectForKey:@"param"];
    NSString* methodName = [params objectForKey:@"methodName"];
    if ([methodName isEqualToString:@"open"]) {
        [self displayCamera];
    }
    else if ([methodName isEqualToString:@"getPicture"]) {
        [self getPicture:params];
    }
}


- (void)displayCamera {
    id<IMPWebSolutionIBLL> bll = [self getService];
    [bll bll_CameraService_displayCamera:jsonDict currentView:self.currentWebView currentVC:[self getWindowOfWebView:self.currentWebView]];
}

- (void)getPicture:(NSDictionary*)params {
    id<IMPWebSolutionIBLL> bll = [self getService];
    [bll bll_CameraService_getPicture:jsonDict params:params currentView:self.currentWebView currentWindow:[self getWindowOfWebView:self.currentWebView] jsCallBackDelegate:self];
}

- (void)jsCallBack:(UIView *)webView andParams:(NSString*)params {
    if ([webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)webView stringByEvaluatingJavaScriptFromString:params];
    }
    else {
        [(WKWebView *)webView evaluateJavaScript:params completionHandler:nil];
    }
    id<IMPWebSolutionIBLL> bll = [self getService];
    [bll bll_CameraService_resetSuccessFunctionName];
}


- (id<IMPWebSolutionIBLL>)getService {
    if (plugBll == nil){
        plugBll= [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    }
    return plugBll;
}
@end


