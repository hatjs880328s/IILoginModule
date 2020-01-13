//
//  IMPPlugin.h
//  Elliot All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMPPlugin : NSObject

/// 当前发起请求的窗口
@property (nonatomic, strong) UIView *currentWebView;

- (void)execute:(UIView *)webView andParams:(NSDictionary *)params;

- (void)jsCallBack:(UIView *)webView andParams:(NSString *)params;

/// 获取webView所属的IMPWindow
- (UIViewController *)getWindowOfWebView:(UIView *)webView;

@end
