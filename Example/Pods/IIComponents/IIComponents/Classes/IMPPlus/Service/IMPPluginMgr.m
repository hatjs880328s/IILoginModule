//
//  IMPPluginMgr.m
//  Elliot All rights reserved.
//

#import "IMPPluginMgr.h"
#import "IMPPlugin.h"
@import IIOCUtis;

@interface IMPPluginMgr ()

@property (nonatomic, strong) NSMutableDictionary *plugins;

@end

@implementation IMPPluginMgr

/// 单例中的唯一实例
static IMPPluginMgr *instance = nil;

/// 初始化
- (id)init {
    if (self = [super init]) {
        self.plugins = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

+ (IMPPluginMgr *)sharedPluginManager {
    __strong static IMPPluginMgr *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/// 查找插件
- (IMPPlugin *)findPluginWithClassName:(NSString *)className {
    // 插件
    IMPPlugin *plugin = nil;
    // 获取类型
    Class class = NSClassFromString(className);
    // 判断是否找到类型
    if (class != nil) {
        // 判断父类是否是插件类型
        if ([class isSubclassOfClass:[IMPPlugin class]]) {
            plugin = [self.plugins objectForKey:className];
            if (plugin == nil) {
                // 创建实例
                plugin = [[class alloc] init];
                [self.plugins setObject:plugin forKey:className];
            }
        }
    }
    return plugin;
}

- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    NSString *className = [params objectForKey:@"className"];
    IMPPlugin *plugin = [self findPluginWithClassName:className];
    if (plugin != nil) {
        [plugin execute:webView andParams:params];
    } else {
        //无此服务，则提示
        [Utilities showToast:@"功能调用错误,请检查应用是否已升级到最新版本"];
    }
}

@end
