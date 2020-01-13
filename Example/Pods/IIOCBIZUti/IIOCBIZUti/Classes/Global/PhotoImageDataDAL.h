//
//  PhotoImageDataModel.h
//  impcloud
//
//  Created by Elliot on 16/3/24.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoImageDataDAL : NSObject

-(id)initWithUserID:(NSString *)uid;

@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) UIImage *img;

@end
