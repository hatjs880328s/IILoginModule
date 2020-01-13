//
//  IIDataBaseManage.h
//  impcloud_dev
//
//  Created by 衣凡 on 2018/12/21.
//  Copyright © 2018年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString* (^WCDBFileNameBlock)(void);


@interface IIDataBaseManage : NSObject

@property (nonatomic, strong) NSString *wcdbPassword;

/// 此属性值为 ： [NSString stringWithFormat:@"WCDB_%@_%d_imp.db",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]]
@property (nonatomic, strong) NSString *wcdbFileName;

@property (nonatomic, strong) WCDBFileNameBlock fileNameBlock;


+ (IIDataBaseManage *)instance;
- (void)closeDataBase;
@end
