
#import "ProgressHUD.h"
#import "JGProgressHUD.h"
@import II18N;

static ProgressHUD *_singleInstance = nil;

@interface ProgressHUD () {
    JGProgressHUD *HUD;
}

@end

@implementation ProgressHUD

+ (ProgressHUD *)shareInstance {
    @synchronized(self) {
        if (_singleInstance == nil) {
            _singleInstance = [[self alloc] init];
            [_singleInstance creatView];
        }
    }
    return _singleInstance;
}

- (void)creatView {
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
}

- (void)showProgress {
    [HUD showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showProgressWithMessage:(NSString *)message {
    HUD.textLabel.text = message;
    [HUD showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showAlertWithMessage:(NSString *)message {
    //[[UIApplication sharedApplication].delegate.window makeToast:message duration:1.0 position:CSToastPositionCenter];
}

- (void)showAlertWithError:(NSError *)error {
    NSString *domain = [error domain];
    if (domain && ([domain isEqualToString:@"internal_error.UNKNOW"] ||[domain isEqualToString:@"internal_error.SERVICE-EXECUTION-TIMEOUT"])) {
        [self showAlertWithMessage:IMPLocalizedString(@"common_request_error")];
    }
    else if(domain && [domain isEqualToString:@"NSURLErrorDomain"]) {
        [self showAlertWithMessage:IMPLocalizedString(@"common_request_unConnect")];
    }
    else if(domain && [domain isEqualToString:@"forbidden.APP-OVER-INVOCATION-LIMIT"]) {
         [self showAlertWithMessage:IMPLocalizedString(@"common_request_error")];
    }
    else {
        [self showAlertWithMessage:IMPLocalizedString(@"common_request_error")];
    }
}

- (void)remove {
    [HUD dismiss];
}

- (void)dealloc {
    if (_singleInstance) {
        _singleInstance = nil;
    }
}

@end
