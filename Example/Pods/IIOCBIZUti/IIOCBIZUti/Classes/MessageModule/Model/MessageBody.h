//
//  MessageBody.h
//  impcloud
//
//  Created by hctek on 16/10/24.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBody.h"

typedef NS_ENUM (NSInteger, SessionType) {
    SessionTypeNone,
    SessionTypePersonal,
    SessionTypeGroup,
    SessionTypeService,
    SessionTypeLink,
    SessionTypeFileTransfer
};

typedef NS_ENUM (NSInteger, MessageStatus) {
    //0-发送成功，1-发送失败，2-发送中 3-发送中，资源文件已上传成功 4-发送失败-资源文件已上传成功
    //5-消息已被撤回
    MessageSuccess = 0,
    MessageFailed = 1,
    MessageSending = 2,
    MessageSendingWithFileUploadSuccess = 3,
    MessageFailedWithFileUploadSuccess = 4,
    MessageRecalled = 5
};

//更改还需要在MessageBody type赋值时进行解析
typedef NS_ENUM (NSInteger, MediaType) {
    MediaTypeNone = 0,
    MediaTypeText = 1,//文本消息
    MediaTypeImage = 2,//图片消息
    MediaTypeLink = 3,//链接消息
    MediaTypeFile = 4,//文件消息
    MediaTypeComment = 5,//评论
    MediaTypeMeeting= 6,/*Meeting消息类型废弃*/
    MediaTypeActivity = 7,/*被决策卡片MediaTypeSelects消息取代*/
    MediaTypeBusinessCard = 8,//名片
    MediaTypeVoice = 9,//语音
    MediaTypeTmpVoice = 10,//发送中的语音
    MediaTypeUnknown = 11,//未知消息
    MediaTypeLocationCard = 12,//位置消息
    MediaTypeMarkDown = 13,//MarkDown
    MediaTypeSelects = 14,//决策卡片
    MediaTypeFeeds = 15//订阅卡片
};

@interface ChannelBody : BaseBody         //会话频道信息

@property (assign, nonatomic) NSInteger cid;
@property (strong, nonatomic) NSString *inputs;     //--InputSupportModel
@property (strong, nonatomic) NSString *members;
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *pyFull;
@property (strong, nonatomic) NSString *pyShort;
@property (strong, nonatomic) NSString *name;

@end

@interface BotBody : BaseBody

@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *botId;
@property (strong, nonatomic) NSString *mode;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *support;

@end

@interface MessageBody : BaseBody

/// V0使用的整形的频道id
@property (assign, nonatomic) NSInteger cid;

/// 消息Id
@property (strong, nonatomic) NSString *mid;

/// 消息体
@property (strong, nonatomic) NSString *body;

/// 发送人信息
@property (strong, nonatomic) NSString *from;

/// 消息类型
@property (assign, nonatomic) MediaType type;

/// 是否是自己发的消息
@property (assign, nonatomic) BOOL isOwner;

/// 消息时间戳
@property (assign, nonatomic) NSTimeInterval timestamp;

/// 消息发送状态
@property (assign, nonatomic) MessageStatus status;

/// 发送时时间戳，作为本地临时Id
@property (assign, nonatomic) NSTimeInterval tmpId;

/// 是否已保存到数据库
@property (assign, nonatomic) BOOL hasSaved;

/// 是否已读
@property (assign, nonatomic) BOOL read;

/// 评论消息关联的消息
@property (strong, nonatomic) MessageBody *relatedMsg;

/// 评论消息关联
@property (assign, nonatomic) BOOL isRelated;

/// 评论消息关联的消息的Id
@property (strong, nonatomic) NSString *relatedMsgMid;

///连续性标识
@property (strong, nonatomic) NSString *continuityFlag;

///撤回人的姓名
@property (strong, nonatomic) NSString *recalledName;

///是否本地已读，暂用于语音消息
@property (assign, nonatomic) BOOL localRead;

@end

@interface IIPRIVATE_MessageBodyV1 : MessageBody
/// V1所用的字符型频道id
@property (strong, nonatomic) NSString *channelId;

/// V1消息的消息体
@property (strong, nonatomic) NSDictionary *content;

/// V1消息发送人信息
@property (strong, nonatomic) NSDictionary *fromInfo;

/// 实际显示的文字
@property (strong, nonatomic) NSString *showStr;

@end

@interface IIPRIVATE_SessionBody : BaseBody        //会话列表

@property (assign, nonatomic) NSInteger cid;
//channelId是为了将频道号从整形改为string类型
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *showTitle;
@property (strong, nonatomic) NSString *peerId;
@property (assign, nonatomic) SessionType type;
@property (strong, nonatomic) NSString *icon;
@property (assign, nonatomic) NSInteger weight;
@property (assign, nonatomic) BOOL dnd;
@property (strong, nonatomic) NSString *lastUpdate;
@property (assign, nonatomic) NSTimeInterval lastReadTime;
@property (strong, nonatomic) ChannelBody *channel;
@property (assign, nonatomic) NSTimeInterval stickyTime;
@property (strong, nonatomic) IIPRIVATE_MessageBodyV1 *message;
@property (assign, nonatomic) NSInteger unread;

@property (assign, nonatomic) NSTimeInterval timestamp;
@property (assign, nonatomic) BOOL isHidden;
@property (assign, nonatomic) BOOL hasSaved;
@property (strong, nonatomic) NSArray *groupMembers;
@property (strong, nonatomic) BotBody *botInfo;
@property (assign, nonatomic) BOOL hideFlag;//用于隐藏没有Session的消息
@property (strong, nonatomic) NSString *draft;//草稿
@property (assign, nonatomic) NSTimeInterval draftTime;//草稿设置的时间
@property (strong, nonatomic) IIPRIVATE_MessageBodyV1 *lastUnsendMessage;//频道中未发送成功的最后一条消息
//新增V1频道的企业信息、状态
@property (strong, nonatomic) NSString *enterprise;
@property (strong, nonatomic) NSString *state;

//缓存中用于判定在没有消息时是否需要查库的标志位
@property (assign, nonatomic) BOOL queriedDBWhenNoMessagesInChannel;

@end
