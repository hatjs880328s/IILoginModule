//
//  MeConfigModel.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/1/24.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeConfigModel : NSObject

//初始化init
-(id)initWithDictionary:(NSDictionary *)dictionary;

//id
@property(nonatomic, retain) NSString *id;
//图标
@property(nonatomic, retain) NSString *ico;
//国际化名称
@property(nonatomic, retain) NSDictionary *title;
//打开地址
@property(nonatomic, retain) NSString *uri;

@end

NS_ASSUME_NONNULL_END
