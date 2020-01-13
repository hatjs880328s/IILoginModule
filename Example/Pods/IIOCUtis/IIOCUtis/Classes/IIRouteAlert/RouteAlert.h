
#import <UIKit/UIKit.h>

@interface RouteAlert : NSObject

+ (RouteAlert *)shareInstance;
- (void)showAlert:(NSString *)msg;

@end
