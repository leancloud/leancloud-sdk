//
//  TCWBEngine.h
//  TCWeiBoSDK
//  Based on OAuth 2.0
//
//  Created by wang ying on 12-8-13.
//  Copyright (c) 2012年 bysft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCWBRequest.h"
#import "TCWBGlobalUtil.h"
#import "TCWBAuthorizeViewController.h"

#define USE_UI_TWEET

@interface DelegateObject : NSObject
{
	id		delegate;	// 用来保存委托接收体对象, 同时又不会增加delegate的引用计数
}
@property (nonatomic, assign) id		delegate;

@end

@interface TCWBEngine : NSObject <WBRequestDelegate,TCWBAuthorizeViewControllerDelegate>{
    
    NSString            *appKey;
    NSString            *appSecret;
    
    NSString            *accessToken;
    NSString            *name;
    NSString            *openId;
    NSString            *openKey;
    NSString            *refreshToken;
    NSString            *redirectURI;
    NSString            *ip_iphone;
    
    NSString            *publishContent;
    UIImage             *publishImage;
    
    NSTimeInterval      expireTime;             //超时时间
    BOOL                isRefreshTokenSuccess;//刷新token是否成功返回，yes成功，no失败

    id                  temp_delegate;
	SEL                 onSuccessCallback;
	SEL                 onFailureCallback;

    NSMutableArray      *httpRequests;          //存放request请求数组
    UIViewController    *rootViewController;    
}

@property (nonatomic, retain) NSString          *appKey;
@property (nonatomic, retain) NSString          *appSecret;
@property (nonatomic, retain) NSString          *accessToken;
@property (nonatomic, retain) NSString          *name;
@property (nonatomic, retain) NSString          *openId;
@property (nonatomic, retain) NSString          *openKey;
@property (nonatomic, retain) NSString          *refreshToken;
@property (nonatomic, retain) NSString          *redirectURI;
@property (nonatomic, retain) NSString          *ip_iphone;
@property (nonatomic, retain) NSString          *publishContent;
@property (nonatomic, retain) UIImage           *publishImage;
           
@property (nonatomic, assign) UIViewController  *rootViewController;
@property (nonatomic, assign) NSTimeInterval    expireTime;
@property (nonatomic, assign) BOOL              isRefreshTokenSuccess;

/*
 *
 * 初始化TCWBEngine对象
 *
 * @param theAppKey      申请应用时分配给第三方应用程序的App key,
 * @param error          申请应用时分配给第三方应用程序的App secrect,
 * @return id            生成的TCWBEngine对象实例
 */
- (id)initWithAppKey:(NSString *)theAppKey andSecret:(NSString *)theAppSecret 
                andRedirectUrl:(NSString *)theRedirectUrl; 

/*
 * 判断授权是否过期
 *
 * return       未过期返回YES，否则返回NO
 */
- (BOOL)isAuthorizeExpired;

/*
 * 应用内webView方式授权
 *
 * @param  delegate          回调方法接收对象
 * @param  successCallback   接口调用成功回调方法(无参数)
 * @param  failureCallback   接口调用失败回调方法(唯一入参为NSError类型对象)
 *
 */
- (void)logInWithDelegate:(id)requestDelegate  
                onSuccess:(SEL)successCallback 
                onFailure:(SEL)failureCallback;

/*
 * 使用已有授权信息授权
 *
 * @param  theAccessToken    访问api资源的凭证
 * @param  theExpiredTime    accesstoken过期时间
 * @param  theOpenid         用户统一标识，可以唯一标识一个用户
 * @param  theRefreshToken   刷新token
 * @param  delegate          回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 *
 */
- (void)logInWithAccessToken:(NSString *)theAccessToken 
                 expiredTime:(NSString *)theExpiredTime  
                      openID:(NSString *)theOpenid
             andRefreshToken:(NSString *)theRefreshToken 
                    delegate:(id)delegate 
                   onSuccess:(SEL)successCallback 
                   onFailure:(SEL)failureCallback;

/*
 * 注销授权
 *
 * @return  注销成功返回YES，否则返回NO
 */
- (BOOL)logOut;

/*
 * 刷新accessToken
 *
 * @param  appkey          申请应用时分配的app_key
 * @param  grantType       refresh_token
 * @param  refreshtoken    刷新token
 *
 */
- (NSString *)refreshAccessToken:(NSString *)appkey 
                      grant_type:(NSString *)grantType 
                andRefresh_token:(NSString *)refreshtoken;

/*
 * 基础接口请求
 *
 * @param  methodName        访问的接口,比如,"t/add"代表发表一条微博
 * @param  params            请求参数
 * @param  httpMethod        请求类型:"GET"或者"POST"
 * @param  postDataType      请求方式
 * @param  httpHeaderFields  包含httpHeader的信息（字典）
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)initRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(WBRequestPostDataType)postDataType
              andHttpHeaderFields:(NSDictionary *)httpHeaderFields
                         delegate:(id)requestDelegate
                        onSuccess:(SEL)successCallback
                        onFailure:(SEL)failureCallback;

/*
 * 获取主页时间线(statuses/home_timeline)数据
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  flag              分页标识
 * @param  pageTime          本页起始时间
 * @param  reqnum            每次请求记录的条数
 * @param  type              拉取类型
 * @param  contentType       内容过滤
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getHomeTimelinewithFormat:(NSString *)format
                         pageFlag:(NSUInteger)flag 
                         pageTime:(NSString *)pageTime  
                           reqNum:(NSUInteger)reqnum 
                             type:(NSUInteger)type 
                   andContentType:(NSUInteger)contentType 
                      parReserved:(NSDictionary *)parReserved
                         delegate:(id)requestDelegate 
                        onSuccess:(SEL)successCallback 
                        onFailure:(SEL)failureCallback;

/*
 * 发表一条微博(t/add)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  content           微博内容
 * @param  clentip           用户ip
 * @param  longitude         经度
 * @param  latitude          纬度
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)postTextTweetWithFormat:(NSString *)format 
                        content:(NSString *)content 
                       clientIP:(NSString *)clientip  
                      longitude:(NSString *)longitude 
                    andLatitude:(NSString *)latitude 
                    parReserved:(NSDictionary *)parReserved
                       delegate:(id)requestDelegate 
                      onSuccess:(SEL)successCallback 
                      onFailure:(SEL)failuerCallback; 

/*
 * 发表一条带图片的微博(t/add_pic)
 *
 * @param  format           返回数据的格式（当前只支持方式: @"json"）
 * @param  content          微博内容
 * @param  clentip          用户ip
 * @param  compatibleFlag   容错标志
 * @param  longitude        经度
 * @param  latitude         纬度
 * @param  picture          文件域表单名
 * @param  parReserved       附加参数
 * @param  requestDelegate  回调方法接收对象
 * @param  successCallback  接口调用成功回调方法
 * @param  failureCallback  接口调用失败回调方法
 *
 */
- (void)postPictureTweetWithFormat:(NSString *)format 
                              content:(NSString *)content 
                             clientIP:(NSString *)clentip  
                                  pic:(NSData *)picture
                       compatibleFlag:(NSString *)compatibleflag
                            longitude:(NSString *)longitude 
                          andLatitude:(NSString *)latitude
                          parReserved:(NSDictionary *)parReserved
                             delegate:(id)requestDelegate 
                            onSuccess:(SEL)successCallback 
                            onFailure:(SEL)failuerCallback; 

/*
 * 发表一条带网络图片的微博(t/add_pic_url)
 *
 * @param  format           返回数据的格式（当前只支持方式: @"json"）
 * @param  content          微博内容
 * @param  clentip          用户ip
 * @param  picurl           图片的URL地址
 * @param  compatibleFlag   容错标志
 * @param  longitude        经度
 * @param  latitude         纬度
 * @param  parReserved      附加参数
 * @param  requestDelegate  回调方法接收对象
 * @param  successCallback  接口调用成功回调方法
 * @param  failureCallback  接口调用失败回调方法
 */
- (void)postPictureURLTweetWithFormat:(NSString *)format 
                                 content:(NSString *)content 
                                clientIP:(NSString *)clentip  
                                  picURL:(NSString *)picurl
                          compatibleFlag:(NSString *)compatibleflag
                               longitude:(NSString *)longitude 
                             andLatitude:(NSString *)latitude
                             parReserved:(NSDictionary *)parReserved
                                delegate:(id)requestDelegate 
                               onSuccess:(SEL)successCallback 
                               onFailure:(SEL)failuerCallback; 


/*
 * 其他用户发表时间线(statuses/user_timeline)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  flag              分页标识
 * @param  pagetime          本页起始时间
 * @param  reqnum            每次请求记录的条数
 * @param  lastid            用于翻页，和pagetime配合使用
 * @param  fopenids          你需要读取的用户openid列表，用下划线“_”隔开
 * @param  names             你需要读取的用户的用户名
 * @param  type              拉取类型
 * @param  contentType       内容过滤
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getUserTimelineWithFormat:(NSString *)format
                         pageFlag:(NSUInteger)flag 
                         pageTime:(NSString *)pagetime  
                           reqNum:(NSUInteger)reqnum 
                           lastid:(NSString *)lastid
                          fopenID:(NSString *)fopenids
                             name:(NSString *)names
                             type:(NSUInteger)type 
                   andContentType:(NSUInteger)contenttype 
                      parReserved:(NSDictionary *)parReserved
                         delegate:(id)requestDelegate 
                        onSuccess:(SEL)successCallback 
                        onFailure:(SEL)failureCallback;

/*
 * 话题时间线(statuses/ht_timeline_ext)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  reqnum            每次请求记录的条数
 * @param  tweetid           微博帖子ID
 * @param  time              微博帖子生成时间
 * @param  pageflag          翻页标识
 * @param  flag              是否拉取认证用户，用作筛选
 * @param  httext            话题内容
 * @param  htid              话题id
 * @param  type              拉取类型
 * @param  contentType       内容过滤
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)gethtTimelineWithFormat:(NSString *)format
                         reqNum:(NSUInteger)reqnum 
                        tweetID:(NSString *)tweetid  
                           time:(NSString *)time 
                       pageFlag:(NSUInteger)pageflag
                           flag:(NSUInteger)flag
                         htText:(NSString *)httext
                           htID:(NSString *)htid
                           type:(NSUInteger)type 
                 andContentType:(NSUInteger)contentType 
                    parReserved:(NSDictionary *)parReserved
                       delegate:(id)requestDelegate 
                      onSuccess:(SEL)successCallback 
                      onFailure:(SEL)failureCallback;

/*
 * 获取最近使用过的话题(ht/recent_used)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  reqnum            每次请求记录的条数
 * @param  page              页码，从1开始
 * @param  sorttype          排序类型
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)gethtRecentUsedWithFormat:(NSString *)format 
                           reqNum:(NSUInteger)reqnum 
                             page:(NSUInteger)page 
                      andSortType:(NSUInteger)sorttype
                      parReserved:(NSDictionary *)parReserved
                         delegate:(id)requestDelegate
                        onSuccess:(SEL)successCallback
                        onFailure:(SEL)failureCallback;

/*
 * 获取单条微博的转发或点评列表(t/re_list)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  flag              类型标识。0－转播列表，1－点评列表，2－点评与转播列表
 * @param  rootid            转发或回复的微博根结点id
 * @param  pageflag          分页标识，用于翻页
 * @param  pagetime          本页起始时间
 * @param  reqnum            每次请求记录的条数
 * @param  twitterid         微博id
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getTransTweetWithFormat:(NSString *)format 
                           flag:(NSUInteger)flag 
                         rootID:(NSString *)rootid 
                       pageFlag:(NSUInteger)pageflag 
                       pageTime:(NSString *)pagetime 
                         reqNum:(NSUInteger)reqnum 
                     andTweetID:(NSString *)tweetid
                    parReserved:(NSDictionary *)parReserved
                       delegate:(id)requestDelegate 
                      onSuccess:(SEL)successCallback 
                      onFailure:(SEL)failureCallback;

/*
 * 获取已订阅话题列表(fav/list_ht)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  reqnum            请求个数
 * @param  pageflag          翻页标识（0：首页 1：向下翻页 2：向上翻页
 * @param  pagetime          本页起始时间
 * @param  lastid            本页请求起始id
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)gethtFavListWithFormat:(NSString *)format 
                        reqNum:(NSUInteger)reqnum  
                      pageFlag:(NSUInteger)pageflag 
                      pageTime:(NSString*)pagetime 
                     andLastID:(NSString *)lastid
                   parReserved:(NSDictionary *)parReserved
                      delegate:(id)requestDelegate 
                     onSuccess:(SEL)successCallback 
                     onFailure:(SEL)failureCallback;

#pragma mark - get user/ info
/*
 * 获取用户信息(user/info)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 *
 */
- (void)getUserInfoWithFormat:(NSString *)format
                  parReserved:(NSDictionary *)parReserved
                     delegate:(id)requestDelegate 
                    onSuccess:(SEL)successCallback 
                    onFailure:(SEL)failureCallback;

/*
 * 获取其他用户信息(user/other_info)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  name              他人的帐户名
 * @param  fopenid           他人的openid
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getOtherUserInfoWithFormat:(NSString *)format
                              name:(NSString *)name 
                         andOpenID:(NSString *)fopenid 
                       parReserved:(NSDictionary *)parReserved
                          delegate:(id)requestDelegate
                         onSuccess:(SEL)successCallback
                         onFailure:(SEL)failureCallback;

/*
 * 获取其他用户信息(user/infos)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  names             用户id列表,用逗号“,”隔开
 * @param  fopenids          你需要读取的用户openid列表,用下划线“_”隔开
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getInfosWithFormat:(NSString *)format 
                     names:(NSString *)names
                  fopenids:(NSString *)fopenids
               parReserved:(NSDictionary *)parReserved
                  delegate:(id)requestDelegate
                 onSuccess:(SEL)successCallback
                 onFailure:(SEL)failureCallback;

#pragma mark - friend
/*
 * 我收听的人列表(friends/idollist)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  reqnum            请求个数(1-30)
 * @param  startindex        起始位置
 * @param  install           过滤安装应用好友（可选）
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getFriendIdolListWithFormat:(NSString *)format  
                             reqNum:(NSUInteger)reqnum  
                         startIndex:(NSUInteger)startindex 
                         andInstall:(NSUInteger)install 
                        parReserved:(NSDictionary *)parReserved
                           delegate:(id)requestDelegate                  
                          onSuccess:(SEL)successCallback
                          onFailure:(SEL)failureCallback;

/*
 * 我的听众列表(friends/fanslist)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  reqnum            请求个数(1-30)
 * @param  startindex        起始位置
 * @param  mode              获取模式
 * @param  install           过滤安装应用好友（可选）
 * @param  sex               按性别过滤标识
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getFriendFansListWithFormat:(NSString *)format
                             reqNum:(NSUInteger)reqnum
                         startIndex:(NSUInteger)startindex
                               mode:(NSUInteger)mode
                            install:(NSUInteger)install
                             andSex:(NSUInteger)sex
                        parReserved:(NSDictionary *)parReserved
                           delegate:(id)requestDelegate 
                          onSuccess:(SEL)successCallback
                          onFailure:(SEL)failureCallback;

/*
 * 互听关系链列表(friends/mutual_list)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  name              用户帐户名
 * @param  fopenid           用户openid
 * @param  reqnum            请求个数(1-30)
 * @param  startindex        起始位置
 * @param  install           过滤安装应用好友（可选）
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getFriendMutualListWithFormat:(NSString *)format
                                 name:(NSString *)username
                              fopenID:(NSString *)fopenid
                               reqNum:(NSUInteger)reqnum
                           startIndex:(NSUInteger)startindex
                           andInstall:(NSUInteger)install
                          parReserved:(NSDictionary *)parReserved
                             delegate:(id)requestDelegate 
                            onSuccess:(SEL)successCallback
                            onFailure:(SEL)failureCallback;

/*
 * 获取最近联系人列表(friends/get_intimate_friends)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  reqnum            请求个数(1-20)
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getFriendIntimateListWithFormat:(NSString *)format
                              andReqNum:(NSUInteger)reqnum
                            parReserved:(NSDictionary *)parReserved
                               delegate:(id)requestDelegate 
                              onSuccess:(SEL)successCallback
                              onFailure:(SEL)failureCallback;

/*
 * 检测是否是听众或我收听的人(friends/check)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  names             其他人的帐户名列表,用逗号“,”隔开
 * @param  fopenids          其他人的的用户openid列表,用下划线“_”隔开
 * @param  flag              0-检测听众，1-检测收听的人 2-两种关系都检测
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)checkFriendWithFormat:(NSString *)format
                        names:(NSString *)names 
                     fopenIDs:(NSString *)fopenids 
                      andFlag:(NSUInteger)flag
                  parReserved:(NSDictionary *)parReserved
                     delegate:(id)requestDelegate 
                    onSuccess:(SEL)successCallback
                    onFailure:(SEL)failureCallback;

/*
 * 收听某个用户(friends/add)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  names             要收听人的微博帐号列表（非昵称）,用逗号“,”隔开
 * @param  fopenids          你需要读取的用户openid列表,用下划线“_”隔开
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)addFriendsWithFormat:(NSString *)format
                       names:(NSString *)names
                  andOpenIDs:(NSString *)fopenids
                 parReserved:(NSDictionary *)parReserved
                    delegate:(id)requestDelegate
                   onSuccess:(SEL)successCallback 
                   onFailure:(SEL)failureCallback;

#pragma mark - lbs

/*
 * 获取身边的人(lbs/get_around_people)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  longitude         经度
 * @param  latitude          纬度
 * @param  pageinfo          翻页参数
 * @param  pagesize
 * @param  gender
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getAroundPeopleWithFormat:(NSString *)format 
                        longitude:(NSString *)longitude
                         latitude:(NSString *)latitude 
                         pageInfo:(NSString *)pageinfo 
                         pageSize:(NSUInteger)pagesize
                        andGender:(NSUInteger)gender
                      parReserved:(NSDictionary *)parReserved
                         delegate:(id)requestDelegate
                        onSuccess:(SEL)successCallback 
                        onFailure:(SEL)failureCallback;

/*
 * 获取身边最新的微博(lbs/get_around_new)
 *
 * @param  format            返回数据的格式（当前只支持方式: @"json"）
 * @param  longitude         经度
 * @param  latitude          纬度
 * @param  pageinfo          翻页参数
 * @param  pagesize          请求的每页个数（1-50），建议25
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getAroundNewsWithFormat:(NSString *)format
                      longitude:(NSString *)longitude
                       latitude:(NSString *)latitude
                       pageInfo:(NSString *)pageinfo
                    andPageSize:(NSUInteger)pagesize 
                    parReserved:(NSDictionary *)parReserved
                       delegate:(id)requestDelegate
                      onSuccess:(SEL)successCallback 
                      onFailure:(SEL)failureCallback;

/*
 * 通过经纬度获取地理位置
 *
 * @param  lnglat            经纬度值，采用经度在前，纬度在后，经纬度值之间用“,”隔开的方式
 * @param  reqsrc            请求来源，请填写"wb”
 * @param  parReserved       附加参数
 * @param  requestDelegate   回调方法接收对象
 * @param  successCallback   接口调用成功回调方法
 * @param  failureCallback   接口调用失败回调方法
 */
- (void)getMapRegocWithLlnglat:(NSString *)lnglat 
                     andReqSrc:(NSString *)reqsrc
                   parReserved:(NSDictionary *)parReserved
                      delegate:(id)requestDelegate
                     onSuccess:(SEL)successCallback 
                     onFailure:(SEL)failureCallback;

/*
 * 控件接口: 分享接口
 *
 * @param  content              初始内容
 * @param  image                假如有图片包含图片信息
 * @param  reserved             附加参数
 * @param  requestDelegate      回调方法接收对象
 * @param  postStartCallback    分享内容开始发送回调方法
 * @param  successCallback      接口调用成功回调方法
 * @param failureCallback       接口调用失败回调方法
 */
- (void)UIBroadCastMsgWithContent:(NSString *)content 
                         andImage:(UIImage *)image 
                      parReserved:(NSDictionary *)reserved
                         delegate:(id)requestDelegate
                      onPostStart:(SEL)postStartCallback
                    onPostSuccess:(SEL)successCallback
                    onPostFailure:(SEL)failureCallback;

//取消未完成的请求操作    
- (void)cancelAllRequest;
// 取消某个Delegate下所有请求
- (void)cancelSpecifiedDelegateAllRequest:(id)requestDelegate;


/*
 * 控件接口: 转播接口
 * @param  content              初始内容
 * @param  videoImageRefURL     视频url
 * @param  imageRefURL          图片url
 * @param  reserved             附加参数
 * @param  requestDelegate      回调方法接收对象
 * @param  postStartCallback    分享内容开始发送回调方法
 * @param  successCallback      接口调用成功回调方法
 * @param failureCallback       接口调用失败回调方法
 */

- (void)UICreatRebroadWithContent:(NSString *)content 
                      imageRefURL:(NSString *)imageRefURL 
                 videoImageRefURL:(NSString *)videoImageRefURL
                      parReserved:(NSDictionary *)reserved
                         delegate:(id)requestDelegate
                      onPostStart:(SEL)postStartCallback
                        onSuccess:(SEL)successCallBack 
                        onFailure:(SEL)onFailureCallBack;


/*
 * 转发一条微博(t/add_multi)
 * @param  farmat           返回数据的格式（当前只支持方式: @"json"）
 * @param  content          初始内容
 * @param  clentip          用户ip
 * @param  longitude        经度
 * @param  latitude         纬度
 * @param  picurl           图片的URL地址
 * @param  videoURL         视频的url地址
 * @param  musicURL         音乐的url地址
 * @param  musicTitle       音乐的标题
 * @param  musicAuthor      音乐的作者
 * @param  syncflag         微博同步到空间分享标记（可选，0-同步，1-不同步，默认为0）
 * @param  compatibleFlag   容错标志
 * @param  parReserved      附加参数
 * @param  requestDelegate  回调方法接收对象
 * @param  successCallback  接口调用成功回调方法
 * @param  failureCallback  接口调用失败回调方法
*/
- (void)repeatMsgWithFormat:(NSString *)format 
                    content:(NSString *)content 
                   clientip:(NSString *)clientip 
                  longitude:(NSString *)longitude 
                   latitude:(NSString *)latitude 
                     picURL:(NSURL *)picURL 
                   videoURL:(NSURL *)videoURL 
                   musicURL:(NSURL *)musicURL 
                 musicTitle:(NSString *)musicTitle 
                musicAuthor:(NSString *)musicAuthor 
                   syncflag:(NSNumber *)syncflag 
             compatibleflag:(NSNumber *)compatibleflag
                parReserved:(NSDictionary *)parReserved
                   delegate:(id)requestDelegate
                  onSuccess:(SEL)successCallback
                  onFailure:(SEL)failureCallback;


/*
 * 获取视频缩略图(t/getvideoinfo)
 * @param  farmat               返回数据的格式（当前只支持方式: @"json"）
 * @param  videoURL             视频url
 * @param  requestDelegate      回调方法接收对象
 * @param  postStartCallback    分享内容开始发送回调方法
 * @param  successCallback      接口调用成功回调方法
 * @param failureCallback       接口调用失败回调方法
 */

- (void)getViedoMsgWith:(NSString *)farmat 
               videoURL:(NSURL *)videoURL 
               delegate:(id)requestDelegate 
              onSuccess:(SEL)successCallback 
              onFailure:(SEL)failureCallback;
@end
