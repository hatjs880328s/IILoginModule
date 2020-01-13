// ==============================================================================
//
// This file is part of the IMP Cloud.
//
// Create by Shiguang <shiguang@richingtech.com>
// Copyright (c) 2016-2017 inspur.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================


#import "IMPHttpSvc.h"
#include <CommonCrypto/CommonHMAC.h>
#import <sys/utsname.h>
#import "AFHTTPRequestOperationManager+IMPKit.h"
#import "AFOAuth2Manager.h"
#import "IMPAccessTokenModel.h"
#import "RouteAlert.h"
#import "SetSDImageHeaderClass.h"
#import "SetUserPVAndEXPClass.h"
#import "ShowAlertClass.h"
#import "Utilities.h"
#import "GetDeviceUUIDClass.h"
#import "IMPUserModel.h"
#import "TakeRouterSocketAdressClass.h"
#import "Constants.h"
#import <IIOCUtis/ProgressHUD.h>

@import IIHTTPRequest;
@import IIAOPNBP;
@import II18N;

@implementation IMPHttpSvc

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString] absoluteString] parameters:parameters error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

///GET请求 可自定义header
+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                         header:(NSDictionary *)extraHeader
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString] absoluteString] parameters:parameters error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    for(NSString *key in [extraHeader allKeys]){
        [request setValue:extraHeader[key] forHTTPHeaderField:key];
    }
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
        isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    if (isJsonRequestSerializer) {
        AFJSONRequestSerializer *requestSerializer = [IMPHttpSvc generateAFJsonRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        request = [requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    else {
        AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        request = [requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
        isOtherRequestSerializer:(BOOL)isOtherRequestSerializer
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"url-encoded-form" forHTTPHeaderField:@"Content-Type"];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
         isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    NSMutableURLRequest *request;
    if (isJsonRequestSerializer) {
        AFJSONRequestSerializer *requestSerializer = [IMPHttpSvc generateAFJsonRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        request = [requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    else {
        AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
         isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                          header:(NSDictionary *)extraHeader
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    NSMutableURLRequest *request;
    if (isJsonRequestSerializer) {
        AFJSONRequestSerializer *requestSerializer = [IMPHttpSvc generateAFJsonRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        request = [requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    else {
        AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    for(NSString *key in [extraHeader allKeys]){
        [request setValue:extraHeader[key] forHTTPHeaderField:key];
    }
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                             url:(NSURL *)url
                            data:(NSData *)fileData
                            name:(NSString *)name
                        fileName:(NSString *)fileName
                         minType:(NSString *)minType
          networkRequestWaitTime:(NSInteger)waitTime
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        if (url) {
            [formData appendPartWithFileURL:url name:name fileName:fileName mimeType:minType error:&error];
        }
        else if (fileData) {
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:minType];
        }
    } error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];

    NSString *domain = [[NSURL alloc] initWithString:URLString].host;
    NSString *cookie = [self cookieStringWithValidDomain:domain];
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];

    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:waitTime success:success failure:failure];
}

+ (NSString *)cookieStringWithValidDomain:(NSString *)validDomain {
    @autoreleasepool {
        NSArray *cookieArr = [self sharedHTTPCookieStorage];

        NSMutableArray *marr = @[].mutableCopy;

        for (NSHTTPCookie *cookie in cookieArr) {
            if ([cookie.name rangeOfString:@"'"].location != NSNotFound) {
                continue;
            }

            if (![validDomain hasSuffix:cookie.domain] && ![cookie.domain hasSuffix:validDomain]) {
                continue;
            }

            NSString *value = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
            [marr addObject:value];
        }

        NSString *cookie = [marr componentsJoinedByString:@";"];

        return cookie;
    }
}

+ (NSArray *)sharedHTTPCookieStorage {
    @autoreleasepool {
        NSMutableArray *cookieMarr = [NSMutableArray array];
        NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in sharedCookies.cookies){
            [cookieMarr addObject:cookie];
        }
        //删除过期的cookie
        for (int i = 0; i < cookieMarr.count; i++) {
            NSHTTPCookie *cookie = [cookieMarr objectAtIndex:i];

            if (!cookie.expiresDate) {
                continue;
            }
            if ([[[self currentTime] laterDate:cookie.expiresDate] isEqualToDate:cookie.expiresDate]) {
                continue;
            } else {
                [cookieMarr removeObject:cookie];
                i--;
            }
        }
        return cookieMarr.copy;
    }
}

+ (NSDate *)currentTime {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date  dateByAddingTimeInterval:interval];
    return localDate;
}

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                             url:(NSURL *)url
                            data:(NSData *)fileData
                            name:(NSString *)name
                        fileName:(NSString *)fileName
                         minType:(NSString *)minType
        isHTTPResponseSerializer:(BOOL)isHTTPResponseSerializer
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if(isHTTPResponseSerializer) {
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    }
    else {
        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        if (url) {
            [formData appendPartWithFileURL:url name:name fileName:fileName mimeType:minType error:&error];
        }
        else if (fileData) {
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:minType];
        }
    } error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFJsonRequestSerializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(id)parameters
        isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    if(isJsonRequestSerializer) {
        AFJSONRequestSerializer *requestSerializer = [IMPHttpSvc generateAFJsonRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        request = [requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    else {
        AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        request = [requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(id)parameters
           isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    if (isJsonRequestSerializer) {
        AFJSONRequestSerializer *requestSerializer = [IMPHttpSvc generateAFJsonRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        request = [requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    else {
        AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
        [manager setRequestSerializer:requestSerializer];
        requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        request = [requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        request = [IMPHttpSvc fillRequestHeaderInfo:request];
    }
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFHTTPRequestOperation *)GETDocument:(NSString *)URLString
                             parameters:(id)parameters
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html",@"application/zip", nil]];
    [manager setResponseSerializer:responseSerializer];
    AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

+ (AFJSONResponseSerializer *)generateAFJsonResponseSerializer {
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html",nil]];
    return responseSerializer;
}

+ (AFHTTPRequestSerializer *)generateAFHTTPRequestSerializer {
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[NSString stringWithFormat:@"iOS/%@(Apple %@) CloudPlus_Phone/%@",[Utilities getDeviceiOSVersion],[Utilities getDeviceKey],[Utilities getAPPCurrentVersion]] forHTTPHeaderField:@"User-Agent"];
    [requestSerializer setValue:[[GetDeviceUUIDClass shareInstance] getDeviceUUID] forHTTPHeaderField:@"X-Device-ID"];
    NSString *id_Enterprise = [NSString stringWithFormat:@"%d",[IMPUserModel activeInstance].enterprise.id];
    if (id_Enterprise.length != 0) {
        [requestSerializer setValue:id_Enterprise forHTTPHeaderField:@"X-ECC-Current-Enterprise"];
    }
    return requestSerializer;
}

+ (AFJSONRequestSerializer *)generateAFJsonRequestSerializer {
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:[NSString stringWithFormat:@"iOS/%@(Apple %@) CloudPlus_Phone/%@",[Utilities getDeviceiOSVersion],[Utilities getDeviceKey],[Utilities getAPPCurrentVersion]] forHTTPHeaderField:@"User-Agent"];
    [requestSerializer setValue:[[GetDeviceUUIDClass shareInstance] getDeviceUUID] forHTTPHeaderField:@"X-Device-ID"];
    NSString *id_Enterprise = [NSString stringWithFormat:@"%d",[IMPUserModel activeInstance].enterprise.id];
    [requestSerializer setValue:id_Enterprise forHTTPHeaderField:@"X-ECC-Current-Enterprise"];
    return requestSerializer;
}

+ (NSMutableURLRequest *)fillRequestHeaderInfo:(NSMutableURLRequest *)request {
    IMPAccessTokenModel *model = [IMPAccessTokenModel activeToken];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", model.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *id_Enterprise = [NSString stringWithFormat:@"%d",[IMPUserModel activeInstance].enterprise.id];
    [request setValue:id_Enterprise forHTTPHeaderField:@"X-ECC-Current-Enterprise"];
    return request;
}

+ (void)requestAuthTokenWithUserName:(NSString *)username password:(NSString *)password complete:(void (^)(BOOL success, AFOAuthCredential *credential,int code, NSError *_Nullable error))completion {
    NSURL *baseURL = [NSURL URLWithString:[TakeRouterSocketAdressClass getAppOAuthIP]];
    AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseURL clientID:kOAuthClientId secret:kOAuthSecret];
    [OAuth2Manager authenticateUsingOAuthWithURLString:[NSString stringWithFormat:@"%@/oauth2.0/token",[TakeRouterSocketAdressClass getAppOAuthIP]] username:username password:password scope:@"" success:^(AFOAuthCredential *credential) {
        completion(YES, credential, 200, nil);
    } failure:^(NSError *error) {
        [SetUserPVAndEXPClass getUserEXPContentErrorLevel:@"2" ErrorUrl:[NSString stringWithFormat:@"%@",[TakeRouterSocketAdressClass getAppOAuthIP]] ErrorInfo:[NSString stringWithFormat:@"%@",error] errorCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
        [[IMPAccessTokenModel activeToken] reset];
        NSString *pStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (pStr.length>0 && [pStr rangeOfString:@"(400)"].location != NSNotFound) {
            completion(false, nil, 400, error);
        }
        else {
            completion(false, nil, (int)error.code, error);
        }
    }];
}

+ (NSURLSessionDownloadTask *) Download:(NSString *)url
                            destination:(NSURL * _Nonnull (^ _Nullable)(NSURL * _Nonnull __strong targetPath, NSURLResponse * _Nonnull __strong response)) destination
                               progress:(NSProgress * __autoreleasing *)progress
                             completion:(void (^_Nonnull)(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error))completion {
    NSURL *downloadUrl = [[NSURL alloc] initWithString:url];
    if (downloadUrl.scheme.length == 0) {
        [[RouteAlert shareInstance] showAlert:IMPLocalizedString(@"Route_Alert_Tips")];
        return nil;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html",@"application/zip",@"image/jpeg",@"application/zip", nil]];
    [manager setResponseSerializer:responseSerializer];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:progress destination:destination completionHandler:completion];
    [task resume];
    return task;
}

+ (NSURLSessionDownloadTask *) DownloadByResumeData:(NSData *) resumeData
                                        destination:(NSURL * _Nonnull (^ _Nullable)(NSURL * _Nonnull __strong targetPath, NSURLResponse * _Nonnull __strong response)) destination
                                           progress:(NSProgress * __autoreleasing *)progress
                                         completion:(void (^_Nonnull)(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error))completion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithResumeData:resumeData progress:progress destination:destination completionHandler:completion];
    [task resume];
    return task;
}

+ (AFHTTPRequestOperation *)FORMDATA:(NSString *)URLString
                              method:(NSString *)requestMethod
                          parameters:(id)parameters
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *headers = @{ @"X-ECC-Current-Enterprise": [NSString stringWithFormat:@"%d",[IMPUserModel activeInstance].enterprise.id],
                               @"Authorization": [NSString stringWithFormat:@"Bearer %@", [IMPAccessTokenModel activeToken].accessToken],
                               @"Content-Type": @"application/x-www-form-urlencoded"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFJsonResponseSerializer]];
    AFHTTPRequestSerializer *requestSerializer = [IMPHttpSvc generateAFHTTPRequestSerializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:requestMethod URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:nil error:nil];
    [request setAllHTTPHeaderFields:headers];
    NSArray * allkeys = [parameters allKeys];
    NSString *dataString = @"";
    for (int i = 0; i < allkeys.count; i++) {
        NSString * key = [allkeys objectAtIndex:i];
        if (i > 0) {
            dataString = [dataString stringByAppendingString:@"&"];
        }
        if ([parameters[key] isKindOfClass:NSArray.class] || [parameters[key] isKindOfClass:NSMutableArray.class]) {
            for (int j = 0;j < [parameters[key] count];j++) {
                NSString *member = [parameters[key] objectAtIndex:j];
                dataString = [dataString stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,member]];
                if(j != [parameters[key] count] - 1) {
                    dataString = [dataString stringByAppendingString:@"&"];
                }
            }
        }
        else {
            dataString = [dataString stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,parameters[key]]];
        }
    }
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

//  刷新Token后执行设置SD及Socket相关操作
+ (void)setSDHeaderAndHandleSocket {
    //设置SD
    [SetSDImageHeaderClass setSDWebImageHeader];
    //Socket
    Class socketClass = NSClassFromString(@"SocketManage");
    if (socketClass != nil && [socketClass respondsToSelector:@selector(shareInstance)]) {
        id socketInstance = [socketClass performSelector:@selector(shareInstance)];
        if (socketInstance != nil && [socketInstance respondsToSelector:@selector(reconnectSocket)]) {
            [socketInstance performSelector:@selector(reconnectSocket)];
        }
    }
}

// For Contact Protocol Buffer
+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
        isHTTPResponseSerializer:(BOOL)isHTTPResponseSerializer
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[IMPHttpSvc generateAFHTTPResponseSerializer]];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager setRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
    request = [IMPHttpSvc fillRequestHeaderInfo:request];
    return [IMPHttpSvc sendRequestWithRequest:request manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
}

// For Contact Protocol Buffer
+ (AFHTTPResponseSerializer *)generateAFHTTPResponseSerializer {
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", @"text/plain", nil]];
    return responseSerializer;
}

+ (AFHTTPRequestOperation *)sendRequestWithRequest:(NSMutableURLRequest*) request
                                           manager:(AFHTTPRequestOperationManager *)manager
                            networkRequestWaitTime:(NSInteger)waitTime
                                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setAllowInvalidCertificates:NO];
    [securityPolicy setValidatesDomainName:YES];
    manager.securityPolicy = securityPolicy;
    [self writeLogWithUrl:[NSString stringWithFormat:@"普通Url请求-->%@ 当前AT-->%@ , RT-->%@", [[request URL] absoluteString], [IMPAccessTokenModel activeToken].accessToken, [IMPAccessTokenModel activeToken].refreshToken]];
    NSURL *url = request.URL;
    if (url.scheme.length == 0) {
        [[RouteAlert shareInstance] showAlert:IMPLocalizedString(@"Route_Alert_Tips")];
        failure(nil, nil);
        return nil;
    }
    [request setTimeoutInterval:waitTime];
    if ([[IMPI18N userLanguage] isEqualToString:@"zh-Hans"]) {
        [request setValue:@"zh-Hans" forHTTPHeaderField:@"Accept-Language"];
    }
    else if ([[IMPI18N userLanguage] isEqualToString:@"en"]) {
        [request setValue:@"en" forHTTPHeaderField:@"Accept-Language"];
    }
    else {
        [request setValue:@"zh-Hans" forHTTPHeaderField:@"Accept-Language"];
    }
    NSString *id_Enterprise = [NSString stringWithFormat:@"%d",[IMPUserModel activeInstance].enterprise.id];
    [request setValue:id_Enterprise forHTTPHeaderField:@"X-ECC-Current-Enterprise"];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation,  id responseObject) {
        if (operation.response.statusCode) {
            success(operation, responseObject);
        }
        else {
            failure(operation, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation,  NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [SetUserPVAndEXPClass getUserEXPContentErrorLevel:@"3" ErrorUrl:[NSString stringWithFormat:@"%@",request.URL] ErrorInfo:[NSString stringWithFormat:@"%@",error] errorCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
            dic[@"NSLocalizedDescription"] = IMPLocalizedString(@"common_timeout");
            NSError * error1 = [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:dic];
            failure(operation,error1);
            return ;
        }
        if(!error.code) {
            [SetUserPVAndEXPClass getUserEXPContentErrorLevel:@"2" ErrorUrl:[NSString stringWithFormat:@"%@",request.URL] ErrorInfo:[NSString stringWithFormat:@"%@",error] errorCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
            failure(operation, nil);
            return ;
        }
        if (operation.response.statusCode == 401) {
            NSDictionary *requestHeaders = request.allHTTPHeaderFields;
            NSString *targetToken = [requestHeaders objectForKey:@"Authorization"];
            //记录网络访问请求-刷新Token API-@"request报401，需要刷新Token"
            [self writeLogWithUrl:[NSString stringWithFormat:@"request-->%@ 报401，需要刷新Token Token-->%@", [[request URL] absoluteString], targetToken]];
            [IIHTTPRefreshATModule refreshTokenWithOriginAT:targetToken showAlertInfo:YES directRequest:^{
                [self setSDHeaderAndHandleSocket];
                NSMutableURLRequest * requestNew = [IMPHttpSvc fillRequestHeaderInfo:request];
                [IMPHttpSvc sendRequestWithRequest:requestNew manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
            } successAction:^(ResponseClass * _Nonnull dic) {
                //记录刷新时间
                [[NSUserDefaults standardUserDefaults] setInteger:[[NSDate date] timeIntervalSince1970] forKey:[NSString stringWithFormat:@"%@_%d_refreshATTime",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self setSDHeaderAndHandleSocket];
                //记录网络访问请求-刷新Token API-@"request报401，刷新Token成功"
                [self writeLogWithUrl:[NSString stringWithFormat:@"request-->%@ 报401，刷新Token成功 AT-->%@ , RT-->%@", [[request URL] absoluteString], [IMPAccessTokenModel activeToken].accessToken, [IMPAccessTokenModel activeToken].refreshToken]];
                NSMutableURLRequest * requestNew = [IMPHttpSvc fillRequestHeaderInfo:request];
                [IMPHttpSvc sendRequestWithRequest:requestNew manager:manager networkRequestWaitTime:NetworkRequestWaitTime success:success failure:failure];
            } errorAction:^(BOOL shouldLogOut, NSString * _Nullable errorInfo) {
                if (shouldLogOut) {
                    //记录异常
                    [SetUserPVAndEXPClass getUserEXPContentErrorLevel:@"6" ErrorUrl:[[request URL] absoluteString] ErrorInfo:errorInfo errorCode:@"400"];
                    //记录网络访问请求-刷新Token API-@"request报401，刷新Token失败，需要登出"
                    [self writeLogWithUrl:[NSString stringWithFormat:@"request-->%@ 报401，刷新Token失败，需要登出 报错信息-->%@", [[request URL] absoluteString], errorInfo]];
                    //弹出消息提醒
                    [[RouteAlert shareInstance] showAlert:IMPLocalizedString(@"common_authorization")];
                    //退出登录
                    Class obj = NSClassFromString(@"ActionForLogin");
                    if (obj != nil && [obj respondsToSelector:@selector(doLogout)]) {
                        [obj performSelector:@selector(doLogout)];
                    }
                }
                else {
                    //记录异常
                    [SetUserPVAndEXPClass getUserEXPContentErrorLevel:@"6" ErrorUrl:[[request URL] absoluteString] ErrorInfo:errorInfo errorCode:@"-1001"];
                    //记录网络访问请求-刷新Token API-@"request报401，刷新Token失败，不需要登出"
                    [self writeLogWithUrl:[NSString stringWithFormat:@"request-->%@ 报401，刷新Token失败，不需要登出 AT-->%@ , RT-->%@ 报错信息-->%@", [[request URL] absoluteString], [IMPAccessTokenModel activeToken].accessToken, [IMPAccessTokenModel activeToken].refreshToken, errorInfo]];
                }
            }];
        }
        else {
            [SetUserPVAndEXPClass getUserEXPContentErrorLevel:@"2" ErrorUrl:[NSString stringWithFormat:@"%@",request.URL] ErrorInfo:[NSString stringWithFormat:@"%@",error] errorCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
            failure(operation, error);
        }
    }];
    [manager.operationQueue addOperation:operation];
    return operation;
}

// 使用CustomEvent 记录日志
+ (void)writeLogWithUrl:(NSString *)url {
    CustomEvent *event = [[CustomEvent alloc] init];
    [event setBaseInfoWithInfo:url];
}

@end
