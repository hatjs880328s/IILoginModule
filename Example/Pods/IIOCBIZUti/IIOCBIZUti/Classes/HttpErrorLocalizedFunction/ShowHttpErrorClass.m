//
//  ShowHttpErrorClass.m
//  impcloud_dev
//
//  Created by 许阳 on 2019/3/27.
//  Copyright © 2019 Elliot. All rights reserved.
//

#import "ShowHttpErrorClass.h"
#import "IMPI18N.h"

@implementation ShowHttpErrorClass

//处理Http Error
+(NSString *)fromHttpError:(int)HttpCode andErrorCode:(int)errorCode
{
    if (HttpCode == 400)
    {
        switch (errorCode)
        {
            case 71001:
            {
                return IMPLocalizedString(@"Error_400_71001");
                break;
            }
            case 72001:
            {
                return IMPLocalizedString(@"Error_400_72001");
                break;
            }
            case 72002:
            {
                return IMPLocalizedString(@"Error_400_72002");
                break;
            }
            case 72003:
            {
                return IMPLocalizedString(@"Error_400_72003");
                break;
            }
            case 72004:
            {
                return IMPLocalizedString(@"Error_400_72004");
                break;
            }
            case 72005:
            {
                return IMPLocalizedString(@"Error_400_72005");
                break;
            }
            case 72101:
            {
                return IMPLocalizedString(@"Error_400_72101");
                break;
            }
            case 72102:
            {
                return IMPLocalizedString(@"Error_400_72102");
                break;
            }
            case 72103:
            {
                return IMPLocalizedString(@"Error_400_72103");
                break;
            }
            case 72201:
            {
                return IMPLocalizedString(@"Error_400_72201");
                break;
            }
            case 72202:
            {
                return IMPLocalizedString(@"Error_400_72202");
                break;
            }
            case 41001:
            {
                return IMPLocalizedString(@"Error_400_41001");
                break;
            }
            case 41002:
            {
                return IMPLocalizedString(@"Error_400_41002");
                break;
            }
            case 72301:
            {
                return IMPLocalizedString(@"Error_400_72301");
                break;
            }
            case 72006:
            {
                return IMPLocalizedString(@"Error_400_72006");
                break;
            }
            default:
            {
                return IMPLocalizedString(@"common_request_error");
                break;
            }
        }
    }
    else
    {
        return IMPLocalizedString(@"common_request_error");
    }
}

@end
