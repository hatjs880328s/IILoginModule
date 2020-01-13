// ==============================================================================
//
// This file is part of the IMP Cloud.
//
// Create by Shiguang <shiguang@richingtech.com>
// Copyright (c) 2016-2017 inspur.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed w ith this source code.
//
// ==============================================================================

#ifndef ServiceAPI_h
#define ServiceAPI_h

//分享网页地址
#define kShareIP                     @"https://www.inspuronline.com/yjapp/"
//举报服务器地址
#define kTipOffIP                    @"http://u.inspur.com:8080/voice/collector/ios_report"
//异常上传服务器地址
#define kExceptionIP                 @"https://uvc1.inspuronline.com/cpexception"
//PV上传服务器地址
#define kPVCollectIP                 @"https://uvc1.inspuronline.com/clientpv"
//意见反馈服务器地址
#define kFeedbackIP                  @"http://u.inspur.com/analytics/RestFulServiceForIMP.ashx?resource=Feedback&method=AddECMFeedback"
//行政审批-密码验证网址
#define kXZSPVerPwdIP                @"https://emm.inspur.com/proxy/shenpi/langchao.ecgap.inportal/login/CheckLoginDB.aspx"
//行政审批-APP版网址
#define kXZSPAPPIP                   @"ishenpi://ishenpi.inspur.com"
//HCM专用 身份验证 固定地址
#define kJustForHCM                 @"https://id.inspur.com"
//行程详情服务器地址
#define kJourneyDetailIP             [NSString stringWithFormat:@"https://ecm.inspur.com/%@/trip/simple/detail?trip_ticket",[IMPUserModel activeInstance].enterprise.code]
//行程详情-获取城市服务器地址
#define kJourneyCityIP               [NSString stringWithFormat:@"https://ecm.inspur.com/%@/trip/simple/city",[IMPUserModel activeInstance].enterprise.code]
//行程详情-修改上传数据服务器地址
#define kJourneyUploadDataIP         [NSString stringWithFormat:@"https://ecm.inspur.com/%@/trip/simple/upload",[IMPUserModel activeInstance].enterprise.code]
//二维码上传后台辅助识别
#define kQRCodeUpload                @"http://emm.inspuronline.com:88/api/barcode/decode"
//注册推送信息（登录、切换企业和推送token发生变化时都要调用）
#define kRegistNotificationTokenIP   @"https://emm.inspuronline.com/api/sys/v6.0/config/registerDevice"
//注销推送信息（只在用户注销的时候调用）
#define kUnRegistNotificationTokenIP @"https://emm.inspuronline.com/api/sys/v6.0/config/unRegisterDevice"

#endif
