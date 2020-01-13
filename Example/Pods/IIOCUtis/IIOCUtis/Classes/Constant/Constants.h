// ==============================================================================
//
// This file is part of the IMP Cloud.
//
// Create by Shiguang <shiguang@richingtech.com>
// Copyright (c) 2016-2017 inspur.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================
#ifndef Constants_h
#define Constants_h

//OAuth
#define kOAuthClientId                  @"51c6a0a8-7a40-47e8-b8bd-cc305ece9c52"
#define kOAuthSecret                    @"a4738cc3-f929-46d2-b4e5-277b6cac8e01"

//获取头像串行队列
#define imgLayerCreatequeue   dispatch_queue_create("imgLayerCreatequeue", DISPATCH_QUEUE_CONCURRENT)

//AES加密、解密约定Key
#define kAESKey                         @"inspurIMPCloud968842022285d325h9"

//网络请求超时时间
#define NetworkRequestWaitTime                  15
#define NetworkRequestWaitTime_RefreshToken     30

//用户信息
#define kPassWord                       @"密码"
#define kHeadIcon                       @"用户头像"

//皮肤设定
#define kAppSkinName                    @"AppSkinName"

//消息通知
#define kReceiveMSG                     @"ReceiveMSG"
#define kReceiveMSGForCache             @"CacheMSG"
#define kSocketStatusChange             @"SOCKET_STATUS"

//视频通话通知名称
#define VideoCallNotification @"Socket_VideoCall_Noti"
#define VideoCallNotificationKey @"Socket_VideoCall_Noti_Key"

#define kTokenRefreshRetryCount         1
//图片选择数量
#define SelectPhotoNum                  9

//云+客服
#define Chat_Kefu                       @"BOT6005"
//云+小智
#define Chat_XiaoZhi                    @"BOT6006"

//工作会议
#define MEETING_ID                      @"id"
#define MEETING_TITLE                   @"topic"
#define MEETING_ALERT                   @"alert"
#define MEETING_DAY                     @"day" //没用
#define MEETING_START                   @"from"
#define MEETING_END                     @"to"
#define MEETING_TIME                    @"time"
#define MEETING_BOOKDATE                @"bookDate"
#define MEETING_PARTICIPANT             @"participant"
#define MEETING_ATTENDEES               @"attendees"//没用
#define MEETING_LOCATION_ROOM           @"room"
#define MEETING_LOCATION_ROOM_NAME      @"name"
#define MEETING_LOCATION                @"location"
#define MEETING_LOCATION_ROOM_BUILDING  @"building"
#define MEETING_REMIND                  @"remind"//没用
#define MEETING_NOTICE                  @"notice"
#define MEETING_TIME_LENGTH             @"timelength"//没用
#define MEETING_ORGANIZER               @"organizer"

//通知
#define kNotificationPullChatData       @"kNotificationPullChatData"
#define notificationRedicetData         @"NotificationRedicetData"

//判读网址正则
#define REGEX_URI                       @"(\\[[^\\[\\]]+\\])\\((((https?|ec[cm](-[0-9a-z]+)+|gs-msg)://[a-zA-Z0-9\\_\\-]+(\\.[a-zA-Z0-9\\_\\-]+)*(\\:\\d{2,4})?(/?[a-zA-Z0-9\\-\\_\\.\\?\\=\\&\\%\\#]+)*/?)|([a-zA-Z0-9\\-\\_]+\\.)+([a-zA-Z\\-\\_]+)(\\:\\d{2,4})?(/?[a-zA-Z0-9\\-\\_\\.\\?\\=\\&\\%\\#]+)*/?|\\d+(\\.\\d+){3}(\\:\\d{2,4})?)\\)"
//判读@正则
#define REGEX_URI_SHOW                  @"\\[[\\S\\s]+\\]"

#define kScreenWidth                    CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight                   CGRectGetHeight([[UIScreen mainScreen] bounds])

//iPhoneX/XS、XR、XS MAX屏幕适配
//判断是否是ipad
#define IS_Pad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4、4s
#define IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !IS_Pad : NO)
//判断iPhone5、5s、5c、SE
#define IS_IPHONE_5 ([Utilities getDeviceSeries] == iPhone5_Series_1136x640)
//判断iPhone6、7、8
#define IS_IPHONE_6 ([Utilities getDeviceSeries] == iPhone6_Series_1334x750)
//判断iphone6Plus、7Plus、8Plus
#define IS_IPHONE_6P ([Utilities getDeviceSeries] == iPhone6p_Series_2208x1242)
//判断iPhoneX、Xs
#define IS_IPHONE_X ([Utilities getDeviceSeries] == iPhoneX_Series_2436x1125)
//判断iPHoneXr
#define IS_IPHONE_Xr ([Utilities getDeviceSeries] == iPhoneXr_Series_1792x828)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([Utilities getDeviceSeries] == iPhoneXsMax_Series_2688x1242)

#define SafeAreaTopHeight_NoNav ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs_Max == YES || [[UIScreen mainScreen] bounds].size.height == 812.0f) ? 44 : 20)
#define SafeAreaTopHeight_Nav ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs_Max == YES || [[UIScreen mainScreen] bounds].size.height == 812.0f) ? 88 : 64)
#define SafeAreaBottomHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs_Max == YES || [[UIScreen mainScreen] bounds].size.height == 812.0f) ? 34 : 0)
#define kTabBarHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs_Max == YES || [[UIScreen mainScreen] bounds].size.height == 812.0f) ? 83 : 49)
#define webWindowHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs_Max == YES || [[UIScreen mainScreen] bounds].size.height == 812.0f) ? 34 : 6)
#define SafeAreaTopHeight_QR_Top ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs_Max == YES || [[UIScreen mainScreen] bounds].size.height == 812.0f) ? 24 : 0)
#define SafeAreaTopHeight_QR_ScanArea ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs_Max == YES || [[UIScreen mainScreen] bounds].size.height == 812.0f) ? 55 : 0)
//#define LogOutButtonBottomHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs_Max == YES || [[UIScreen mainScreen] bounds].size.height == 812.0f) ? 65 : 31)

#define New_XZSPID                      @"456166a362436750d74bfeaef997693d"

//APP认证Key
#define kAppMainIP                      @"kAppMainIP"
#define kAppMainIPName                  @"kAppMainIPName"

//RN组件版本
#define RNVersion                       @"0.46.4"

//会议室空闲过滤
#define Meeting_Time_TimeGuolv  [NSString stringWithFormat:@"%@_%d.timeGuolv",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define Meeting_Time_TimeFrom   [NSString stringWithFormat:@"%@_%d.timeFrom",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define Meeting_Time_TimeTo     [NSString stringWithFormat:@"%@_%d.timeTo",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//会议室常用地点
#define Meeting_CommonPlace     [NSString stringWithFormat:@"MyCommonPlace_%@_%d",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define Meeting_CommonBuilding  [NSString stringWithFormat:@"CommonBuilding_%@_%d",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//WCDB，联系人查询时间
#define WCDBUserQueryTime                [NSString stringWithFormat:@"%@_%d.userquerytime",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
//WCDB，组织查询时间
#define WCDBOrgQueryTime                [NSString stringWithFormat:@"%@_%d.orgquerytime",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
//WCDB，用户可查看的组织RootID
#define WCDBUserOrgRootID              [NSString stringWithFormat:@"%@_%d.rootid",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//消息刷新
#define offlineMessageRefreshId [NSString stringWithFormat:@"%@_%d_refreshMid",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

#define UserAppSet              [NSString stringWithFormat:@"%@_%d.userappset",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserEquipment           [NSString stringWithFormat:@"%@_%d.equipment",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//扫脸解锁
#define UserFaceUnlockSet       [NSString stringWithFormat:@"%@_%d.faceunlockset",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserFaceUnlockEnable    [NSString stringWithFormat:@"%@_%d.faceunlockenable",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//3D Touch
#define User3DTouch             [NSString stringWithFormat:@"%@_%d_1.3dtouch_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define User3DTouchVer          [NSString stringWithFormat:@"%@_%d_1.3dtouchver_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserTabCon              [NSString stringWithFormat:@"%@_%d_4.tabcon_4",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserTabConVer           [NSString stringWithFormat:@"%@_%d_4.tabconver_4",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//用户配置信息
#define UserDisplayInfo         [NSString stringWithFormat:@"%@_%d.userdisplayinfo",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
//Tab相关 Native固定的项目
//沟通
#define Tab_Communicate         @"communicate"
//工作
#define Tab_Work                @"work"
//应用
#define Tab_Application         @"application"
//我
#define Tab_Me                  @"me"
//通讯录
#define Tab_Contact             @"contact"
//发现
#define Tab_Discover            @"discover"
//动态
#define Tab_Moment              @"moment"

//原生发现Uri
#define Tab_Native_Discover_Uri @"native://discover"
//RN发现Uri
#define Tab_RN_Discover_Uri     @"ecc-app-react-native://discover"

//小红点缓存数据
#define UserBadgeData_Application      [NSString stringWithFormat:@"%@_%d.badgedata.application",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserBadgeData_Moment           [NSString stringWithFormat:@"%@_%d.badgedata.moment",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//是否开启EMM
#define UserEmmConfig           [NSString stringWithFormat:@"%@_%d_1.emmconfig",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserEXPContent          [NSString stringWithFormat:@"%@_%d_2.expcontent_2",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserActionCollect       [NSString stringWithFormat:@"%@_%d_2.actioncollect_2",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//行政审批
#define UserXZSPPW              [NSString stringWithFormat:@"%@_%d_1.xzsppw",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define MEETING_QuanXian        [NSString stringWithFormat:@"%@_%d_meeting",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//夜间模式和字号大小
#define UserDaynightmodel       [NSString stringWithFormat:@"%@_%d.daynightmodel",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserFontsize            [NSString stringWithFormat:@"%@_%d.fontsize",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserFont                [NSString stringWithFormat:@"%@_%d.font",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define UserFontsize_CRM        [NSString stringWithFormat:@"%@_%d.fontsize_crm",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//判断聊天路由是否发生变更
#define ChatRouterChange        [NSString stringWithFormat:@"%@_%d_routerchange",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
//EMM 检查版本:Router
#define EMMRouterVersion        [NSString stringWithFormat:@"%@_%d_routerversion",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//EMM 检查版本:3DTouch
#define EMM3DTouchVersion        [NSString stringWithFormat:@"%@_%d_3dtouchversion",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//EMM 检查版本:Maintab
#define EMMTabVersion        [NSString stringWithFormat:@"%@_%d_maintabversion",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//EMM 检查版本:LanuchAdvert
#define EMMLanuchAdvertVersion        [NSString stringWithFormat:@"%@_%d_lanuchadvertversion",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//EMM 检查版本:Application
#define EMMAPPVersion              [NSString stringWithFormat:@"%@_%d_applicationversion",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//EMM 检查版本:通讯录
//#define EMMContactVersion              [NSString stringWithFormat:@"%@_%d_contactversion",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//EMM 检查版本:通讯录_人员
#define EMMContactUserVersion              [NSString stringWithFormat:@"%@_%d_contactuserversion",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//EMM 检查版本:通讯录_组织
#define EMMContactOrgVersion              [NSString stringWithFormat:@"%@_%d_contactorgversion",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//EMM 检查版本:布局_Tab
#define EMMMultipleLayoutVersionVersion   [NSString stringWithFormat:@"%@_%d_multiplelayoutversion",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
//布局_Tab存储数据
#define MultipleLayoutData   [NSString stringWithFormat:@"%@_%d_multiplelayoutdata",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
//布局_Tab选中数据Scheme
#define MultipleLayoutSelectScheme   [NSString stringWithFormat:@"%@_%d_multiplelayoutselectscheme",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//待办事项筛选条件
#define TODOREQUIREMENT         [NSString stringWithFormat:@"%d%@",[IMPUserModel activeInstance].id,@"KrequirementForTodo"]
#define KrequirementForTodo     [[NSUserDefaults standardUserDefaults]objectForKey:TODOREQUIREMENT]

//配置项字段Key
//是否开启web应用旋转
#define WebAutorotateConfig     [NSString stringWithFormat:@"%@_%d.webautorotateconfig_2",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define IIAOPNBPServiceConfig     [NSString stringWithFormat:@"%@_%d.IIAOPNBPServiceconfig_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define IIPitchServiceConfig     [NSString stringWithFormat:@"%@_%d.IIPitchServiceconfig_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define IILOGUploadServiceConfig     [NSString stringWithFormat:@"%@_%d.IILOGUploadServiceconfig_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

#define IIEnableCommonFunction     [NSString stringWithFormat:@"%@_%d.IIEnableCommonFunction_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

#define kIsShowFeedback         [NSString stringWithFormat:@"%@_%d.isshowfeedback_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define kIsShowCustomerSevice   [NSString stringWithFormat:@"%@_%d.isshowcustomersevice_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define CommonFunctionsConfig   [NSString stringWithFormat:@"%@_%d.CommonFunctions_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define kWorkPortlet            [NSString stringWithFormat:@"%@_%d.WorkPortlet_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
//是否在进入频道时强制拉取消息
#define kPullMessageConfig      [NSString stringWithFormat:@"%@_%d.PullMessage_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//clientId
#define keyForClientId          [NSString stringWithFormat:@"clientId_%@_%d_2",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
//QueryClientBusy Bool
#define kBOOLClientId           [NSString stringWithFormat:@"Bool_clientId_%@_%d_2",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//LanuchAdvert
#define AdvertKey               [NSString stringWithFormat:@"%@_%d_Advert",[IMPUserModel activeInstance].enterprise.code, [IMPUserModel activeInstance].id]
#define AdvertDuration          3

//应用中心
#define MyAPPs                  [NSString stringWithFormat:@"%@_%d_MyAPPs",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define RecommendAPPs           [NSString stringWithFormat:@"%@_%d_RecommendAPPs",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//选择企业默认标志
#define DefaultEnterprise       [NSString stringWithFormat:@"%@_%d_Default_Enterprise", [TakeRouterSocketAdressClass getAppOAuthIP],[IMPUserModel activeInstance].id]

//V1消息状态
#define NeedRefreshOffLineFlag         [NSString stringWithFormat:@"%@_%d_needRefreshOffLineMessage",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
#define ChannelMessageStateTracer      @"channel_message_state"
#define ChannelMessageChangeState      @"change_channel_message_state"

//语音转文字设置
#define AutoRecordToText               [NSString stringWithFormat:@"%@_%d.AutoRecordToText",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]
//语音存储目录名称
#define AudioFolderName                @"AudioData"

//开启通知
#define NotificationConfig               [NSString stringWithFormat:@"%@_%d.notificationconfig",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//服务端参数-强制启用手势
#define NeedLockGestureEnabled  [NSString stringWithFormat:@"%@_%d.NeedLockGestureEnabled",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//手势、指纹识别
/**
 用户是否 想使用手势锁屏，这个配置，保存在NSUserDefaults。
 */
#ifndef KEY_UserDefaults_isGestureLockEnabledOrNotByUser
#define KEY_UserDefaults_isGestureLockEnabledOrNotByUser    [NSString stringWithFormat:@"KEY_UserDefaults_isGestureLockEnabledOrNotByUser_%d",[IMPUserModel activeInstance].id]
#endif

/**
 显示手势轨迹
 */
#ifndef KEY_UserDefaults_isShowGestureTrace
#define KEY_UserDefaults_isShowGestureTrace                 [NSString stringWithFormat:@"KEY_UserDefaults_isShowGestureTrace_%d",[IMPUserModel activeInstance].id]
#endif

/**
 用户是否 想使用touchID解锁，这个配置，保存在NSUserDefaults。
 */
#ifndef KEY_UserDefaults_isTouchIdEnabledOrNotByUser
#define KEY_UserDefaults_isTouchIdEnabledOrNotByUser        [NSString stringWithFormat:@"KEY_UserDefaults_isTouchIdEnabledOrNotByUser_%d",[IMPUserModel activeInstance].id]
#endif

//修改个人头像成功通知
//头像存储路径名称
#define changePersonalPhotoNoti               @"changePersonalPhotoNoti"

/// 工作试图切换通知key
#define kWorkBenchListVwAndDayVwChangeNoti    @"kWorkBenchListVwAndDayVwChangeNoti"

//新版任务
//排序
#define TaskSortOrderConfig               [NSString stringWithFormat:@"%@_%d.tasksortorderconfig",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

// Web 更改导航栏通知
#define WebSetNavTitle                        @"WebSetNaviTitles"
#define WebSetNavRightButtons                 @"WebSetRightNaviButtons"
#define ReloadWebview                         @"ReloadWebview"

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

//常用色值颜色
//#define kBackgroundColor APPUIConfig.newBgColor

#define kBackgroundColor [UIColor colorWithRed:248/255.0 green:249/255.0 blue:251/255.0 alpha:1]

#define KFontColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]

#define PINKCOLOR [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]

#define ORANGECOLOR [UIColor colorWithRed:255/255.0 green:142/255.0 blue:0/255.0 alpha:1]

#define YELLOWCOLOR [UIColor colorWithRed:255/255.0 green:204/255.0 blue:7/255.0 alpha:1]

#define GREENCOLOR [UIColor colorWithRed:126/255.0 green:211/255.0 blue:33/255.0 alpha:1]

#define BLUECOLOR [UIColor colorWithRed:112/255.0 green:174/255.0 blue:247/255.0 alpha:1]

#define PURPLECOLOR [UIColor colorWithRed:219/255.0 green:0/255.0 blue:255/255.0 alpha:1]

#define BROWNCOLOR [UIColor brownColor]

#define TagColor @{@"PINK":PINKCOLOR,@"ORANGE":ORANGECOLOR,@"YELLOW":YELLOWCOLOR,@"GREEN":GREENCOLOR,@"BLUE":BLUECOLOR,@"PURPLE":PURPLECOLOR,@"BROWN":BROWNCOLOR}
// ['PENDING', 'ACTIVED', 'SUSPENDED', 'REMOVED'],
#define PENDING @"进行中"
#define ACTIVED @"进行中"
#define SUSPENDED @"已完成"
#define REMOVED @"已完成"

#define KSTATE @{@"PENDING":PENDING,@"ACTIVED":ACTIVED,@"SUSPENDED":SUSPENDED,@"REMOVED":REMOVED}

//常用宏工具
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define nilOrJSONObjectForKey(JSON_, KEY_) [JSON_ objectForKey:KEY_] == [NSNull null] ? nil : [JSON_ valueForKeyPath:KEY_];
#define blankOrJSONObjectForKey(JSON_, KEY_) [JSON_ objectForKey:KEY_] == [NSNull null] ? @"" : [JSON_ valueForKeyPath:KEY_];

#define IITokenRequestUrlServiceConfig     [NSString stringWithFormat:@"%@_%d.iitokenrequesturlserviceconfig_1",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

//是否支持Exchange
#define SupportExchange [NSString stringWithFormat:@"%@_%d_SupportExchange",[IMPUserModel activeInstance].enterprise.code,[IMPUserModel activeInstance].id]

#endif
