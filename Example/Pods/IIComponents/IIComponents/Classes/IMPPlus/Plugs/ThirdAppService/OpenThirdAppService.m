//
//  OpenThirdAppService.m
//
//  Created by Elliot.
//  Copyright (c) 2018年 Elliot. All rights reserved.
//

#import "OpenThirdAppService.h"
@import IIBLL;

@implementation OpenThirdAppService {
    NSDictionary *jsonDict;
    NSString *callBackJSName_Fail;
}

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    jsonDict = [params objectForKey:@"param"];
    if ([funcName isEqualToString:@"open"]) {
        id<IMPWebSolutionIBLL> plugBll = [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
        [plugBll bll_OpenThirdAppService_openThirdApp:jsonDict currentWebView:self.currentWebView];
    }
}

@end
