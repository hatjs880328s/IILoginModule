//
//  PhotoService.h
//  iPhone_hybrid
//
//  Created by Elliot on 17-2-16.
//  Copyright (c) 2017年 Elliot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Imp.h"

@interface PhotoService : IMPPlugin< UIAlertViewDelegate>

@property (nonatomic, strong) NSDictionary *jsonDict;

@end
