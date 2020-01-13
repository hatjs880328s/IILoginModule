//
//  MessageDB.m
//  impcloud
//
//  Created by hctek on 16/10/24.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import "MessageDB.h"
#import "IIDataBase.h"
#import "MessageBody+WCTTableCoding.h"
#import "Utilities.h"
#import "TakeRouterSocketAdressClass.h"
#import "IMPCache.h"

#define WCDB_SESSION_TABLE @"Sessions"
#define WCDB_MESSAGE_TABLE @"Messages"
#define WCDB_SENDING_MESSAGE_TABLE @"SendingMessages"

@interface MessageDB () {
    FMDatabaseQueue *queue;
}

@end


@implementation MessageDB

+ (MessageDB*)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+ (NSDictionary *)formatSourceData:(NSDictionary *)source forTable:(NSString *)table {
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
    NSDictionary *references = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Cross-references.plist" ofType:nil]] objectForKey:table];
    for (NSString *key in source) {
        NSObject *value = [source objectForKey:key];

        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            value = [Utilities JSONStrFromDic:value];
        }
        if ((value == nil) || ([value isKindOfClass:[NSNull class]])) {
            continue;
        }

        NSString *orgField = nil;
        for (NSString *field in references) {
            if ([key isEqualToString:field]) {
                orgField = field;
                break;
            }
            if ([[references objectForKey:field] containsObject:key]) {
                orgField = field;
                break;
            }
        }
        if (orgField == nil) {
            continue;
        }
        [newDic setObject:value forKey:orgField];
    }
    return newDic;
}

#pragma mark - Session操作
- (void)saveSessions:(NSDictionary *)sessionsDic {
    if ([sessionsDic count] == 0) {
        return;
    }
    NSDictionary *sessions = [[NSDictionary alloc] initWithDictionary:sessionsDic];

    BOOL res = [[IIDataBase instance] createTableAndIndexesOfName:WCDB_SESSION_TABLE withClass:IIPRIVATE_SessionBody.class];
    if(!res){
        NSLog(@"创建表格%@失败！", WCDB_SESSION_TABLE);
        return ;
    }

    NSMutableArray *unSaved = [[NSMutableArray alloc] init];

    for (IIPRIVATE_SessionBody *session in [sessions allValues]) {
        if (session.hasSaved == YES || session.hideFlag == YES || session.channelId == nil) {//hideFlag标记的是没有Session的消息
            continue;
        }
        if(session.type == SessionTypeService){
            session.title = session.showTitle;
            if(session.icon == nil && session.botInfo != nil){
                session.icon = session.botInfo.avatar;
            }
        }
        //拼音
        if((session.type == SessionTypeGroup || session.type == SessionTypePersonal) && session.channel.pyFull == nil){
            NSMutableString *sessionTitle = [session.showTitle mutableCopy];
            //将汉字转换为拼音(带音标)
            CFStringTransform((__bridge CFMutableStringRef)sessionTitle, NULL, kCFStringTransformMandarinLatin, NO);
            //去掉拼音的音标
            CFStringTransform((__bridge CFMutableStringRef)sessionTitle, NULL, kCFStringTransformStripCombiningMarks, NO);

            session.channel.pyFull = [sessionTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        [unSaved addObject:session];
        session.hasSaved = YES;

    }
    if(unSaved.count > 0){
        [[IIDataBase instance] insertOrReplaceObjects:unSaved into:WCDB_SESSION_TABLE];
    }
}


- (NSDictionary *)loadSessions {

    NSMutableDictionary *sessions = [[NSMutableDictionary alloc] init];

    BOOL res = [[IIDataBase instance] createTableAndIndexesOfName:WCDB_SESSION_TABLE withClass:IIPRIVATE_SessionBody.class];
    if(!res){
        return sessions;
    }

    NSArray<IIPRIVATE_SessionBody *> *sessionList = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_SessionBody.class fromTable:WCDB_SESSION_TABLE orderBy:IIPRIVATE_SessionBody.timestamp.order()];

    for (NSInteger i = 0; i < sessionList.count; i++) {
        IIPRIVATE_SessionBody *session = sessionList[i];

        if(session.type != SessionTypePersonal){
            session.showTitle = session.title;
        }
        //v0不读取未发送消息
        if([[TakeRouterSocketAdressClass getECMUrlVersion] isEqualToString:@"v0"]) {
            session.lastUnsendMessage = nil;
        }

        if(session.lastUnsendMessage.timestamp > session.timestamp){
            session.timestamp = session.lastUnsendMessage.timestamp;
        }
        //通过数据库启动时间判断发送中的消息是否已经超时
        //        if(session.lastUnsendMessage.status == MessageSending && session.lastUnsendMessage.timestamp < [IIDataBase instance].startTime){
        //            session.lastUnsendMessage.status = MessageFailed;
        //        }else if(session.lastUnsendMessage.status == MessageSendingWithFileUploadSuccess && session.lastUnsendMessage.timestamp < [IIDataBase instance].startTime){
        //            session.lastUnsendMessage.status = MessageFailedWithFileUploadSuccess;
        //        }

        if([self messageTypeNeedUpload:session.lastUnsendMessage]){
            //对于关联文件上传操作的，如果还是文件未上传成功状态，则可确定应用重启后文件上传过程已经中断，按照文件失败处理
            if(session.lastUnsendMessage.status == MessageSending && session.lastUnsendMessage.timestamp < [IIDataBase instance].startTime){
                session.lastUnsendMessage.status = MessageFailed;//文件未上传成功
            }
            /* 会自动重发，不进行状态更改
             else if(message.status == MessageSendingWithFileUploadSuccess && message.timestamp < [IIDataBase instance].startTime){
             message.status = MessageFailedWithFileUploadSuccess;
             }*/
        }else {
            //不关联文件操作的消息类型，不改变消息状态
        }

        session.hasSaved = YES;
        [sessions setObject:session forKey:session.channelId];
    }

    return sessions;
}

- (BOOL)deleteSessionById:(NSString *)channelId {

    return [[IIDataBase instance] deleteObjectsFromTable:WCDB_SESSION_TABLE where:IIPRIVATE_SessionBody.channelId == channelId];
}

#pragma mark - Message操作
- (void)saveMessagesForV0:(NSArray *)messagesV0{
    if(messagesV0.count == 0){
        return ;
    }

    [[IMPCache sharedInstance] inDatabase:^(FMDatabase *db) {
        if (![db tableExists :@"ChatMessage"]) {           //不存在先创建
            NSString *sql = @"CREATE TABLE ChatMessage (mid TEXT, cid INTEGER, createTime DATETIME, timestamp DOUBLE, type INTEGER DEFAULT 0, `from` TEXT, body TEXT, isOwner INTEGER DEFAULT 0, status INTEGER DEFAULT 0, tmpId DOUBLE DEFAULT 0, relatedMid INTEGER DEFAULT 0, isRelated INTEGER DEFAULT 0, read INTEGER DEFAULT 0);";
            BOOL result = [db executeUpdate:sql];
            if(!result) {
                NSLog(@"创建表格ChatMessage失败！");
                [db close];
                return;
            }
        }

        NSString *sql;
        for (MessageBody *message in messagesV0) {
            if (message.hasSaved == YES || !message.mid) {
                continue;
            }
            //            if( || message.status != 0) {
            //                [unSendArray addObject:message];
            //                continue;
            //            }
            int isRelated = message.isRelated ? 1 : 0;
            long long relatedMid = 0;
            if (message.type == MediaTypeComment) {
                NSDictionary *body = (NSDictionary *)[Utilities dicFromJSONStr:message.body];
                relatedMid = [body[@"mid"] longLongValue];
            }

            sql = [NSString stringWithFormat:@"SELECT * FROM ChatMessage WHERE `isRelated` = %d and `cid` = %ld and `mid` = %@ ", isRelated , (long)message.cid, message.mid];//and `tmpId` = %f , message.tmpId
            FMResultSet *res = [db executeQuery:sql];
            if ([res next]) {
                NSString *delSql = [NSString stringWithFormat:@"DELETE FROM ChatMessage WHERE `isRelated` = %d  and `cid` = %ld and `mid` = %@ ",isRelated, (long)message.cid, message.mid];//and `tmpId` = %f,
                [db executeUpdate:delSql];
            }
            [res close];
            //去除message.body里的单引号
            NSString *body = [message.body stringByReplacingOccurrencesOfString:@"'" withString:@"''"];

            sql = [NSString stringWithFormat:@"INSERT INTO ChatMessage (`mid`, `cid`, `timestamp`, `type`, `from`, `body`, `isOwner`, `status`, `tmpId`, `isRelated`, `relatedMid`, `read`) VALUES (%@, %ld, %.f, %ld, '%@', '%@', %d, %ld, %.f, %d, %lld, %d);", message.mid, (long)message.cid, message.timestamp, (long)message.type, message.from, body, message.isOwner, (long)message.status, message.tmpId, isRelated, relatedMid, message.read ? 1:0];

            message.hasSaved = [db executeUpdate:sql];
        }
    }];
}

- (void)saveMessagesInWCDB:(NSArray *)messagesV1 {
    if(messagesV1.count == 0){
        return ;
    }

    BOOL res = [[IIDataBase instance] createTableAndIndexesOfName:WCDB_MESSAGE_TABLE withClass:IIPRIVATE_MessageBodyV1.class];//V1
    if(!res){
        NSLog(@"创建消息数据库失败");
        return ;
    }

    NSArray *copyArray = [NSArray arrayWithArray:messagesV1];

    NSMutableArray *saveMessages = [[NSMutableArray alloc] init];

    for(int i = 0; i < copyArray.count; i++){
        if(![messagesV1[i] isKindOfClass:IIPRIVATE_MessageBodyV1.class]){
            NSLog(@"待存储的消息格式不匹配！");
            continue;
        }
        IIPRIVATE_MessageBodyV1 *message = messagesV1[i];
        if (message.hasSaved == YES || (message.cid == 0 && !message.channelId)){
            continue;
        }
        //临时消息存储时其mid设置为tmpId
        if(!message.mid && message.status != 0 && message.tmpId != 0) {
            message.mid = [NSString stringWithFormat:@"%f",message.tmpId];
        }else if(!message.mid){
            continue;
        }

        message.continuityFlag = message.continuityFlag ? message.continuityFlag : message.mid;

        if(message.relatedMsg){
            message.relatedMsgMid = message.relatedMsg.mid;
        }

        message.hasSaved = YES;

        [saveMessages addObject:message];

    }
    if(saveMessages.count > 0){
        [[IIDataBase instance] insertOrReplaceObjects:saveMessages into:WCDB_MESSAGE_TABLE];
    }
}

#pragma mark 加载频道文件
- (NSDictionary *)loadMediaFileInChannel:(NSString *)channelId with:(NSString *)mid {
    if(!channelId){
        return nil;
    }
    if ([[TakeRouterSocketAdressClass getECMUrlVersion] isEqualToString:@"v0"]) {
        return [self loadMediaFileInChannelForV0:channelId with:mid];
    }else {
        return [self loadMediaFileInChannelForV1:channelId with:mid];
    }
}

- (NSDictionary *)loadMediaFileInChannelForV0:(NSString *)channelId with:(NSString *)mid {
    NSMutableArray *files = [[NSMutableArray alloc] init];
    __block NSInteger atIndex;
    [[IMPCache sharedInstance] inDatabase:^(FMDatabase *db) {
        if ([db tableExists :@"ChatMessage"]) {
            NSString  *sql = [NSString stringWithFormat: @"SELECT * FROM `ChatMessage` WHERE isRelated = 0 AND cid = %@ AND type = '4' GROUP BY `mid` ORDER BY timestamp DESC", channelId];
            int count = 0;
            FMResultSet *res = [db executeQuery:sql];
            while ([res next]) {
                //待精简 不需要相关消息
                MessageBody *message = [[MessageBody alloc] init];
                message.mid = [res stringForColumn:@"mid"];
                message.cid = [res longForColumn:@"cid"];
                message.timestamp = [res doubleForColumn:@"timestamp"];
                message.type = (MediaType)[res longForColumn:@"type"];
                message.from = [res stringForColumn:@"from"];
                message.body = [[res stringForColumn:@"body"] isEqualToString:@"(null)"] ? nil : [res stringForColumn:@"body"];
                message.isOwner = [res boolForColumn:@"isOwner"];
                message.status = MessageStatus([res longForColumn:@"status"]);
                message.tmpId = [res doubleForColumn:@"tmpId"];
                message.hasSaved = YES;

                [files addObject:message];
                if ([message.mid isEqualToString:mid]) {
                    atIndex = count;
                }
                count++;
            }
            [res close];
        }
    }];
    return @{@"index": [NSNumber numberWithInteger:atIndex], @"messages":files};
}

- (NSDictionary *)loadMediaFileInChannelForV1:(NSString *)channelId with:(NSString *)mid {

    NSArray<IIPRIVATE_MessageBodyV1 *> *files = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:IIPRIVATE_MessageBodyV1.isRelated == 0 && IIPRIVATE_MessageBodyV1.channelId == channelId && IIPRIVATE_MessageBodyV1.type == 4 && IIPRIVATE_MessageBodyV1.status == 0 && IIPRIVATE_MessageBodyV1.recalledName.isNull() orderBy:IIPRIVATE_MessageBodyV1.timestamp.order(WCTOrderedDescending)];
    if(files == nil) {
        files = [[NSArray alloc] init];
    }
    int count = 0;
    NSInteger atIndex = 0;
    for(IIPRIVATE_MessageBodyV1 *fileMessage in files){

        if ([fileMessage.mid isEqualToString:mid]) {
            atIndex = count;
        }
        count++;
    }

    return @{@"index": [NSNumber numberWithInteger:atIndex], @"messages":files};
}

#pragma mark 加载频道图片
- (NSDictionary *)loadMediaImageInChannel:(NSString *)channelId with:(NSString *)mid {
    if(!channelId){
        return nil;
    }
    if ([[TakeRouterSocketAdressClass getECMUrlVersion] isEqualToString:@"v0"]) {
        return [self loadMediaImageInChannelForV0:channelId with:mid];
    }else {
        return [self loadMediaImageInChannelForV1:channelId with:mid];
    }
}

- (NSDictionary *)loadMediaImageInChannelForV0:(NSString *)channelId with:(NSString *)mid {
    if (!channelId) {
        return nil;
    }
    NSMutableArray *images = [[NSMutableArray alloc] init];
    __block NSInteger atIndex = 0;//找不到的话会返回0（如本地消息）
    [[IMPCache sharedInstance] inDatabase:^(FMDatabase *db) {
        if ([db tableExists :@"ChatMessage"]) {
            NSString  *sql = [NSString stringWithFormat: @"SELECT * FROM `ChatMessage` WHERE isRelated = 0 AND cid = %@ AND type = '2' GROUP BY `mid` ORDER BY timestamp ASC", channelId];
            int count = 0;
            FMResultSet *res = [db executeQuery:sql];
            while ([res next]) {

                MessageBody *message = [[MessageBody alloc] init];
                message.mid = [res stringForColumn:@"mid"];
                message.cid = [res longForColumn:@"cid"];
                message.timestamp = [res doubleForColumn:@"timestamp"];
                message.type = (MediaType)[res longForColumn:@"type"];
                message.from = [res stringForColumn:@"from"];
                message.body = [[res stringForColumn:@"body"] isEqualToString:@"(null)"] ? nil : [res stringForColumn:@"body"];
                message.isOwner = [res boolForColumn:@"isOwner"];
                message.status = MessageStatus([res longForColumn:@"status"]);
                message.tmpId = [res doubleForColumn:@"tmpId"];
                message.hasSaved = YES;

                long long relatedMid = [res longLongIntForColumn:@"relatedMid"];
                if (relatedMid > 0) {
                    if ([db tableExists :@"ChatMessage"]) {
                        sql = [NSString stringWithFormat:@"SELECT * FROM `ChatMessage` WHERE mid = %lld and isRelated = 1", relatedMid];
                        FMResultSet *msgRes = [db executeQuery:sql];
                        if ([msgRes next]) {
                            MessageBody *rMessage = [[MessageBody alloc] init];
                            rMessage.mid = [msgRes stringForColumn:@"mid"];
                            rMessage.cid = [msgRes longForColumn:@"cid"];
                            rMessage.timestamp = [msgRes doubleForColumn:@"timestamp"];
                            rMessage.type = (MediaType)[msgRes longForColumn:@"type"];
                            rMessage.from = [msgRes stringForColumn:@"from"];
                            rMessage.body = [[msgRes stringForColumn:@"body"] isEqualToString:@"(null)"] ? nil : [msgRes stringForColumn:@"body"];
                            rMessage.isOwner = [msgRes boolForColumn:@"isOwner"];
                            rMessage.status = MessageStatus([msgRes longForColumn:@"status"]);
                            rMessage.tmpId = [msgRes doubleForColumn:@"tmpId"];
                            message.relatedMsg = rMessage;
                        }
                        [msgRes close];
                    }
                }

                [images addObject:message];
                if ([message.mid isEqualToString:mid]) {
                    atIndex = count;
                }
                count++;
            }
            [res close];
        }
    }];

    return @{@"index": [NSNumber numberWithInteger:atIndex], @"messages":images};
}

- (NSDictionary *)loadMediaImageInChannelForV1:(NSString *)channelId with:(NSString *)mid {

    NSArray<IIPRIVATE_MessageBodyV1 *> *images = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:IIPRIVATE_MessageBodyV1.isRelated == 0 && IIPRIVATE_MessageBodyV1.channelId == channelId && IIPRIVATE_MessageBodyV1.type == 2 && IIPRIVATE_MessageBodyV1.status == 0 && IIPRIVATE_MessageBodyV1.recalledName.isNull() orderBy:IIPRIVATE_MessageBodyV1.timestamp.order(WCTOrderedAscending)];
    if(images == nil) {
        images = [[NSArray alloc] init];
    }
    int count = 0;
    NSInteger atIndex = 0;

    for(IIPRIVATE_MessageBodyV1 *imageMessage in images){
        if ([imageMessage.mid isEqualToString:mid]) {
            atIndex = count;
        }
        count++;
    }
    return @{@"index": [NSNumber numberWithInteger:atIndex], @"messages":images};
}

#pragma mark - 本地频道查询操作
- (NSMutableArray *)loadMessageStartFrom:(IIPRIVATE_MessageBodyV1 *)msg withLength:(NSInteger)length {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (msg == nil)
        return result;

    if (![msg isKindOfClass:IIPRIVATE_MessageBodyV1.class]) {
        return result;
    }
    NSArray<IIPRIVATE_MessageBodyV1 *> *messageList;

    if(msg.timestamp > 0){

        if(msg.continuityFlag) {
            //检索时间小于请求消息的，数量为传入的数量；并且查询所有与当前消息时间戳相同的消息
            NSArray *sqlList = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.channelId == msg.channelId && IIPRIVATE_MessageBodyV1.isRelated == 0 && IIPRIVATE_MessageBodyV1.continuityFlag == msg.continuityFlag && IIPRIVATE_MessageBodyV1.timestamp < msg.timestamp) orderBy:{IIPRIVATE_MessageBodyV1.timestamp.order(WCTOrderedDescending),  IIPRIVATE_MessageBodyV1.mid.order(WCTOrderedDescending)} limit:length];
            NSArray *allSameTime = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.channelId == msg.channelId && IIPRIVATE_MessageBodyV1.isRelated == 0 && IIPRIVATE_MessageBodyV1.continuityFlag == msg.continuityFlag && IIPRIVATE_MessageBodyV1.timestamp == msg.timestamp) orderBy:  IIPRIVATE_MessageBodyV1.mid.order(WCTOrderedDescending)];

            NSMutableArray *list = [NSMutableArray arrayWithArray:allSameTime];
            [list addObjectsFromArray:sqlList];
            messageList = list;
        }else {
            //无视消息断层进行离线查询
            NSArray *sqlList = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.channelId == msg.channelId && IIPRIVATE_MessageBodyV1.isRelated == 0 && IIPRIVATE_MessageBodyV1.timestamp < msg.timestamp) orderBy:{IIPRIVATE_MessageBodyV1.timestamp.order(WCTOrderedDescending),  IIPRIVATE_MessageBodyV1.mid.order(WCTOrderedDescending)} limit:length];

            NSArray *allSameTime = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.channelId == msg.channelId && IIPRIVATE_MessageBodyV1.isRelated == 0 && IIPRIVATE_MessageBodyV1.timestamp == msg.timestamp) orderBy:  IIPRIVATE_MessageBodyV1.mid.order(WCTOrderedDescending)];
            NSMutableArray *list = [NSMutableArray arrayWithArray:allSameTime];
            [list addObjectsFromArray:sqlList];
            messageList = list;
        }

    }else {
        //频道原先无消息时会传入一个只有cid的msg
        messageList = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.channelId == msg.channelId && IIPRIVATE_MessageBodyV1.isRelated == 0) orderBy:IIPRIVATE_MessageBodyV1.mid.order(WCTOrderedDescending) limit:length];
    }

    for(IIPRIVATE_MessageBodyV1 *message in messageList){
        if(message.relatedMsgMid && ![message.relatedMsgMid isEqualToString:@""]){

            message.relatedMsg = [self findMessageById:message.relatedMsgMid];
        }
        // 记录一个数据库启动时间，对于需要上传文件的消息类型， 如果消息的时间早于数据库启动时间，则强制置为失败状态
        //消息状态 判断发送中的消息是否已经超时
        if([self messageTypeNeedUpload:message]){
            //对于关联文件上传操作的，如果还是文件未上传成功状态，则可确定应用重启后文件上传过程已经中断，按照文件失败处理
            if(message.status == MessageSending && message.timestamp < [IIDataBase instance].startTime){
                message.status = MessageFailed;//文件未上传成功
            }
            /* 会自动重发，不进行状态更改
             else if(message.status == MessageSendingWithFileUploadSuccess && message.timestamp < [IIDataBase instance].startTime){
             message.status = MessageFailedWithFileUploadSuccess;
             }*/
        }else {
            //不关联文件操作的消息类型，不改变消息状态
        }

        [result addObject:message];
    }
    return result;
}

- (NSMutableArray *)loadMessageAfterMessage:(IIPRIVATE_MessageBodyV1 *)msg {
    if(msg == nil){
        return nil;
    }
    NSArray *messageList = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.channelId == msg.channelId && IIPRIVATE_MessageBodyV1.timestamp >= msg.timestamp) orderBy:IIPRIVATE_MessageBodyV1.timestamp.order(WCTOrderedDescending)];
    return [[NSMutableArray alloc] initWithArray:messageList];
}

#pragma mark - 搜索Message操作
- (MessageBody *)findMessageById:(NSString *)mid {

    IIPRIVATE_MessageBodyV1 *relatedMsg = [[IIDataBase instance] getOneObjectOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:IIPRIVATE_MessageBodyV1.mid == mid];

    return relatedMsg;
}

- (MessageBody *)findMessageByTmpId:(NSTimeInterval)tmpId {

    IIPRIVATE_MessageBodyV1 *relatedMsg = [[IIDataBase instance] getOneObjectOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:IIPRIVATE_MessageBodyV1.tmpId == tmpId];

    return relatedMsg;
}

- (NSMutableArray *)findMessageByChannel:(NSString *)channelId byString:(NSString *)keyWord{
    if(keyWord.length < 1){
        return [[NSMutableArray alloc] init];
    }
    NSString *realKey = [self replaceSQLSpecialChar:keyWord];

    // like %keyword%, %需要在前面加%进行转义
    NSString *textWhere = [NSString stringWithFormat:@"%%%@%%", realKey];

    NSString *escapeSql = @"/";

    NSArray *messageList = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.channelId == channelId && IIPRIVATE_MessageBodyV1.recalledName.isNull() && (IIPRIVATE_MessageBodyV1.type == MediaTypeText || IIPRIVATE_MessageBodyV1.type == MediaTypeComment) && IIPRIVATE_MessageBodyV1.showStr.like(textWhere, escapeSql)) orderBy:IIPRIVATE_MessageBodyV1.timestamp.order()];

    //&& IIPRIVATE_MessageBodyV1.recalledName == @""
    return [[NSMutableArray alloc] initWithArray:messageList];
}

///在全频道内搜索聊天记录
- (NSMutableDictionary *)findMessageByKeyword:(NSString *)keyWord {
    //应当只搜索出条数即可,只查询满足条件的channelId
    if(keyWord.length < 1){
        return [[NSMutableDictionary alloc] init];
    }
    NSString *realKey = [self replaceSQLSpecialChar:keyWord];
    NSString *textWhere = [NSString stringWithFormat:@"%%%@%%", realKey];
    NSString *escapeSql = @"/";

    //查找出全部符合要求的消息的channelId
    NSArray *channelIdList = [[IIDataBase instance] getOneColumnOnResult:IIPRIVATE_MessageBodyV1.channelId fromTable:WCDB_MESSAGE_TABLE where:((IIPRIVATE_MessageBodyV1.type == MediaTypeText || IIPRIVATE_MessageBodyV1.type == MediaTypeComment) && IIPRIVATE_MessageBodyV1.recalledName.isNull() &&  IIPRIVATE_MessageBodyV1.showStr.like(textWhere, escapeSql)) orderBy:IIPRIVATE_MessageBodyV1.timestamp.order()];

    NSMutableDictionary *channelMsgNum = [[NSMutableDictionary alloc] init];
    for(NSString *channelId in channelIdList){
        if(channelMsgNum[channelId]){
            NSInteger count = [channelMsgNum[channelId] integerValue] + 1;
            NSNumber *countNumber = [NSNumber numberWithInteger:count];
            [channelMsgNum setObject:countNumber forKey:channelId];
        }else {
            [channelMsgNum setObject:[NSNumber numberWithInteger:1] forKey:channelId];
        }
    }
    return channelMsgNum;
}

- (void)saveBotList:(NSMutableArray *)botArray {
    if ([botArray count] == 0) {
        return;
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:botArray];
    [[IMPCache sharedInstance] inDatabase:^(FMDatabase *db) {
        if (![db tableExists :@"BotList"]) {
            NSString *sql = @"CREATE TABLE BotList (avatar varchar(255), botId varchar(255), mode varchar(16), name varchar(255), title varchar(255), support varchar(255));";
            BOOL result = [db executeUpdate:sql];
            if(!result) {
                NSLog(@"创建表格BotList失败！");
                [db close];
                return;
            }
        }

        //清空之前的BotList
        NSString *delSql = [NSString stringWithFormat:@"DELETE FROM BotList"];
        [db executeUpdate:delSql];

        NSString *sql;
        for (BotBody *bot in array) {
            /*bot.mode = bot.mode?bot.mode:@"";*/

            sql = [NSString stringWithFormat:@"INSERT INTO BotList (`avatar`, `botId`, `mode`, `name`, `title`, `support`) VALUES ('%@', '%@','%@', '%@','%@', '%@');", bot.avatar,bot.botId,bot.mode,bot.name,bot.title,bot.support];

            [db executeUpdate:sql];
        }
    }];
}

- (NSMutableArray *)getBotList {

    NSMutableArray *botList = [[NSMutableArray alloc] init];

    [[IMPCache sharedInstance] inDatabase:^(FMDatabase *db) {
        if ([db tableExists :@"BotList"]) {
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM BotList"];
            FMResultSet *res = [db executeQuery:sql];

            while ([res next]) {
                BotBody *bot = [[BotBody alloc] init];

                bot.avatar = [res stringForColumn:@"avatar"];
                bot.botId = [res stringForColumn:@"botId"];
                bot.mode = [res stringForColumn:@"mode"];
                bot.name = [res stringForColumn:@"name"];
                bot.title = [res stringForColumn:@"title"];
                bot.support = [res stringForColumn:@"support"];

                [botList addObject:bot];
            }
            [res close];
        }
    }];

    return botList;
}

- (void)saveUnread:(NSMutableDictionary *)unreadDictionary{
    if ([unreadDictionary count] == 0) {
        return;
    }
    //拷贝待存储的数据用于数据库操作
    NSMutableDictionary *unreadDic = [unreadDictionary mutableCopy];

    [[IMPCache sharedInstance] inDatabase:^(FMDatabase *db) {
        if (![db tableExists :@"UnreadList"]) {
            NSString *sql = @"CREATE TABLE UnreadList (cid varchar(255), unread INTEGER DEFAULT 0);";
            BOOL result = [db executeUpdate:sql];
            if(!result) {
                NSLog(@"创建表格UnreadList失败！");
                [db close];
                return;
            }
        }
        //清空之前
        NSString *delSql = [NSString stringWithFormat:@"DELETE FROM UnreadList"];
        [db executeUpdate:delSql];

        NSString *sql;
        for (NSString *key in unreadDic) {
            /*bot.mode = bot.mode?bot.mode:@"";*/

            sql = [NSString stringWithFormat:@"INSERT INTO UnreadList (`cid`, `unread`) VALUES ('%@', '%ld');",key, (long)[unreadDic[key] integerValue]];

            [db executeUpdate:sql];
        }
    }];
}

- (NSDictionary *)loadUnread {
    NSMutableDictionary *unread = [[NSMutableDictionary alloc] init];

    [[IMPCache sharedInstance] inDatabase:^(FMDatabase *db) {
        if ([db tableExists :@"UnreadList"]) {
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM UnreadList"];
            FMResultSet *res = [db executeQuery:sql];

            while ([res next]) {
                NSString *key = [res stringForColumn:@"cid"];

                NSInteger value = [res intForColumn:@"unread"];

                [unread setObject:[NSNumber numberWithInteger:value] forKey:key];
            }
            [res close];
        }
    }];

    return unread;
}

- (void)readChannelMessages:(NSString *)channelId {
    IIPRIVATE_MessageBodyV1 *tmp = [[IIPRIVATE_MessageBodyV1 alloc] init];
    tmp.channelId = channelId;
    tmp.read = 1;

    [[IIDataBase instance] updateRowsInTable:WCDB_MESSAGE_TABLE onProperty:IIPRIVATE_MessageBodyV1.read withObject:tmp where:(IIPRIVATE_MessageBodyV1.read == 0 && IIPRIVATE_MessageBodyV1.channelId == channelId)];

    [[IMPCache sharedInstance] inDatabase:^(FMDatabase *db) {
        if ([db tableExists :@"UnreadList"]) {
            NSString *sql = [NSString stringWithFormat:@"UPDATE UnreadList SET `unread` = 0 WHERE `cid` = '%@';",channelId];
            [db executeUpdate:sql];

        }
    }];
}

/// 删除消息
- (void)deleteOneMessageById:(NSString *)mid {
    [[IIDataBase instance] deleteObjectsFromTable:WCDB_MESSAGE_TABLE where:IIPRIVATE_MessageBodyV1.mid == mid];
}

/// 用正式消息清除发送中消息
- (void)deleteUnSendMessage:(NSArray *)messages{
    NSMutableArray *msgTmpIds = [[NSMutableArray alloc] init];
    for(IIPRIVATE_MessageBodyV1 *message in messages){
        if([message isKindOfClass:IIPRIVATE_MessageBodyV1.class] && message.status == 0 && message.tmpId > 0 && message.isOwner){
            [msgTmpIds addObject:[NSNumber numberWithInteger:message.tmpId]];
        }
    }
    if(msgTmpIds.count > 0){
        [[IIDataBase instance] deleteObjectsFromTable:WCDB_MESSAGE_TABLE where: IIPRIVATE_MessageBodyV1.status > 0 && IIPRIVATE_MessageBodyV1.tmpId.in(msgTmpIds)];
    }
}

//连续性检测 对接新旧flag
- (void)updateContinuityFlag:(NSArray *)messages {
    if(messages.count == 0 || [[TakeRouterSocketAdressClass getECMUrlVersion] isEqualToString:@"v0"]){
        return ;
    }
    IIPRIVATE_MessageBodyV1 *message = [messages lastObject];

    IIPRIVATE_MessageBodyV1 *flagObj = [[IIDataBase instance] getOneObjectOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:IIPRIVATE_MessageBodyV1.mid == message.mid && IIPRIVATE_MessageBodyV1.continuityFlag != message.continuityFlag];

    NSString *flag = flagObj.continuityFlag;

    if(flag){
        NSString *arrayFlag = message.continuityFlag;

        //按照老的flag更新，同时更改数组里的值
        [[IIDataBase instance] updateRowsInTable:WCDB_MESSAGE_TABLE onProperty:IIPRIVATE_MessageBodyV1.continuityFlag withObject:flagObj where:IIPRIVATE_MessageBodyV1.continuityFlag == arrayFlag];

        for(IIPRIVATE_MessageBodyV1 *msg in messages){
            msg.continuityFlag = flag;
        }
    }

    IIPRIVATE_MessageBodyV1 *firstMsg = [messages firstObject];
    //新增:更新连续时间内未发送消息的连续性标识
    [[IIDataBase instance] updateRowsInTable:WCDB_MESSAGE_TABLE onProperty:IIPRIVATE_MessageBodyV1.continuityFlag withObject:firstMsg where:IIPRIVATE_MessageBodyV1.status > 0 && IIPRIVATE_MessageBodyV1.timestamp > message.timestamp && IIPRIVATE_MessageBodyV1.timestamp < firstMsg.timestamp];
}

- (IIPRIVATE_MessageBodyV1 *)getFirstUnreadMessageForChannel:(NSString *)channelId {
    IIPRIVATE_MessageBodyV1 *firstUnread = [[[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.channelId == channelId && IIPRIVATE_MessageBodyV1.read == 0) orderBy:IIPRIVATE_MessageBodyV1.timestamp.order() limit:1] firstObject];
    return firstUnread;
}

- (NSArray *)getAllUnreadMessagesForChannel:(NSString *)channelId {
    NSArray<IIPRIVATE_MessageBodyV1 *> *messageList = [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.channelId == channelId && IIPRIVATE_MessageBodyV1.read == 0) orderBy:IIPRIVATE_MessageBodyV1.timestamp.order()];
    return messageList;
}

/// 分段查找数据库所有文本和评论消息
- (NSArray *)getAllTextMessagesWithLimit:(NSInteger)limit offset:(NSInteger)offset {
    BOOL res = [[IIDataBase instance] createTableAndIndexesOfName:WCDB_MESSAGE_TABLE withClass:IIPRIVATE_MessageBodyV1.class];//V1
    if(!res){
        NSLog(@"创建消息数据库失败");
        return [NSArray array];
    }
    return [[IIDataBase instance] getObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_MESSAGE_TABLE where:(IIPRIVATE_MessageBodyV1.type == MediaTypeText || IIPRIVATE_MessageBodyV1.type == MediaTypeComment) orderBy:IIPRIVATE_MessageBodyV1.mid.order() limit:limit offset:offset];
}

- (NSString *)replaceSQLSpecialChar:(NSString *)modifiedString{
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@")" withString:@"/)"];

    return modifiedString;
}

#pragma mark - 发送中消息相关

- (BOOL)createSendingMessageTable {
    BOOL res = [[IIDataBase instance] createTableAndIndexesOfName:WCDB_SENDING_MESSAGE_TABLE withClass:IIPRIVATE_MessageBodyV1.class];
    if(!res){
        NSLog(@"创建表格%@失败！", WCDB_SENDING_MESSAGE_TABLE);
        return NO;
    }
    return YES;
}

/// 将正在发送中的消息储存到待发送中
- (void)saveSendingMessageInWCDB:(IIPRIVATE_MessageBodyV1 *)message {
    if(message == nil){
        return ;
    }
    BOOL createTable = [self createSendingMessageTable];
    if(!createTable){
        return ;
    }
    [[IIDataBase instance] insertOrReplaceObject:message into:WCDB_SENDING_MESSAGE_TABLE];

}

/// 返回全部的待发送消息
- (NSArray *)loadSendingMessage {
    BOOL createTable = [self createSendingMessageTable];
    if(!createTable){
        return [[NSArray alloc] init];
    }

    return [[IIDataBase instance] getAllObjectsOfClass:IIPRIVATE_MessageBodyV1.class fromTable:WCDB_SENDING_MESSAGE_TABLE];
}

/// 清除所有待发送消息
- (void)clearSendingMessage {
    BOOL createTable = [self createSendingMessageTable];
    if(!createTable){
        return ;
    }
    [[IIDataBase instance] deleteAllObjectsFromTable:WCDB_SENDING_MESSAGE_TABLE];
}

/// 根据id移除单条发送中的消息
- (void)removeSendingMessage:(NSTimeInterval)tmpId {
    BOOL createTable = [self createSendingMessageTable];
    if(!createTable){
        return ;
    }
    [[IIDataBase instance] deleteObjectsFromTable:WCDB_SENDING_MESSAGE_TABLE where:IIPRIVATE_MessageBodyV1.tmpId == tmpId];
}

- (void)removeSendingMessages:(NSArray *)receivedMessages {

    BOOL createTable = [self createSendingMessageTable];
    if(!createTable){
        return ;
    }

    NSMutableArray *msgTmpIds = [[NSMutableArray alloc] init];
    for(IIPRIVATE_MessageBodyV1 *message in receivedMessages){
        if([message isKindOfClass:IIPRIVATE_MessageBodyV1.class] && message.status == 0 && message.tmpId > 0 && message.isOwner){
            [msgTmpIds addObject:[NSNumber numberWithInteger:message.tmpId]];
        }
    }
    if(msgTmpIds.count > 0){
        [[IIDataBase instance] deleteObjectsFromTable:WCDB_SENDING_MESSAGE_TABLE where: IIPRIVATE_MessageBodyV1.status > 0 && IIPRIVATE_MessageBodyV1.tmpId.in(msgTmpIds)];
    }
}

- (BOOL)messageTypeNeedUpload:(IIPRIVATE_MessageBodyV1 *)message{
    switch (message.type) {
        case MediaTypeFile:case MediaTypeImage:case MediaTypeVoice:case MediaTypeTmpVoice:case MediaTypeLocationCard:
            return YES;
        default:
            return NO;
    }
}


@end


