//
//  FileTransferService.h
//  iPhone_hybrid
//
//  Created by Xuyoung on 14-3-25.
//  Copyright (c) 2014年 浪潮移动应用平台(IMP)产品组. All rights reserved.
//

#import "Imp.h"
#import <QuickLook/QuickLook.h>

@interface FileTransferService : IMPPlugin<QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate> {

}
//@property (strong,nonatomic)     NSString *pString_Name;
@property (strong,nonatomic)    NSString * pString_Filepath;

@end
