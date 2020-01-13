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
#import "FMDB.h"

#define kUserCacheXXX   @"userCacheXXX"

@interface IMPCache : NSObject

+(IMPCache*) sharedInstance;

+ (void)reset;

#pragma db related
-(void) inDatabase:(void(^)(FMDatabase*))block;

-(void) inTransaction:(void(^) (FMDatabase *db, BOOL *rollback))block;


#pragma file related
+(void)moveFile:(NSString *)originalPath toPath:(NSString*)destinationPath;
+(void)saveFile:(NSData *)originalPath toPath:(NSString*)destinationPath;
+(NSData *)readFileFromUrl:(NSString *)path;

+(id)appConfig;
+(void)saveAppConfig:(NSDictionary *)config;

+ (id)userConfig;
+ (void)saveUserConfig:(NSDictionary *)config;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(NSString *)value forKey:(NSString *)key;



@end
