//
//  ContactProgress.h
//  impcloud_dev
//
//  Created by Elliot on 2018/5/1.
//  Copyright © 2018年 Elliot. All rights reserved.
//

#import "ContactProgress.h"

@import II18N;

@interface ContactProgress () {
    NSTimer *timer;
}
@property(strong,nonatomic) IBOutlet UIImageView *imgView;
@property(strong,nonatomic) IBOutlet UILabel *labelTips;
@end

@implementation ContactProgress
@synthesize imgView;
@synthesize labelTips;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startChangeLabelTask];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopChangeLabelTask];
}

- (void)startChangeLabelTask {
    //连接中...
    NSDate *scheduledTime = [NSDate dateWithTimeIntervalSinceNow:0.0];
    NSString *customUserObject = @"change_label_text";
    timer = [[NSTimer alloc] initWithFireDate:scheduledTime interval:1 target:self selector:@selector(changeLabelTask) userInfo:customUserObject repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)changeLabelTask {
    int pointNum = (int)[[NSDate date] timeIntervalSince1970] % 3;
    NSString *pointStr = @"";
    while(pointNum > -1){
        pointStr = [pointStr stringByAppendingString:@"."];
        pointNum --;
    }
    labelTips.text = [NSString stringWithFormat:@"%@%@",IMPLocalizedString(@"Contact_Alert_InitTip"),pointStr];
}

-(void) stopChangeLabelTask {
    if([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

@end

