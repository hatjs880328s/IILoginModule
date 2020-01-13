//
//  SetUserPVAndEXPClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "SetUserPVAndEXPClass.h"
#import "IMPUserModel.h"
#import "Constants.h"

@implementation SetUserPVAndEXPClass

//用户异常信息收集
+ (void)getUserEXPContentErrorLevel:(NSString *)level ErrorUrl:(NSString *)url ErrorInfo:(NSString *)info errorCode:(NSString *)code {
    if ([code isEqualToString:@"-1009"]) {
        return;
    }
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:UserEXPContent];
    NSMutableArray *ExpArr = [[NSMutableArray alloc] initWithArray:arr];
    NSDictionary *dict_Exp;
    NSDate* data = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval interval =[data timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];
    dict_Exp = [[NSDictionary alloc] initWithObjectsAndKeys:timeString,@"happenTime",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],@"appVersion",level,@"errorLevel",url,@"errorUrl",info,@"errorInfo",code,@"errorCode",nil];
    [ExpArr addObject:dict_Exp];
    NSArray *arr_Save = [ExpArr copy];
    [[NSUserDefaults standardUserDefaults] setObject:arr_Save forKey:UserEXPContent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户行为分析收集
+ (void)getUserActionContent:(NSString *)functionID FunctionType:(NSString *)functionType {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:UserActionCollect];
    NSMutableArray *actionArr = [[NSMutableArray alloc] initWithArray:arr];
    NSDate* data= [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval interval=[data timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];
    if (functionID.length == 0) {
        functionID = @"";
    }
    if (functionType.length == 0) {
        functionType = @"";
    }
    NSDictionary *dict_act = [[NSDictionary alloc] initWithObjectsAndKeys:functionID,@"functionID",functionType,@"functionType",timeString, @"collectTime",nil];
    [actionArr addObject:dict_act];
    NSArray *arr_Save = [actionArr copy];
    [[NSUserDefaults standardUserDefaults] setObject:arr_Save forKey:UserActionCollect];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
