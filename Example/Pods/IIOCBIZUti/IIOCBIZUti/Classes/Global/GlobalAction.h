//
//  GlobalAction.h
//  impcloud
//
//  Created by hctek on 16/11/11.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionForCheck.h"

@protocol GlobalActionDelegate <NSObject>

@optional

- (void)didFinishActionWithError:(NSError *)error;

@end

@interface GlobalAction : NSObject

@property (weak, nonatomic) id <GlobalActionDelegate> delegate;
@property (strong, nonatomic) NSDictionary *phonebookDic;

/// 记录通讯录是否已经加载完毕
@property (assign, nonatomic) BOOL finishLoadPhoneBook;

+ (GlobalAction *)shareInstance;

- (void)loadPhonebook;
- (NSString *)getPBUpdateTimeById:(NSString *)uid;
- (NSString *)getPBRealNameById:(NSString *)uid;
- (BOOL)getPBAvatarExist:(NSString *)uid;
- (void)getUserChangeorDeleteInfo:(NSString *)lastQueryTime;
- (void)getPhonebookUserWithSuccessHandler:(CheckQuerySuccessHandler)handler;
- (void)getPhonebookOrgWithSuccessHandler:(CheckQuerySuccessHandler)handler;

@end
