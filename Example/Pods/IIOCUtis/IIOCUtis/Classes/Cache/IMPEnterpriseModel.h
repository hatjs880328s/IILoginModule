//
//  IMPEnterpriseModel.h
//  impcloud
//
//  Created by larry on 6/12/16.
//  Copyright © 2016 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMPEnterpriseModel : NSObject

@property (nonatomic) int id;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSDate   * createdAt;
@property (nonatomic, copy) NSString * licenseCopy;
@property (nonatomic, copy) NSString * licenseSN;
@property (nonatomic, copy) NSArray  * clusters;

@end
