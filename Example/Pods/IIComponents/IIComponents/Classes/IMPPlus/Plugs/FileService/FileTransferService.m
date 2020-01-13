//
//  FileTransferService.m
//  iPhone_hybrid
//
//  Created by Xuyoung on 14-3-25.
//  Copyright (c) 2014年 浪潮移动应用平台(IMP)产品组. All rights reserved.
//

#import "FileTransferService.h"
#import "ViewController_ShowTxt.h"
#import "NSObject+SBJSON.h"
@import IIBLL;

@interface FileTransferService ()<IMPWebSolutionDelegate> {
    //当前进度
    CGFloat current;
    id<IMPWebSolutionIBLL> plugBll;
    BOOL needOpen;
}


//@property (nonatomic,retain) NSMutableData *connectionData;

@property (nonatomic,retain) NSDictionary *params;
@property (nonatomic, retain) NSString* successCallback;
@property (nonatomic, retain) NSString* failCallback;

@property (nonatomic, retain) NSString* progressCallback;

// 文件总长度
//@property (nonatomic, assign) long long fileLength;
//@property (nonatomic, assign) long long currentReceiveLength;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

@end

@implementation FileTransferService
@synthesize pString_Filepath;

- (void)execute:(UIView *)webView andParams:(NSDictionary *)params {
    self.currentWebView = webView;
    self.params = [params objectForKey:@"param"];
    self.successCallback = [self.params objectForKey:@"success"];
    self.failCallback = [self.params objectForKey:@"fail"];

    if(![self.params isKindOfClass:NSDictionary.class]){
        return ;
    }

    self.progressCallback = [self.params objectForKey:@"progressCallback"];

    //将参数读取到BLL
    [[self getService] bll_FileService_initData:params currentWebView:webView];

    NSString* methodName = [params objectForKey:@"methodName"];
    if ([methodName isEqualToString:@"upload"]) {
        //上传
        [[self getService] bll_FileService_uploadFileWithDelegate:self];
    }
    else if ([methodName isEqualToString:@"download"]) {
        needOpen = YES;
        //下载
        [self downloadfile:needOpen];
    }else if([methodName isEqualToString:@"saveFile"]){
        needOpen = NO;
        //下载
        [self downloadfile:needOpen];
    }
    else if ( [methodName isEqualToString:@"selectFile"]) {
        //选择文件
        [[self getService] bll_FileService_selectFile:self];
    }
    else if ( [methodName isEqualToString:@"base64File"]) {
        //base64
        NSString *base64Data = [[self getService] bll_FileService_getBase64];

        [self callBackByFunction:self.successCallback param:base64Data];

    }else if([methodName isEqualToString:@"writeFile"]){
        //写入文件
        [self writeFile];
    }else if([methodName isEqualToString:@"readFile"]) {
        //读取文件
        [self readFile];
    }else if([methodName isEqualToString:@"listFile"]) {
        //枚举列表
        [self listFile];
    }else if([methodName isEqualToString:@"deleteFile"]) {
        //删除文件
        [self deleteFile];
    }
}

- (void)writeFile {
    NSString *path = [[self getService] bll_FileService_writeFile];
    if([path isEqualToString:@""]){
        [self callBackByFunction:self.failCallback param:@""];
    }else {
        [self callBackByFunction:self.successCallback jsonParam:@""];
    }
}

- (void)readFile {
    NSString *content = [[self getService] bll_FileService_readFile];

    NSDictionary *dic = @{
                          @"content" : content ? content : @""
                          };

    [self callBackByFunction:self.successCallback jsonParam:[dic JSONFragment]];
}

- (void)listFile {
    NSDictionary *dic = [[self getService] bll_FileService_listFile];
    [self callBackByFunction:self.successCallback jsonParam:[dic JSONFragment]];
}

- (void)deleteFile {
    BOOL success = [[self getService] bll_FileService_deleteFile];

    [self callBackByFunction:success ? self.successCallback : self.failCallback param:@""];
}

#pragma mark IMPWebSolutionDelegate
- (void)uploadFileResult:(BOOL)success param:(NSString *)param{
    if(success) {
        [self callBackByFunction:self.successCallback jsonParam:param];
    }else {
        [self callBackByFunction:self.failCallback jsonParam:param];
    }
}

//出现错误时，通过showStr传递错误
- (void)downloadFileResult:(BOOL)ifSuccess path:(NSString *)filePath fileName:(NSString *)filename showStr:(NSString *)showStr {
    if (!ifSuccess) {
        NSDictionary *failDic = @{@"status" : @1, @"errorMessage" : showStr};
        //20190812 失败也通过SuccessCallBack返回
        [self callBackByFunction:self.successCallback jsonParam:[failDic JSONFragment]];
    }
    if (needOpen) {
        self.pString_Filepath = filePath;
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        previewController.delegate = self;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [[self viewController] presentViewController:previewController animated:YES completion:nil];
    }
    else {
        NSDictionary *successDic = @{@"path" : filePath};
        [self callBackByFunction:self.successCallback jsonParam:[successDic JSONFragment]];
    }
}

# pragma mark ASIProgressDelegate Method
- (void)setProgress:(float)newProgress {

    current = newProgress;
    int currentProgress = current * 100;

    NSString *textParams = [NSString stringWithFormat:@"%@('%d')", self.progressCallback, currentProgress];
    [self jsCallBack:self.currentWebView andParams:textParams];
}

// 下载文件，异步下载
- (void)downloadfile:(BOOL)needOpen {
    [[self getService] bll_FileService_downloadfile:self needOpen:needOpen];
}

// 获取view对应的viewcontroller
- (UIViewController*)viewController {
    for (UIView* next = [self.currentWebView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)setupDocumentControllerWithURL:(NSURL *)url {
    if (self.docInteractionController == nil) {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else {
        self.docInteractionController.URL = url;
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController {
    return (id)self;
}

#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController {
    return 1;
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    // if the preview dismissed (done button touched), use this method to post-process previews
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx {
    NSURL *fileURL = nil;
    fileURL = [NSURL fileURLWithPath:self.pString_Filepath];
    return fileURL;
}

#pragma mark -
- (void)dealloc {
}

- (id<IMPWebSolutionIBLL>)getService {
    if (plugBll == nil){
        plugBll= [[BeeHive shareInstance] createService:@protocol(IMPWebSolutionIBLL)];
    }
    return plugBll;
}

- (void)callBackByFunction:(NSString *)function param:(NSString *)param {
    if(function == nil){
        return;
    }
    NSString *callBack =  [NSString stringWithFormat:@"%@('%@')", function, param];
    [self jsCallBack:self.currentWebView andParams:callBack];
}

- (void)callBackByFunction:(NSString *)function jsonParam:(NSString *)jsonParam {
    if(function == nil){
        return;
    }
    NSString *callBack =  [NSString stringWithFormat:@"%@(%@)", function, jsonParam];
    [self jsCallBack:self.currentWebView andParams:callBack];
}
@end
