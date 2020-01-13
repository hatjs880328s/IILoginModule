//
//  WechatService.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/8/9.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "WechatService.h"
#import <WebKit/WebKit.h>
@import IIBLL;

@interface WechatService () <IMPWebSolutionDelegate>

@end

@implementation WechatService {
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
    NSString *funcName = [params objectForKey:@"methodName"];
    if ([funcName isEqualToString:@"invoice"]) {
        NSString *callBack_Success = [[params objectForKey:@"param"] objectForKey:@"success"];
        NSString *callBack_Fail = [[params objectForKey:@"param"] objectForKey:@"fail"];
        [self getInvoiceWithSuccess:callBack_Success andFail:callBack_Fail];
    }
}

- (void)getInvoiceWithSuccess:(NSString *)callBack_Success andFail:(NSString *)callBack_Fail {
    [[self getService] bll_WechatService_getInvoiceWithDelegate:self callBackSuccess:callBack_Success callBackFail:callBack_Fail];
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
