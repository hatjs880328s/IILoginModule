//
//  MessageBody+WCTTableCoding.h
//  impcloud
//
//  Created by 衣凡 on 2018/10/16.
//  Copyright © 2018年 Elliot. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MessageBody.h"
#import <WCDB/WCDB.h>

@interface MessageBody (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(cid)
WCDB_PROPERTY(mid)
WCDB_PROPERTY(body)
WCDB_PROPERTY(from)
WCDB_PROPERTY(type)
WCDB_PROPERTY(isOwner)
WCDB_PROPERTY(timestamp)
WCDB_PROPERTY(status)
WCDB_PROPERTY(tmpId)
WCDB_PROPERTY(hasSaved)
WCDB_PROPERTY(relatedMsgMid)
WCDB_PROPERTY(isRelated)
WCDB_PROPERTY(read)
WCDB_PROPERTY(continuityFlag)
WCDB_PROPERTY(recalledName)

@end

@interface IIPRIVATE_MessageBodyV1 (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(cid)
WCDB_PROPERTY(channelId)
WCDB_PROPERTY(mid)
WCDB_PROPERTY(body)
WCDB_PROPERTY(from)
WCDB_PROPERTY(type)
WCDB_PROPERTY(isOwner)
WCDB_PROPERTY(timestamp)
WCDB_PROPERTY(status)
WCDB_PROPERTY(tmpId)
WCDB_PROPERTY(hasSaved)
WCDB_PROPERTY(relatedMsgMid)
WCDB_PROPERTY(isRelated)
WCDB_PROPERTY(read)
WCDB_PROPERTY(continuityFlag)
WCDB_PROPERTY(content)
WCDB_PROPERTY(showStr)
WCDB_PROPERTY(recalledName)

@end

@interface IIPRIVATE_SessionBody (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(cid)
WCDB_PROPERTY(channelId)
WCDB_PROPERTY(enterprise)
WCDB_PROPERTY(state)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(timestamp)
WCDB_PROPERTY(title)
WCDB_PROPERTY(peerId)
WCDB_PROPERTY(type)
WCDB_PROPERTY(icon)
WCDB_PROPERTY(weight)
WCDB_PROPERTY(dnd)
WCDB_PROPERTY(lastUpdate)
WCDB_PROPERTY(lastReadTime)
WCDB_PROPERTY(stickyTime)
WCDB_PROPERTY(isHidden)
WCDB_PROPERTY(channel)
WCDB_PROPERTY(message)
WCDB_PROPERTY(botInfo)
WCDB_PROPERTY(draft)
WCDB_PROPERTY(draftTime)
WCDB_PROPERTY(lastUnsendMessage)

@end

@interface ChannelBody (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(cid)
WCDB_PROPERTY(inputs)
WCDB_PROPERTY(members)
WCDB_PROPERTY(owner)
WCDB_PROPERTY(pyFull)
//WCDB_PROPERTY(pyShort)
WCDB_PROPERTY(name)

@end

@interface BotBody (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(avatar)
WCDB_PROPERTY(botId)
WCDB_PROPERTY(mode)
WCDB_PROPERTY(name)
WCDB_PROPERTY(title)
WCDB_PROPERTY(support)

@end
