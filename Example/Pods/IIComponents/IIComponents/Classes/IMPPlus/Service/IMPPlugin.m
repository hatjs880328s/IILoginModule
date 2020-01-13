//
//  IMPPlugin.m
//  Elliot All rights reserved.
//

#import "IMPPlugin.h"
#import <WebKit/WebKit.h>

@implementation IMPPlugin

- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
}

- (void)jsCallBack:(UIView *)webView andParams:(NSString *)params {
    if ([webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)webView stringByEvaluatingJavaScriptFromString:params];
    }
    else {
        [(WKWebView *)webView evaluateJavaScript:params completionHandler:nil];
    }
}

// 获取webView所属的IMPWindow
- (UIViewController *)getWindowOfWebView:(UIView *)webView {
    for (UIView* next = [webView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
