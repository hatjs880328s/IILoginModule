//
//  QRShowViewController.h
//  impcloud
//
//  Created by Elliot on 2016/12/29.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import <UIKit/UIKit.h>
@import IIBaseComponents;

@interface QRShowViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UIImageView *pImg;
@property (nonatomic, strong) NSString *pTran_str;

-(IBAction)quitselector:(id)sender;

@end
