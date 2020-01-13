//
//  DialogService.m
//  iOS
//
//  Created by Elliot on 16-12-20.
//  Copyright (c) 2016年 Inspur Group. All rights reserved.
//

#import "DialogService.h"

@implementation DialogService {
    NSString *content;
}

#pragma mark - ImpPluginDelegate
-(void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString *funcName = [params objectForKey:@"methodName"];
    if ([funcName isEqualToString:@"show" ]) {
        content = [params objectForKey:@"content"];
        if (content.length == 0) {
            content = @"";
        }
        [self takeCommand:YES Content:content];
    }
    else if ([funcName isEqualToString:@"hide"]) {
        [self takeCommand:NO Content:nil];
    }
}

-(void)takeCommand:(BOOL)command Content:(NSString *)Commandcontent {
    if (command) {
        NSDictionary *dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:@"show",@"ShowOrHide",Commandcontent,@"Content",nil];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:dicTemp];
        if ([self getWindowOfWebView:self.currentWebView] != nil) {
            [dic setObject:[self getWindowOfWebView:self.currentWebView] forKey:@"WebViewVC"];
        }
        NSDictionary *targetDic = [dic copy];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DialogService_Command" object:nil userInfo:targetDic];
    }
    else {
        NSDictionary *dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:@"hide",@"ShowOrHide",Commandcontent,@"Content",nil];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:dicTemp];
        if ([self getWindowOfWebView:self.currentWebView] != nil) {
            [dic setObject:[self getWindowOfWebView:self.currentWebView] forKey:@"WebViewVC"];
        }
        NSDictionary *targetDic = [dic copy];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DialogService_Command" object:nil userInfo:targetDic];
    }
}

@end
