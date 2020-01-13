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

#import "IMPCache.h"
#import "IMPUserModel.h"

#define kAppConfigKey   @"appConfig"
#define kUserConfigKey   @"userConfig"

__strong static id _sharedObject = nil;
@implementation IMPCache
{
    FMDatabaseQueue* queue;
}

- (id)init
{
    self = [super init];
    if(self){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        queue = [FMDatabaseQueue databaseQueueWithPath:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d_4.db",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]]];
    }
    return self;
}

+ (IMPCache*)sharedInstance {
    if(!_sharedObject){
        _sharedObject = [[self alloc] init];
    }
    return _sharedObject;
}

+ (void)reset {
    _sharedObject = nil;
}

#pragma db related
-(void) inDatabase:(void(^)(FMDatabase*))block{
    [queue inDatabase:^(FMDatabase *db){
        block(db);
    }];
}

-(void) inTransaction:(void(^) (FMDatabase *db, BOOL *rollback))block{
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback){
        block(db, rollback);
    }];
    [queue close];
}

#pragma file related

+(void)moveFile:(NSString *)originalPath toPath:(NSString *)destinationPath{
    [[NSFileManager defaultManager] copyItemAtURL:[NSURL URLWithString:originalPath] toURL:[NSURL URLWithString:destinationPath] error:nil];
}

+(void)saveFile:(NSData *)data toPath:(NSString *)destinationPath{
    [data writeToFile:destinationPath atomically:YES];
}

+(NSData *)readFileFromUrl:(NSString *)path{
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        return [NSData dataWithContentsOfFile:path];
    }
    return nil;
}


+ (id)appConfig{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAppConfigKey];
}

+ (void)saveAppConfig:(NSDictionary *)config
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:config forKey:kAppConfigKey];
    [de synchronize];
}


+ (id)userConfig
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserConfigKey];
}

+ (void)saveUserConfig:(NSDictionary *)config
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:config forKey:kUserConfigKey];
    [de synchronize];
}



- (id)objectForKey:(NSString *)key
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    return [de objectForKey:key];
}

- (void)setObject:(NSString *)value forKey:(NSString *)key
{
    if (value == nil || key == nil) {
        return;
    }
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:value forKey:key];
    [de synchronize];
}


@end
