//
//  WindowService.m
//  Elliot All rights reserved.
//

#import "WindowService.h"
@import IIBLL;

@implementation WindowService
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    // 保存当前所操作webview
    self.currentWebView = webView;
    NSString* methodName = [params objectForKey:@"methodName"];
    NSDictionary* param = [params objectForKey:@"param"];
    SEL method = NSSelectorFromString([NSString stringWithFormat:@"%@:", methodName]);
    if ([self respondsToSelector:method]) {
        [self performSelector:method withObject:param afterDelay:0.0];
    }
}

// 打开新窗口
- (void)open:(NSDictionary *)params {
    [[[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)] bll_WindowService_openWindow:params currentWebView:self.currentWebView viewController:[self viewController]];
}

// 关闭窗口
- (void)close:(NSDictionary *)params {
    [[self viewController].navigationController popViewControllerAnimated:YES];
}

//定义导航栏
- (void)setTitles:(NSDictionary *)params {
    id<IMPWebSolutionIBLL> plugBll = [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    [plugBll bll_WindowService_setTitles:params windowOfWebView:[self getWindowOfWebView:self.currentWebView]];
}

//定义导航栏右边按钮
- (void)setMenus:(NSDictionary *)params {
    id<IMPWebSolutionIBLL> plugBll = [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    [plugBll bll_WindowService_setMenus:params windowOfWebView:[self getWindowOfWebView:self.currentWebView]];
}

- (UIViewController *)viewController {
    for (UIView* next = [self.currentWebView superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
