//
//  TakeRouterSocketAdressClass.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/26.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakeRouterSocketAdressClass : NSObject

//获取OAuth认证地址     [TakeRouterSocketAdressClass getAppOAuthIP]
+(NSString *)getAppOAuthIP;
//获取正式服务器地址     [TakeRouterSocketAdressClass getAppEMMIP]
+(NSString *)getAppEMMIP;
//获取聊天服务器地址
//chat拆分为Chat、Chat_Channel、Chat_Robot
+(NSString *)getAppECMIP_Chat;
+(NSString *)getAppECMIP_Chat_Channel;
+(NSString *)getAppECMIP_Chat_Robot;
//schedule拆分为meeting、todo、calender
+(NSString *)getAppECMIP_Shedule_Meeting;
+(NSString *)getAppECMIP_Shedule_Todo;
+(NSString *)getAppECMIP_Shedule_Calendar;
//新工作API路由
+(NSString *)getAppECMIP_Work;
//distribution
+(NSString *)getAppECMIP_Distribution;
//news
+(NSString *)getAppECMIP_News;
//storage.legacy
+(NSString *)getAppECMIP_StorageLegacy;
//cloud-drive
+(NSString *)getAppECMIP_CloudDrive;
//client-registry
+(NSString *)getAppECMIP_ClientRegistry;

//socket相关
//socket path
+(NSString *)getSocketPath;
//socket namespace
+(NSString *)getSocketNamespace;
//socket url
+(NSString *)getSocketUrl;
//v0、v1版本相关
+(NSString *)getECMUrlVersion;

@end

NS_ASSUME_NONNULL_END
