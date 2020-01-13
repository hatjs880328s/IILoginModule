//
//  MessageDB.h
//  impcloud
//
//  Created by hctek on 16/10/24.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBody.h"

@interface MessageDB : NSObject

+ (MessageDB*)sharedInstance;

+ (NSDictionary *)formatSourceData:(NSDictionary *)source forTable:(NSString *)table;

- (void)saveSessions:(NSDictionary *)sessions;
- (NSDictionary *)loadSessions;

/**
 消息连续性标志位检测
 @param messages 新消息数组

 */
- (void)updateContinuityFlag:(NSArray *)messages;

/// 存储V0消息
- (void)saveMessagesForV0:(NSArray *)messagesV0;

/// 存储V1消息
- (void)saveMessagesInWCDB:(NSArray *)messagesV1;

/**
 查询消息
 @param message 查询早于该条消息的同频道消息(不含) 非空，没有初始消息时需传入只有频道Id的message
 @param length 最大消息条数

 @return 消息数组
 */
- (NSMutableArray *)loadMessageStartFrom:(IIPRIVATE_MessageBodyV1 *)message withLength:(NSInteger)length;

/**
 查询群图片
 @param channelId 频道Id
 @param mid 当前图片的消息Id

 @return 频道图片数组及当前图片所在位置索引 {"index": 当前位置,"messages":消息数组}
 */
- (NSDictionary *)loadMediaImageInChannel:(NSString *)channelId with:(NSString *)mid;

/**
 查询群文件
 @param channelId 频道Id
 @param mid 当前文件的消息Id

 @return 频道文件数组及当前文件所在位置索引 {"index": 当前位置,"messages":消息数组}
 */
- (NSDictionary *)loadMediaFileInChannel:(NSString *)channelId with:(NSString *)mid;

///根据消息Id查找消息
- (MessageBody *)findMessageById:(NSString *)mid;

/// 根据临时Id查找消息 
- (MessageBody *)findMessageByTmpId:(NSTimeInterval)tmpId;
/**
 根据关键字搜索指定频道的历史消息
 @param channelId 频道id
 @param keyWord   关键字
 @return          消息数组
 */
- (NSMutableArray *)findMessageByChannel:(NSString *)channelId byString:(NSString *)keyWord;

///在全频道内搜索聊天记录 返回的是每个频道下符合条件的消息数量 key:channelId value:消息数量
- (NSMutableDictionary *)findMessageByKeyword:(NSString *)keyWord;

///删除频道
- (BOOL)deleteSessionById:(NSString *)channelId;

///存储服务号列表
- (void)saveBotList:(NSMutableArray *)array;
///获取服务号列表
- (NSMutableArray *)getBotList;

///存储频道未读消息数
- (void)saveUnread:(NSMutableDictionary *)unreadDic;
///查询频道未读消息数
- (NSDictionary *)loadUnread;
///频道消息已读
- (void)readChannelMessages:(NSString *)channelId;
///根据新消息，删除对应的未发送成功的临时消息
- (void)deleteUnSendMessage:(NSArray *)messages;

/// 从数据库中根据消息的mid清除对应的消息 (本地消息的mid会根据tmpId赋值)
- (void)deleteOneMessageById:(NSString *)mid;

///获得某频道内所有的未读消息
- (NSArray *)getAllUnreadMessagesForChannel:(NSString *)channelId;
///获取某频道内最早一条未读消息
- (IIPRIVATE_MessageBodyV1 *)getFirstUnreadMessageForChannel:(NSString *)channelId;

/// 查询晚于指定消息的所有同频道消息（结果包含）
- (NSMutableArray *)loadMessageAfterMessage:(IIPRIVATE_MessageBodyV1 *)msg;

/// 分段查找数据库所有文本和评论消息
- (NSArray *)getAllTextMessagesWithLimit:(NSInteger)limit offset:(NSInteger)offset;


#pragma mark - 发送中消息相关
/// 将正在发送中的消息储存到待发送中
- (void)saveSendingMessageInWCDB:(IIPRIVATE_MessageBodyV1 *)message;

/// 返回全部的待发送消息
- (NSArray *)loadSendingMessage;

/// 清除所有待发送消息
- (void)clearSendingMessage;

/// 根据临时id移除单条发送中的消息
- (void)removeSendingMessage:(NSTimeInterval)tmpId;

/// 根据消息数组移除多条发送中的消息，传入的是收到的用于比对的消息。
- (void)removeSendingMessages:(NSArray *)receivedMessages;
@end
