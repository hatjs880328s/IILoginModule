//
//  OCRService.m
//  impcloud_dev
//
//  Created by 衣凡 on 2018/6/1.
//  Copyright © 2018年 Elliot. All rights reserved.
//  Edit by Elliot -->暂时屏蔽掉，返回为空

#import "OCRService.h"
//#import "GTMBase64.h"
//#import "GKStatic.h"
#import <WebKit/WebKit.h>
#import "NSObject+SBJSON.h"

@interface OCRService() {
    // 成功回调函数
    NSMutableString* successFunctionName;
    // 失败回调函数
    NSMutableString* failFunctionName;
}
@end

@implementation OCRService
// 初始化
- (id)init
{
    // 调用父类构造
    if (self = [super init]) {
        // 创建成功回调函数
        successFunctionName = [[NSMutableString alloc] init];
        // 创建失败回调函数
        failFunctionName = [[NSMutableString alloc] init];
    }
    return self;
}

#pragma mark - ImpPluginDelegate
// 执行函数
- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    NSString* methodName = [params objectForKey:@"methodName"];
    // 解析函数名
    if ([methodName isEqualToString:@"startPhotoOCR"]){
        [self startPhotoOCR:params];
        
    }
}

- (void)startPhotoOCR:(NSDictionary *)params {
    // 获取参数
    NSDictionary* args = [params objectForKey:@"param"];
    if(![args isKindOfClass:NSDictionary.class]){
        return ;
    }
    // 成功回调函数
    [successFunctionName setString:[args objectForKey:@"success"]];
    [self executeCallback:successFunctionName];
}

- (void)executeCallback:(NSString*)function {
    NSMutableDictionary *photoDic =[NSMutableDictionary dictionary];
    [photoDic setObject:@"" forKey:@"OCRResult"];
    [photoDic setObject:@"" forKey:@"photoData"];
    // 转换成 JSON 字符串
    NSString* json = [photoDic JSONFragment];
    // 拼接内容
    NSString* content = [NSString stringWithFormat:@"%@(%@)",function, json];
    // 调用 JS 函数
    if ([self.currentWebView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)self.currentWebView stringByEvaluatingJavaScriptFromString:content];
    }
    else {
        [(WKWebView *)self.currentWebView evaluateJavaScript:content completionHandler:nil];
    }
}

//- (void)startPhotoOCR:(NSDictionary *)params {
//    // 获取参数
//    NSDictionary* args = [params objectForKey:@"param"];
//
//    // 成功回调函数
//    [successFunctionName setString:[args objectForKey:@"success"]];
//    // 失败回调函数
//    [failFunctionName setString:[args objectForKey:@"fail"]];
//    // 获取参数列表
//    NSDictionary* options = [args objectForKey:@"options"];
//    NSInteger ocrtype = [[options objectForKey:@"OCRType"] integerValue];//识别类型 1为增票， 2为火车票
//
//    [GKStatic OcrWithController:nil checkUrl:@"" ocrType:[NSString stringWithFormat:@"%ld",(long)ocrtype] isAutoCheck:nil uploadtype:@"1" serverurl:@"" ocrLevel:@"1"];
//    if(ocrtype == 1){
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOCRResponse:) name:@"OCRCallback" object:nil];
//    }else if(ocrtype == 2) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOCRResponse:) name:@"OCR_TrainTicket_Callback" object:nil];
//    }
//}
//
//- (void)getOCRResponse:(NSNotification *)noti {
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OCR_TrainTicket_Callback" object:nil];
//
//    NSDictionary *userInfo = noti.userInfo;
//    NSString *path = userInfo[@"path"];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
//
//    [self executeCallback:successFunctionName OCRResult:userInfo photoData:[self dataToBase64String:data]];
//}
//
//// 回调函数
//- (void)executeCallback:(NSString*)function OCRResult:(NSDictionary *)OCRResult photoData:(NSString *)photoData {
//    NSMutableDictionary *photoDic =[NSMutableDictionary dictionary];
//
//    [photoDic setObject:OCRResult forKey:@"OCRResult"];
//    [photoDic setObject:photoData forKey:@"photoData"];
//
//    // 转换成 JSON 字符串
//    NSString* json = [photoDic JSONFragment];
//    // 拼接内容
//    NSString* content = [NSString stringWithFormat:@"%@(%@)",function, json];
//    // 调用 JS 函数
//    [self.currentWebView stringByEvaluatingJavaScriptFromString:content];
//}
//
//- (NSString *)dataToBase64String:(NSData *)data {
//    return [[NSString alloc] initWithData:[GTMBase64 encodeData:data]  encoding:NSUTF8StringEncoding];
//}

@end
