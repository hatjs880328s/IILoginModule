//
//  MessageBody.m
//  impcloud
//
//  Created by hctek on 16/10/24.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import "MessageBody.h"
#import "MessageBody+WCTTableCoding.h"
#import "Utilities.h"
#import "IMPUserModel.h"
#import "GlobalAction.h"

@implementation ChannelBody

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {
    if ([key isEqualToString:@"channelMembers"]) {
        _members = value;
    }
    if ([key isEqualToString:@"channelId"]) {
        _cid = [value integerValue];
    }
}

@end

@implementation IIPRIVATE_SessionBody

WCDB_IMPLEMENTATION(IIPRIVATE_SessionBody)

WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, cid)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, channelId)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, enterprise)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, state)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, createTime)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, timestamp)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, title)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, peerId)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, type)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, icon)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, weight)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, dnd)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, lastUpdate)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, lastReadTime)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, stickyTime)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, isHidden)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, channel)//channel原先fmdb没有
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, message)//message原先没有
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, botInfo)//botInfo原先没有
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, draft)//新增草稿
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, draftTime)
WCDB_SYNTHESIZE(IIPRIVATE_SessionBody, lastUnsendMessage)

WCDB_PRIMARY(IIPRIVATE_SessionBody, channelId)

- (void)setValue:(id)value forKey:(NSString *)key {

    if ([key isEqualToString:@"type"]) {
        if ([value isEqualToString:@"DIRECT"]) {
            _type = SessionTypePersonal;
        }else if ([value isEqualToString:@"GROUP"]) {
            _type = SessionTypeGroup;
        }else if ([value isEqualToString:@"SERVICE"] || [value isEqualToString:@"CAST"]) {
            _type = SessionTypeService;
        }else if([value isEqualToString:@"LINK"]){
            _type = SessionTypeLink;
        }else if([value isEqualToString:@"FILE_TRANSFER"]){
            _type = SessionTypeFileTransfer;
        }

        if (_title != nil) {
            [self setValue:_title forKey:@"title"];
        }

        return;
    }

    if ([key isEqualToString:@"title"] || [key isEqualToString:@"name"]) {//name是为了兼容V1频道的channel信息
        _title = value;
        if (_type == SessionTypeNone) {
            return;//在没有赋值类型之前，不进行标题的赋值
        }
        if (_type == SessionTypeGroup || _type == SessionTypeLink || _type == SessionTypeFileTransfer) {
            _showTitle = value;
        } else {
            NSString *owner = [[IMPUserModel activeInstance] exeofidString];
            //IMPUserModel改造前可能会由于[IMPUserModel activeInstance]为空而导致owner为空，做一次额外的判断
            if(owner != nil){
                NSRange r = [_title rangeOfString:owner];
                if (r.location == 0) {
                    _peerId = [[_title componentsSeparatedByString:@"-"] objectAtIndex:1];
                }
                else {
                    _peerId = [[_title componentsSeparatedByString:@"-"] objectAtIndex:0];
                }
            }
        }

        return;
    }
    /*
     if ([key isEqualToString:@"peerId"]) {
     _peerId = value;
     return;
     }*/

    if ([key isEqualToString:@"lastUpdate"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSTimeInterval time = [[dateFormatter dateFromString:value] timeIntervalSince1970];
        if(time > _timestamp) {
            _timestamp = time;
        }
    }

    if ([key isEqualToString:@"message"]) {
        MessageBody *message = value;
        //设置正式消息时，清除原先发送中状态的消息
        if(_lastUnsendMessage != nil && _lastUnsendMessage.tmpId == message.tmpId) {
            _lastUnsendMessage = nil;
        }
        if (message.timestamp > _timestamp) {
            _timestamp = message.timestamp;
            _isHidden = NO;
        }
    }

    if ([key isEqualToString:@"lastUnsendMessage"]){
        IIPRIVATE_MessageBodyV1 *unsendMessage = value;
        if(unsendMessage.timestamp > _timestamp){
            _timestamp = unsendMessage.timestamp;
        }
    }

    if([key isEqualToString:@"cid"]){
        _cid = [value integerValue];
        if(_cid != 0 && _channelId == nil){
            _channelId = [NSString stringWithFormat:@"%@", value];
        }
        return ;
    }
    //channelV1
    if ([key isEqualToString:@"channelId"]){
        _channelId = value;
        _cid = [value integerValue];
        return;
    }
    if ([key isEqualToString:@"dnd"]){
        if([value integerValue] == 0){
            _dnd = FALSE;
        }else {
            _dnd = TRUE;
        }
        return ;
    }
    if ([key isEqualToString:@"hide"]){
        if([value integerValue] == 0){
            _isHidden = FALSE;
        }else {
            _isHidden = TRUE;
        }
        return;
    }
    if ([key isEqualToString:@"stick"]){
        if([value integerValue] == 0){
            _stickyTime = 0;
        }else {
            _stickyTime = [value floatValue];
        }
        return;
    }
    //针对SessionTypeLink
    if([key isEqualToString:@"action"]){
        NSDictionary *actionDic = (NSDictionary *)[Utilities dicFromJSONStr:value];
        if(actionDic != nil){
            //使用Session的message.content存储行为
            IIPRIVATE_MessageBodyV1 *actionMessage = [[IIPRIVATE_MessageBodyV1 alloc] init];
            actionMessage.channelId = _channelId;
            actionMessage.cid = _cid;
            actionMessage.mid = [NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000];
            actionMessage.content = actionDic;
            _message = actionMessage;
        }
    }
    //针对SessionTypeLink、SessionTypeFileTransfer
    if([key isEqualToString:@"avatar"]){
        _icon = value;
    }

    _hasSaved = NO;

    [super setValue:value forKey:key];
}

@end

@implementation MessageBody

WCDB_IMPLEMENTATION(MessageBody)

WCDB_SYNTHESIZE(MessageBody, cid)
WCDB_SYNTHESIZE(MessageBody, mid)
WCDB_SYNTHESIZE(MessageBody, body)
WCDB_SYNTHESIZE_COLUMN(MessageBody, from, "db_from")
WCDB_SYNTHESIZE(MessageBody, type)
WCDB_SYNTHESIZE(MessageBody, isOwner)
WCDB_SYNTHESIZE(MessageBody, timestamp)
WCDB_SYNTHESIZE(MessageBody, status)
WCDB_SYNTHESIZE(MessageBody, tmpId)
WCDB_SYNTHESIZE(MessageBody, hasSaved)
WCDB_SYNTHESIZE(MessageBody, relatedMsgMid)
WCDB_SYNTHESIZE(MessageBody, isRelated)
WCDB_SYNTHESIZE(MessageBody, read)
WCDB_SYNTHESIZE(MessageBody, continuityFlag)
WCDB_SYNTHESIZE(MessageBody, recalledName)

WCDB_PRIMARY(MessageBody, mid)

- (void)setValue:(id)value forKey:(nonnull NSString *)key {
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"type"]) {
        if (_type != MediaTypeNone) {
            return;
        }
        if ([value isEqualToString:@"txt_rich"] || [value isEqualToString:@"text"] || [value isEqualToString:@"1"]) {
            _type = MediaTypeText;
        }
        else if ([value isEqualToString:@"attachment/card"] || [value isEqualToString:@"8"]) {
            _type = MediaTypeBusinessCard;
        }
        else if ([value isEqualToString:@"res_image"] || [value isEqualToString:@"image"] || [value isEqualToString:@"2"]) {
            _type = MediaTypeImage;
        }
        else if ([value isEqualToString:@"res_link"] || [value isEqualToString:@"link"] || [value isEqualToString:@"extended/links"] || [value isEqualToString:@"3"]) {
            _type = MediaTypeLink;
        }
        else if ([value isEqualToString:@"res_file"] || [value isEqualToString:@"file"] || [value isEqualToString:@"4"]) {
            _type = MediaTypeFile;
        }
        else if ([value rangeOfString:@"act_meeting"].length == 11 || [value isEqualToString:@"6"]) {
            _type = MediaTypeMeeting;
        }
        else if ([value isEqualToString:@"txt_comment"] || [value isEqualToString:@"5"]) {
            _type = MediaTypeComment;
        }else if ([value isEqualToString:@"7"]) {
            _type = MediaTypeActivity;
        }else if ([value isEqualToString:@"9"]) {
            _type = MediaTypeVoice;
        }else if ([value isEqualToString:@"10"]) {
            _type = MediaTypeTmpVoice;
        }else if ([value isEqualToString:@"12"]) {
            _type = MediaTypeLocationCard;
        }else if([value isEqualToString:@"14"]){
            _type = MediaTypeSelects;
        }else if([value isEqualToString:@"15"]){
            _type = MediaTypeFeeds;
        }else {
            _type = MediaTypeUnknown;
        }
        return;
    }

    if ([key isEqualToString:@"id"]) {
        _mid = value;

        return;
    }

    if ([key isEqualToString:@"body"]) {
        NSMutableDictionary *bodyDic = (NSMutableDictionary *)[Utilities dicFromJSONStr:value];
        if (bodyDic[@"extras"] && [bodyDic[@"extras"] isKindOfClass:[NSDictionary class]] && [bodyDic[@"extras"][@"props"] isKindOfClass:[NSDictionary class]] && bodyDic[@"extras"][@"props"][@"data"]) {
            NSDictionary *newMsg = (NSDictionary *)[Utilities dicFromJSONStr:bodyDic[@"extras"][@"props"][@"data"]];
            //yifan TODO 判断isOwner时用到的IMPUserModel
            if ([newMsg[@"from"][@"user"] integerValue] == [[[IMPUserModel activeInstance] exeofidString] integerValue]) {
                _isOwner = YES;
            }
            else {
                _isOwner = NO;
            }
            if ([newMsg[@"type"] isEqualToString:@"extended/actions"]) {
                _type = MediaTypeActivity;
            }
            if([newMsg[@"type"] isEqualToString:@"experimental/selects"]){
                _type = MediaTypeSelects;
            }
            if([newMsg[@"type"] isEqualToString:@"experimental/feeds"]){
                _type = MediaTypeFeeds;
            }

            if ([newMsg[@"type"] isEqualToString:@"text/plain"]) {
                _type = MediaTypeText;
            }

            if ([newMsg[@"type"] isEqualToString:@"text/markdown"]) {
                _type = MediaTypeText;
                if ([newMsg[@"content"] isKindOfClass:[NSDictionary class]] && newMsg[@"content"][@"text"]) {
                    [bodyDic setObject:newMsg[@"content"][@"text"] forKey:@"source"];
                }
                _body = [Utilities JSONStrFromDic:bodyDic];

                return;
            }
            if ([newMsg[@"type"] isEqualToString:@"attachment/file"]) {
                _type = MediaTypeFile;
                if ([newMsg[@"content"] isKindOfClass:[NSDictionary class]] && newMsg[@"content"][@"name"] && newMsg[@"content"][@"size"]) {
                    bodyDic[@"name"] = newMsg[@"content"][@"name"];
                    bodyDic[@"size"] = newMsg[@"content"][@"size"];
                }
                _body = [Utilities JSONStrFromDic:bodyDic];

                return;
            }
        }
    }

    if ([key isEqualToString:@"timestamp"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *date = [dateFormatter dateFromString:value];
        if(date){
            _timestamp = [date timeIntervalSince1970];
        }else {
            _timestamp = [value doubleValue];
        }


        return;
    }
    if([key isEqualToString:@"read"]){

        self.read = [value integerValue];

        return ;
    }
    if([key isEqualToString:@"relatedMsg"]){
        MessageBody *message = [[MessageBody alloc] init];
        if([value isKindOfClass:NSDictionary.class]){
            [message setValuesForKeysWithDictionary:value];
            self.relatedMsg = message;
            return;
        }
    }
    //处理特殊iOS 8.4设备中不支持给BOOL赋值String的问题
    if([key isEqualToString:@"read"]){
        self.read = [value integerValue];
        return ;
    }
    if([key isEqualToString:@"isOwner"]){
        self.isOwner = [value integerValue];
        return;
    }
    if([key isEqualToString:@"hasSaved"]){
        self.hasSaved = [value integerValue];
        return;
    }
    if([key isEqualToString:@"isRelated"]){
        self.isRelated = [value integerValue];
        return;
    }

    [super setValue:value forKey:key];
}

@end

@implementation IIPRIVATE_MessageBodyV1

WCDB_IMPLEMENTATION(IIPRIVATE_MessageBodyV1)

WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, cid)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, channelId)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, mid)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, body)
WCDB_SYNTHESIZE_COLUMN(IIPRIVATE_MessageBodyV1, from, "db_from")
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, type)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, isOwner)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, timestamp)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, status)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, tmpId)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, hasSaved)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, relatedMsgMid)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, isRelated)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, read)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, continuityFlag)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, showStr)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, content)
WCDB_SYNTHESIZE(IIPRIVATE_MessageBodyV1, recalledName)

WCDB_INDEX(IIPRIVATE_MessageBodyV1, "_cidindex", channelId)

WCDB_PRIMARY(IIPRIVATE_MessageBodyV1, mid)

- (void)setValue:(id)value forKey:(nonnull NSString *)key {
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"type"]) {
        if (super.type != MediaTypeNone) {
            return;
        }
        if ([value isEqualToString:@"text/plain"] || [value isEqualToString:@"1"]) {//WCDB赋值需要从数字映射到类型
            super.type = MediaTypeText;
        }
        else if([value isEqualToString:@"text/markdown"]) {
            super.type = MediaTypeMarkDown;
        }
        else if ([value isEqualToString:@"attachment/card"] || [value isEqualToString:@"extended/contact-card"] || [value isEqualToString:@"8"]) {
            super.type = MediaTypeBusinessCard;
        }
        else if ([value isEqualToString:@"media/image"] || [value isEqualToString:@"2"]) {
            super.type = MediaTypeImage;
        }
        else if ([value isEqualToString:@"media/voice"] || [value isEqualToString:@"9"]){
            super.type = MediaTypeVoice;
        }
        else if([value isEqualToString:@"media/tmpvoice"] || [value isEqualToString:@"10"]){
            super.type = MediaTypeTmpVoice;
        }
        else if ([value isEqualToString:@"extended/links"] || [value isEqualToString:@"3"]) {
            super.type = MediaTypeLink;
        }
        else if ([value isEqualToString:@"file/regular-file"] || [value isEqualToString:@"4"]) {
            super.type = MediaTypeFile;
        }else if ([value isEqualToString:@"extended/actions"] || [value isEqualToString:@"7"]) {
            super.type = MediaTypeActivity;
        }else if([value isEqualToString:@"experimental/selects"] || [value isEqualToString:@"14"]){
            super.type = MediaTypeSelects;
        }else if([value isEqualToString:@"experimental/feeds"] || [value isEqualToString:@"15"]){
            super.type = MediaTypeFeeds;
        }else if ([value isEqualToString:@"comment/text-plain"] || [value isEqualToString:@"5"]) {
            super.type = MediaTypeComment;
        }
        else if ([value isEqualToString:@"extended/location"] || [value isEqualToString:@"12"]) {
            super.type = MediaTypeLocationCard;
        }else if([value isEqualToString:@"6"]){
            super.type = MediaTypeMeeting;
        }else {
            [super setValue:value forKey:key];
        }
        if (_content) {
            [self setValue:_content forKey:@"content"];
        }
        return;
    }

    if ([key isEqualToString:@"from"]) {
        if([value isKindOfClass:NSDictionary.class] && value[@"user"] && value[@"enterprise"]){
            NSDictionary *from = @{
                                   @"title" : [[GlobalAction shareInstance] getPBRealNameById:value[@"user"]],
                                   @"uid"   : value[@"user"],
                                   @"enterprise"    : value[@"enterprise"]
                                   };
            super.from = [Utilities JSONStrFromDic:from];
        }else {
            super.from = value;
        }
        return;
    }
    //channelId是从数据库加载出的值，同时赋值给cid
    if ([key isEqualToString:@"channel"] || [key isEqualToString:@"channelId"]) {
        super.cid = [value integerValue];
        _channelId = value;

        return;
    }
    if ([key isEqualToString:@"content"]) {
        _content = value;
        if (_content[@"tmpId"]) {
            super.tmpId = [_content[@"tmpId"] doubleValue];
        }
        if (self.type == MediaTypeNone) {
            return;
        }
        NSDictionary *body;
        if (super.type == MediaTypeText || super.type == MediaTypeComment || super.type == MediaTypeMarkDown) {
            NSDictionary *content = _content[@"mentions"] ? _content[@"mentions"] : [[NSDictionary alloc] init];
            NSString *text = _content[@"text"] ? _content[@"text"] : @"";
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < [[content allKeys] count]; i++) {
                NSString *key = [content allKeys][i];
                NSString *uid = content[key];
                if (uid.length > 0) {
                    [arr addObject:uid];
                }
                //                NSString *userName = [[GlobalAction shareInstance] getPBRealNameById:uid];
                NSString *atStr = @"[@](ecm-contact://%@)";//@"[@%@](ecm-contact://%@)";
                NSString *showString = [NSString stringWithFormat:@"@%@", key];
                NSString *replacement = [NSString stringWithFormat:atStr, uid];
                text = [text stringByReplacingOccurrencesOfString:showString withString:replacement];
            }
            if(super.type == MediaTypeText || super.type == MediaTypeComment) {
                NSString *linkRegex = @"(((https?)://[a-zA-Z0-9\\_\\-]+(\\.[a-zA-Z0-9\\_\\-]+)*(\\:\\d{2,4})?(/?[a-zA-Z0-9\\-\\_\\.\\?\\=\\&\\%\\#]+)*/?)|([a-zA-Z0-9\\-\\_]+\\.)+([a-zA-Z\\-\\_]+)(\\:\\d{2,4})?(/?[a-zA-Z0-9\\-\\_\\.\\?\\=\\&\\%\\#]+)*/?|\\d+(\\.\\d+){3}(\\:\\d{2,4})?)";

                NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:linkRegex options:NSRegularExpressionCaseInsensitive error:nil];
                NSArray *matches = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];

                NSInteger offset = 0;
                //多个url相同的时候，若不指定范围，执行一次stringByReplacingOccurrencesOfString会把后面的url也替换掉,也导致偏移量计算错误
                for (NSTextCheckingResult *match in matches) {
                    NSRange newRange = NSMakeRange(match.range.location + offset, match.range.length);
                    NSString *url = [text substringWithRange:newRange];
                    if ([[url componentsSeparatedByString:@"://"] count] > 1) {
                        /*
                         NSInteger tmp = match.range.location + offset - 2;
                         NSUInteger loc = tmp < 0 ? 0 : tmp;
                         if(text.length > 16){
                         NSRange checkRange = NSMakeRange(loc, 16);
                         NSString *checkUrl = [text substringWithRange:checkRange];
                         if ([checkUrl hasPrefix:@"](ecm-contact://"] || [checkUrl hasPrefix:@"](ecc-contact://"])
                         continue;
                         }*/
                        text = [text stringByReplacingOccurrencesOfString:url withString:[NSString stringWithFormat:@"[%@](%@)", url, url] options:NSLiteralSearch range:newRange];//指定替换的范围
                        offset += url.length + 4;
                    }
                    else {
                        text = [text stringByReplacingOccurrencesOfString:url withString:[NSString stringWithFormat:@"[%@](http://%@)", url, url] options:NSLiteralSearch range:newRange];
                        offset += url.length + 11;
                    }
                }
            }else {
                super.type = MediaTypeText;
            }

            if (super.type == MediaTypeComment) {
                NSArray *commentArr = [arr copy];
                body = @{@"mentions":commentArr,@"source" : text,@"mid": _content[@"message"] ? _content[@"message"] : @"0"};
            }
            else if (super.type == MediaTypeText) {
                NSArray *targetArr = [arr copy];
                body = @{@"mentions":targetArr,@"source" : text};
            }
            else {
                body = @{@"source" : text};
            }
        }
        else if (super.type == MediaTypeImage) {
            //兼容v0消息，v1消息处理图片时会传递content内容
            body = @{
                     @"name"   : _content[@"name"] ? _content[@"name"] : @"",
                     @"width"  : _content[@"raw"][@"width"] ? _content[@"raw"][@"width"] : @0,
                     @"height" : _content[@"raw"][@"height"] ? _content[@"raw"][@"height"] : @0,
                     @"media"  : _content[@"raw"][@"media"] ? _content[@"raw"][@"media"] : @""
                     };
        }
        else if (super.type == MediaTypeFile) {
            body = @{
                     @"name"      :   _content[@"name"] ? _content[@"name"] : @"",
                     @"media"     :   _content[@"media"] ? _content[@"media"] : @"",
                     @"size"      :   _content[@"size"] ? _content[@"size"] : @0,
                     @"category"  :   _content[@"category"] ? _content[@"category"] : @""
                     };
        }
        else if(super.type == MediaTypeVoice){
            body = @{
                     @"duration"  :   _content[@"duration"] ? _content[@"duration"] : @0,
                     @"media"     :   _content[@"media"] ? _content[@"media"] : @"",
                     @"subtitles" :   _content[@"subtitles"] ? _content[@"subtitles"] :[NSDictionary dictionary]
                     };
        }
        else if(super.type == MediaTypeTmpVoice){
            body = @{

                     };
        }else if(super.type == MediaTypeLink){
            //
            //            body = @{
            //                     @"digest"  :   _content[@"digest"] ? _content[@"digest"]:@"",
            //                     @"poster"  :   _content[@"poster"] ? _content[@"poster"]:@"",
            //                     @"title"   :   _content[@"title"] ? _content[@"title"]:@"",
            //                     @"url"     :   _content[@"url"] ? _content[@"url"]:@""
            //                     };

            body = @{
                     @"subtitle":   _content[@"subtitle"] ? _content[@"subtitle"]:@"",
                     @"poster"  :   _content[@"poster"] ? _content[@"poster"]:@"",
                     @"title"   :   _content[@"title"] ? _content[@"title"]:@"",
                     @"url"     :   _content[@"url"] ? _content[@"url"]:@""
                     };

        }else if (super.type == MediaTypeLocationCard){
            body = @{
                     @"content":_content ? _content : @""
                     };
        }else if(super.type == MediaTypeSelects){
            //决策卡片
            body = _content;
        }else if(super.type == MediaTypeFeeds){
            //订阅卡片
            body = _content;
        }else {
            NSLog(@"----------%@", _content);
        }
        super.body = [Utilities JSONStrFromDic:body];

        return;
    }

    if ([key isEqualToString:@"creationDate"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *date = [dateFormatter dateFromString:value];
        if(date){
            super.timestamp = [date timeIntervalSince1970];
        }
        return;
    }

    [super setValue:value forKey:key];
}

@end

@implementation BotBody

WCDB_IMPLEMENTATION(BotBody)

WCDB_SYNTHESIZE(BotBody, avatar)
WCDB_SYNTHESIZE(BotBody, botId)
WCDB_SYNTHESIZE(BotBody, mode)
WCDB_SYNTHESIZE(BotBody, name)
WCDB_SYNTHESIZE(BotBody, title)
WCDB_SYNTHESIZE(BotBody, support)

WCDB_PRIMARY(BotBody, botId)

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _botId = value;

        return;
    }
    [super setValue:value forKey:key];
}

@end
