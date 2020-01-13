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

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFOAuth2Manager.h"

@interface IMPHttpSvc : NSObject

+ (AFHTTPRequestOperation *_Null_unspecified)GET:(NSString *_Null_unspecified)URLString
                                      parameters:(id _Null_unspecified)parameters
                                         success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                         failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError * _Null_unspecified error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)GET:(NSString *_Null_unspecified)URLString
                                      parameters:(id _Null_unspecified)parameters
                         isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                                         success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                         failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError * _Null_unspecified error))failure;

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                         header:(NSDictionary *)extraHeader
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)GETDocument:(NSString *_Null_unspecified)URLString
                                              parameters:(id _Null_unspecified)parameters
                                                 success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                                 failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)POST:(NSString *_Null_unspecified)URLString
                                       parameters:(id _Null_unspecified)parameters
                                          success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                          failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError * _Null_unspecified error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)POST:(NSString *_Null_unspecified)URLString
                                       parameters:(id _Null_unspecified)parameters
                          isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                                          success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                          failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
         isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                          header:(NSDictionary *)extraHeader
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)POST:(NSString *_Null_unspecified)URLString
                                       parameters:(id _Null_unspecified)parameters
                         isOtherRequestSerializer:(BOOL)isOtherRequestSerializer
                                          success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                          failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)POST:(NSString *_Null_unspecified)URLString
                                       parameters:(id _Null_unspecified)parameters
                                              url:(NSURL *_Null_unspecified)url
                                             data:(NSData *_Null_unspecified)fileData
                                             name:(NSString *_Null_unspecified)name
                                         fileName:(NSString *_Null_unspecified)fileName
                                          minType:(NSString *_Null_unspecified)minType
                         isHTTPResponseSerializer:(BOOL)isHTTPResponseSerializer
                                          success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id  _Null_unspecified responseObject))success
                                          failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)POST:(NSString *_Null_unspecified)URLString
                                       parameters:(id _Null_unspecified)parameters
                                              url:(NSURL *_Null_unspecified)url
                                             data:(NSData *_Null_unspecified)fileData
                                             name:(NSString *_Null_unspecified)name
                                         fileName:(NSString *_Null_unspecified)fileName
                                          minType:(NSString *_Null_unspecified)minType
                           networkRequestWaitTime:(NSInteger)waitTime
                                          success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id  _Null_unspecified responseObject))success
                                          failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)PUT:(NSString *_Null_unspecified)URLString
                                      parameters:(id _Null_unspecified)parameters
                                         success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                         failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)PUT:(NSString *_Null_unspecified)URLString
                                      parameters:(id _Null_unspecified)parameters
                         isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                                         success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                         failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)DELETE:(NSString *_Null_unspecified)URLString
                                         parameters:(id _Null_unspecified)parameters
                                            success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                            failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

+ (AFHTTPRequestOperation *_Null_unspecified)DELETE:(NSString *_Null_unspecified)URLString
                                         parameters:(id _Null_unspecified)parameters
                            isJsonRequestSerializer:(BOOL)isJsonRequestSerializer
                                            success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                            failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

+ (void)requestAuthTokenWithUserName:(NSString *_Null_unspecified)username
                            password:(NSString *_Null_unspecified)password
                            complete:(void (^_Null_unspecified)(BOOL success,  AFOAuthCredential *_Null_unspecified credential, int code, NSError *_Nullable error))completion;

+(NSURLSessionDownloadTask *_Null_unspecified) Download:(NSString *_Null_unspecified)url
                                            destination:(NSURL * _Nonnull (^ _Nullable)(NSURL * _Nonnull __strong targetPath, NSURLResponse * _Nonnull __strong response)) destination
                                               progress:(NSProgress * _Nullable __autoreleasing *_Nullable)progress
                                             completion:(void (^_Nonnull)(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error))completion;

+(NSURLSessionDownloadTask *_Null_unspecified) DownloadByResumeData:(NSData *_Nullable) resumeData
                                                        destination:(NSURL * _Nonnull (^ _Nullable)(NSURL * _Nonnull __strong targetPath, NSURLResponse * _Nonnull __strong response)) destination
                                                           progress:(NSProgress * _Nullable __autoreleasing *_Nullable)progress
                                                         completion:(void (^_Nonnull)(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error))completion;

+ (AFHTTPRequestOperation *_Null_unspecified)FORMDATA:(NSString *_Null_unspecified)URLString
                                               method:(NSString *_Null_unspecified)requestMethod
                                           parameters:(id _Null_unspecified)parameters
                                              success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                              failure:(void (^_Null_unspecified)(AFHTTPRequestOperation * _Null_unspecified operation, NSError * _Null_unspecified error))failure;
//  For Contact Protocol Buffer
+ (AFHTTPRequestOperation *_Null_unspecified)POST:(NSString *_Null_unspecified)URLString
                                       parameters:(id _Null_unspecified)parameters
                         isHTTPResponseSerializer:(BOOL)isHTTPResponseSerializer
                                          success:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, id _Null_unspecified responseObject))success
                                          failure:(void (^_Null_unspecified)(AFHTTPRequestOperation *_Null_unspecified operation, NSError *_Null_unspecified error))failure;

@end

