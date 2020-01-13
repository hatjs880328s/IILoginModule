//
//  SqlService.m
//  impcloud_dev
//
//  Created by 衣凡 on 2019/8/9.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "SqlService.h"
#import <WebKit/WebKit.h>
#import "NSObject+SBJSON.h"
@import IIBLL;

@implementation SqlService{
    id<IMPWebSolutionIBLL> plugBll;
    NSDictionary *jsonDic;
}

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {

    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    jsonDic = [params objectForKey:@"param"];
    plugBll = [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];

    if ([funcName isEqualToString:@"executeSql"]) {
        [self executeSql];
    }
}

- (void)executeSql {
    NSString *success = [jsonDic objectForKey:@"success"];
    NSString *fail = [jsonDic objectForKey:@"fail"];

    NSDictionary *options = [jsonDic objectForKey:@"options"];

    NSString *dbName = [options objectForKey:@"dbName"];
    NSString *sql = [options objectForKey:@"sql"];

    BOOL ifSuccess = NO;
    NSDictionary *resultDic = [plugBll bll_SqlService_executeSql:dbName sql:sql success:&ifSuccess];

    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)", ifSuccess ? success : fail, [resultDic JSONFragment]];

    if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    else {
        [(WKWebView *)self.currentWebView evaluateJavaScript:jsStr completionHandler:nil];
    }
}
@end
