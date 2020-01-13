
#import "RouteAlert.h"
#import "IMPI18N.h"

static RouteAlert *_routeAlert = nil;

@interface RouteAlert () {
    BOOL isShowOrNot;
}

@end

@implementation RouteAlert

+ (RouteAlert *)shareInstance {
    @synchronized(self) {
        if (_routeAlert == nil) {
            _routeAlert = [[self alloc] init];
        }
    }
    return _routeAlert;
}

- (void)showAlert:(NSString *)msg {
    if (!isShowOrNot) {
        isShowOrNot = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:IMPLocalizedString(@"common_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->isShowOrNot = NO;
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{}];
    }
}

@end
