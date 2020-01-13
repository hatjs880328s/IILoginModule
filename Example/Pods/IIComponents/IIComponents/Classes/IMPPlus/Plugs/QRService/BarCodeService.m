//
//  BarCodeService.m
//  iPhone_hybrid
//
//  Created by 浪潮移动应用平台(IMP)产品组 on 14-3-10.
//  Copyright (c) 2014年 浪潮移动应用平台(IMP)产品组. All rights reserved.
//

#import "BarCodeService.h"
#import "QRShowViewController.h"
#import "QRScanResultDelegate.h"
#import <WebKit/WebKit.h>
@import IIBLL;

@interface BarCodeService ()<QRScanResultDelegate>{
    NSString *callBackName;
}

@end

@implementation BarCodeService

- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    if ([funcName isEqualToString:@"scan"]) {
        NSDictionary *jsonDic = [params objectForKey:@"param"];
        if([jsonDic isKindOfClass:NSDictionary.class] && [jsonDic objectForKey:@"callback"]){
            callBackName = [jsonDic objectForKey:@"callback"];
            [self scan];
        }
    }
    else if ([funcName isEqualToString:@"generate"]) {
        NSDictionary *jsonDic = [params objectForKey:@"param"];
        if([jsonDic isKindOfClass:NSDictionary.class] && [jsonDic objectForKey:@"callback"]){
            callBackName = [jsonDic objectForKey:@"callback"];
        }else {
            return ;
        }
        NSString *str = (NSString *)[jsonDic objectForKey:@"value"];
        if (str.length == 0) {
            if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
                [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:@"false"];
            }
            else {
                [(WKWebView *)self.currentWebView evaluateJavaScript:@"false" completionHandler:nil];
            }
        }
        else {
            [self generate:str];
            if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
                [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:@"true"];
            }
            else {
                [(WKWebView *)self.currentWebView evaluateJavaScript:@"true" completionHandler:nil];
            }
        }
    }
    else if ([funcName isEqualToString:@"closeQrCode"]) {
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"close_QrCode" object:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)scan {
    id<QRScanIBLL> service = [[BeeHive shareInstance] createService:@protocol(QRScanIBLL)];
    UIViewController *scanVC = [service getQRScanViewControllerWithDelegate:self isFrom3DTouch:NO];
    [[self viewController] presentViewController:scanVC animated:YES completion:^{
    }];
}

-(void)generate:(NSString *)str {
    QRShowViewController *rt = [[QRShowViewController alloc] init];
    rt.pTran_str = str;
    [[self viewController] presentViewController:rt animated:YES completion:^{
    }];
}

// 获取view对应的viewcontroller
- (UIViewController*)viewController {
    for (UIView* next = [self.currentWebView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

-(void)sendScanValue:(NSString *)value {
    //回调
    if(callBackName == nil){
        return ;
    }
    NSString *callBackParams  = [[NSString stringWithFormat:@"%@('%@')",callBackName,value]  stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:callBackParams];
    }
    else {
        [(WKWebView *)self.currentWebView evaluateJavaScript:callBackParams completionHandler:nil];
    }
}

@end
