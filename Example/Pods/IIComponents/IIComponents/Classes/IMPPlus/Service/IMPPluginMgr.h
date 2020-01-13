//
//  IMPPluginMgr.h
//  Elliot All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 插件管理，单例实现
@interface IMPPluginMgr : NSObject

// 单例
+ (IMPPluginMgr *)sharedPluginManager;

// 执行功能
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params;

@end
