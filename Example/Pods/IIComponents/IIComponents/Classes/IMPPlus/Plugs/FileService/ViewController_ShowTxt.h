//
//  ViewController_ShowTxt.h
//  DiZuo
//
//  Created by YoungHsu on 14-8-8.
//  Copyright (c) 2014年 DingXin. All rights reserved.
//

#import "BaseViewController.h"

@interface ViewController_ShowTxt : BaseViewController<UITextViewDelegate>

@property(strong, nonatomic) IBOutlet UITextView *pTextView_Show;
@property(strong, nonatomic) IBOutlet UILabel *pLabel_Name;
@property(strong, nonatomic) NSString *pString_Show;
@property(strong, nonatomic) NSString *pString_FileName;

-(IBAction)quitVCselector:(id)sender;

@end
