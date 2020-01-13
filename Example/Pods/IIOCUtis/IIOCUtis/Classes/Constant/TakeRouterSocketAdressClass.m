//
//  TakeRouterSocketAdressClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/26.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "TakeRouterSocketAdressClass.h"
#import "IMPUserModel.h"

@implementation TakeRouterSocketAdressClass

//获取OAuth认证地址     [TakeRouterSocketAdressClass getAppOAuthIP]
+(NSString *)getAppOAuthIP {
    NSString *strAppOAuthIP = @"https://id.inspuronline.com";
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"kAppMainIP"];
    if (str.length != 0) {
        strAppOAuthIP = str;
    }
    return strAppOAuthIP;
}
//获取EMM服务器地址     [TakeRouterSocketAdressClass getAppEMMIP]
+(NSString *)getAppEMMIP {
    NSString *strAppEMMIP = @"https://emm.inspur.com";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.emm"]) {
                strAppEMMIP = [dic objectForKey:@"base_url"];
            }
        }
    }
    return strAppEMMIP;
}
//chat
+(NSString *)getAppECMIP_Chat {
    NSString *strAppChat = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.chat"]) {
                strAppChat = [dic objectForKey:@"base_url"];
            }
        }
    }
    return strAppChat;
}
+(NSString *)getAppECMIP_Chat_Channel {
    NSString *strAppChat_Channel = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.chat"]) {
                NSString *strVersion = [dic objectForKey:@"service_version"];
                if ([strVersion hasPrefix:@"v0"]) {
                    strAppChat_Channel = [dic objectForKey:@"base_url"];
                }
                else if ([strVersion hasPrefix:@"v1"]) {
                    NSURL *url = [[NSURL alloc] initWithString:[dic objectForKey:@"base_url"]];
                    if ([url.port isKindOfClass:[NSNull class]] || url.port == nil) {
                        strAppChat_Channel = [NSString stringWithFormat:@"%@://%@/%@",url.scheme,url.host,[IMPUserModel activeInstance].enterprise.code];
                    }
                    else {
                        strAppChat_Channel = [NSString stringWithFormat:@"%@://%@:%@/%@",url.scheme,url.host,url.port,[IMPUserModel activeInstance].enterprise.code];
                    }
                }
            }
        }
    }
    return strAppChat_Channel;
}
+(NSString *)getAppECMIP_Chat_Robot {
    NSString *strAppChat_Robot = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.bot"]) {
                strAppChat_Robot = [dic objectForKey:@"base_url"];
            }
        }
    }
    return strAppChat_Robot;
}
//schedule拆分为meeting、todo、calender
+(NSString *)getAppECMIP_Shedule_Meeting {
    return [self getAppECMIP_Work];
}
+(NSString *)getAppECMIP_Shedule_Todo {
    NSString *strAppSheduleTodo = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.schedule"]) {
                NSString *strVersion = [dic objectForKey:@"service_version"];
                if ([strVersion hasPrefix:@"v0"]) {
                    strAppSheduleTodo = [NSString stringWithFormat:@"%@/api/v0",[self getAppECMIP_Work]];
                }
                else if ([strVersion hasPrefix:@"v1"]) {
                    strAppSheduleTodo = [self getAppECMIP_Work];
                }
            }
        }
    }
    return strAppSheduleTodo;
}
+(NSString *)getAppECMIP_Shedule_Calendar {
    return [self getAppECMIP_Shedule_Todo];
}
//新工作API路由
+(NSString *)getAppECMIP_Work {
    NSString *strAppWork = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.schedule"]) {
                strAppWork = [dic objectForKey:@"base_url"];
            }
        }
    }
    return strAppWork;
}
//distribution
+(NSString *)getAppECMIP_Distribution {
    NSString *strAppDistribution = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.distribution"]) {
                strAppDistribution = [dic objectForKey:@"base_url"];
            }
        }
    }
    return strAppDistribution;
}
//news
+(NSString *)getAppECMIP_News {
    NSString *strAppNews = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.news"]) {
                strAppNews = [dic objectForKey:@"base_url"];
            }
        }
    }
    return strAppNews;
}
//storage.legacy
+(NSString *)getAppECMIP_StorageLegacy {
    NSString *strAppStorageLegacy = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.storage.legacy"]) {
                strAppStorageLegacy = [dic objectForKey:@"base_url"];
            }
        }
    }
    return strAppStorageLegacy;
}
//cloud-drive
+(NSString *)getAppECMIP_CloudDrive {
    NSString *strAppCloudDrive = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.cloud-drive"]) {
                strAppCloudDrive = [dic objectForKey:@"base_url"];
            }
        }
    }
    return strAppCloudDrive;
}
//client-registry
+(NSString *)getAppECMIP_ClientRegistry {
    NSString *strAppClientRegistry = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.client-registry"]) {
                strAppClientRegistry = [dic objectForKey:@"base_url"];
            }
        }
    }
    return strAppClientRegistry;
}

//socket相关
//socket path
+(NSString *)getSocketPath {
    NSString *strSocketPath = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.chat"]) {
                NSURL *url = [[NSURL alloc] initWithString:[dic objectForKey:@"base_url"]];
                strSocketPath = [NSString stringWithFormat:@"%@/socket/handshake",url.path];
            }
        }
    }
    return strSocketPath;
}
//socket namespace
+(NSString *)getSocketNamespace {
    NSString *strSocketNamespace = @"/";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.chat"]) {
                NSString *strVersion = [dic objectForKey:@"service_version"];
                if ([strVersion hasPrefix:@"v1"]) {
                    strSocketNamespace = @"/api/v1";
                }
            }
        }
    }
    return strSocketNamespace;
}
//socket url
+(NSString *)getSocketUrl {
    NSString *strSocketUrl = @"";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]&&[[dic allKeys] containsObject:@"base_url"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.chat"]) {
                NSURL *url = [[NSURL alloc] initWithString:[dic objectForKey:@"base_url"]];
                if ([url.port isKindOfClass:[NSNull class]] || url.port == nil) {
                    strSocketUrl = [NSString stringWithFormat:@"%@://%@",url.scheme,url.host];
                }
                else {
                    strSocketUrl = [NSString stringWithFormat:@"%@://%@:%@",url.scheme,url.host,url.port];
                }
            }
        }
    }
    return strSocketUrl;
}
//v0、v1版本相关
+(NSString *)getECMUrlVersion {
    NSString *strUrlVersion = @"v0";
    for (int i=0; i<[IMPUserModel activeInstance].enterprise.clusters.count; i++) {
        NSDictionary *dic = [IMPUserModel activeInstance].enterprise.clusters[i];
        if ([[dic allKeys] containsObject:@"service_name"]) {
            NSString *str = [dic objectForKey:@"service_name"];
            if ([str isEqualToString:@"com.inspur.ecm.chat"]) {
                NSString *strVersion = [dic objectForKey:@"service_version"];
                if ([strVersion hasPrefix:@"v0"]) {
                    strUrlVersion = @"v0";
                }
                else if ([strVersion hasPrefix:@"v1"]) {
                    strUrlVersion = @"v1";
                }
            }
        }
    }
    return strUrlVersion;
}

@end
