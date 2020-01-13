//
//  UserInfoDisplayConfigModel.h
//  impcloud_dev
//
//  Created by 许阳 on 2019/1/22.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowUserDisplayModel : NSObject

-(id) initWithDictionary:(NSDictionary *)dictionary;

@property (strong, nonatomic) NSString *value;
@property (assign, nonatomic) BOOL show;

@end

@interface UserInfoDisplayConfigModel : NSObject

@property (strong, nonatomic) ShowUserDisplayModel *name;
@property (strong, nonatomic) ShowUserDisplayModel *headUrl;
@property (strong, nonatomic) ShowUserDisplayModel *email;
@property (strong, nonatomic) ShowUserDisplayModel *emoNo;
@property (strong, nonatomic) ShowUserDisplayModel *mobile;
@property (strong, nonatomic) ShowUserDisplayModel *office;
@property (strong, nonatomic) ShowUserDisplayModel *orgName;
@property (strong, nonatomic) ShowUserDisplayModel *enterpriseName;
@property (strong, nonatomic) ShowUserDisplayModel *tel;
@property (strong, nonatomic) ShowUserDisplayModel *showModifyPsd;
@property (strong, nonatomic) ShowUserDisplayModel *showResetPsd;

@end

NS_ASSUME_NONNULL_END
