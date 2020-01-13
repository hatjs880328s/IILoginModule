//
//  ViewController_ShowTxt.m
//  DiZuo
//
//  Created by YoungHsu on 14-8-8.
//  Copyright (c) 2014年 DingXin. All rights reserved.
//

#import "ViewController_ShowTxt.h"

@interface ViewController_ShowTxt ()

@end

@implementation ViewController_ShowTxt
@synthesize pTextView_Show;
@synthesize pLabel_Name;
@synthesize pString_Show;
@synthesize pString_FileName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pLabel_Name.text = pString_FileName;
    pTextView_Show.editable = NO;
    pTextView_Show.text = pString_Show;
}

-(IBAction)quitVCselector:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)doAboutBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
