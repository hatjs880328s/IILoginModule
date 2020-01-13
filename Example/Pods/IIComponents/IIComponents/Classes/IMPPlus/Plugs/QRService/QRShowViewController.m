//
//  QRShowViewController.m
//  impcloud
//
//  Created by Elliot on 2016/12/29.
//  Copyright © 2016年 Elliot. All rights reserved.
//

#import "QRShowViewController.h"
#import "ATQRCodeManager.h"
@import IIBLL;

@interface QRShowViewController ()

@end

@implementation QRShowViewController
@synthesize pImg;
@synthesize pTran_str;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitselector:) name:@"close_QrCode" object:nil];
    pImg.image = [ATQRCodeManager creatQRcodeWithUrlstring:pTran_str size:pImg.bounds.size.width];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)quitselector:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"close_QrCode" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
