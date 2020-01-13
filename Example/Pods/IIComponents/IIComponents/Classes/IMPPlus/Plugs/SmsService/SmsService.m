//
//  SmsService.m
//  impcloud_dev
//
//  Created by 许阳.
//  Copyright (c) 2019. All rights reserved.
//
//  短信插件暂不支持国际化

#import "SmsService.h"
#import <MessageUI/MessageUI.h>
#import <WebKit/WebKit.h>

@interface SmsService () <MFMessageComposeViewControllerDelegate>

@end

@implementation SmsService {
    NSString *successCallBack;
    NSString *failCallBack;
}

#pragma mark - ImpPluginDelegate
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    NSDictionary *dic = [params objectForKey:@"param"];
    successCallBack = [dic objectForKey:@"successCb"];
    failCallBack = [dic objectForKey:@"errorCb"];
    if ([funcName isEqualToString:@"open"]) {
        [self send:dic];
    }
    else if ([funcName isEqualToString:@"send"]) {
        [self send:dic];
    }
    else if ([funcName isEqualToString:@"batchSend"]) {
        [self batchSend:dic];
    }
}

- (void)send:(NSDictionary *)dic {
    NSArray *telArray = [NSArray arrayWithObject:[dic objectForKey:@"tel"]];
    NSString *msg = [dic objectForKey:@"msg"];
    [self takeMessageViewControllerWithRecipients:telArray body:msg returnCallBackString:@"当前设备没有短信功能" isSuccess:NO];
}

- (void)batchSend:(NSDictionary *)dic {
    NSArray *telArray = [dic objectForKey:@"telArray"];
    NSString *msg = [dic objectForKey:@"msg"];
    [self takeMessageViewControllerWithRecipients:telArray body:msg returnCallBackString:@"当前设备不支持直接发送短信功能" isSuccess:NO];
}

- (void)takeMessageViewControllerWithRecipients:(NSArray *)recipients body:(NSString *)body returnCallBackString:(NSString *)str isSuccess:(BOOL)isSuccess {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
        vc.recipients = recipients;
        vc.body = body;
        vc.messageComposeDelegate = self;
        [[self getWindowOfWebView:self.currentWebView] presentViewController:vc animated:YES completion:nil];
    }
    else {
        [self returnCallBackString:str isSuccess:isSuccess];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultCancelled:
            [self returnCallBackString:@"短信发送取消" isSuccess:NO];
            break;
        case MessageComposeResultFailed:
            [self returnCallBackString:@"短信发送失败" isSuccess:NO];
            break;
        case MessageComposeResultSent:
            [self returnCallBackString:@"短信发送成功" isSuccess:YES];
            break;
        default:
            break;
    }
}

- (void)returnCallBackString:(NSString *)str isSuccess:(BOOL)isSuccess {
    NSString *callBack = failCallBack;
    if (isSuccess) {
        callBack = successCallBack;
    }
    if (!callBack) {
        return;
    }
    NSString *targetString = [NSString stringWithFormat:@"%@('%@')",callBack,str];
    if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:targetString];
    }
    else {
        [(WKWebView *)self.currentWebView evaluateJavaScript:targetString completionHandler:nil];
    }
    if (successCallBack) {
        successCallBack = nil;
    }
    if (failCallBack) {
        failCallBack = nil;
    }
}

@end
