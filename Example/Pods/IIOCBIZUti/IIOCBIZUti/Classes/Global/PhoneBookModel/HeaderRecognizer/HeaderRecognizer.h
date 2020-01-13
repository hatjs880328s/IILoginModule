//
//  HeaderRecognizer.h
//  impcloud
//
//  Created by Elliot on 16/3/31星期四.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderRecognizer : UITapGestureRecognizer
@property (strong,nonatomic) UITableView *table;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (assign,nonatomic) int section;
@property (assign,nonatomic) int row;
@end
