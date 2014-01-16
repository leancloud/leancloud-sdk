//
//  TCWBRequest.h
//  WiressWeiBoSDK
//
//  Created by wang ying on 12-8-13.
//  Copyright (c) 2012年 bysft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kWBRequestPostDataTypeNone,
	kWBRequestPostDataTypeNormal,		// for normal data post, such as "user=name&password=psd"
	kWBRequestPostDataTypeMultipart,    // for uploading images and files.
}WBRequestPostDataType;


@class TCWBRequest;

@protocol WBRequestDelegate <NSObject>

@optional

- (void)request:(TCWBRequest *)requests didReceiveResponse:(NSURLResponse *)response;

- (void)request:(TCWBRequest *)requests didReceiveRawData:(NSData *)data;

- (void)request:(TCWBRequest *)requests didFailWithError:(NSError *)error;

- (void)request:(TCWBRequest *)requests didFinishLoadingWithResult:(id)result;

@end

@interface TCWBRequest : NSObject{
    NSString                *url;
    NSString                *httpMethod;
    NSDictionary            *params;
    WBRequestPostDataType   postDataType;
    NSDictionary            *httpHeaderFields;
    
    NSURLConnection         *connection;
    NSMutableData           *responseData;
    
    id<WBRequestDelegate>   delegate;
    BOOL                    complete;

}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *httpMethod;
@property (nonatomic, retain) NSDictionary *params;
@property WBRequestPostDataType postDataType;
@property (nonatomic, retain) NSDictionary *httpHeaderFields;
@property (nonatomic, assign) id<WBRequestDelegate> delegate;
@property (nonatomic, assign) BOOL complete;

/*
 *function: 生成request请求对象
 *
 *@param  url               请求的url，比如http://open.t.qq.com/api/statuses/home_timeline
 *@return request请求
 *
 */
+ (TCWBRequest *)requestWithURL:(NSString *)url;

/*
 *function: 生成request请求对象
 *
 *@param  url               请求的url，比如http://open.t.qq.com/api/statuses/home_timeline
 *@param  httpMethod        请求类型:"GET"或者"POST"
 *@param  params            api请求私有参数字典
 *@param  postDataType      请求方式
 *@param  httpHeaderFields  包含httpHeader的信息（字典）
 *@param  delegate   回调方法接收对象
 *@return request请求
 *
 */
+ (TCWBRequest *)requestWithURL:(NSString *)url 
                   httpMethod:(NSString *)httpMethod 
                       params:(NSDictionary *)params 
                 postDataType:(WBRequestPostDataType)postDataType
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<WBRequestDelegate>)delegate;

/*
 *function: 生成request请求对象
 *
 *@param  url               请求的url，比如http://open.t.qq.com/api/statuses/home_timeline
 *@param  accessToken       访问api资源的凭证
 *@param  appkey            申请应用时分配的app_key
 *@param  openId            用户统一标识，可以唯一标识一个用户
 *@param  clientip          用户ip
 *@param  oauth_version     版本号
 *@param  scope             请求权限范围
 *@param  postDataType      请求方式
 *@param  httpMethod        请求类型:"GET"或者"POST"
 *@param  params            api请求私有参数字典
 *@param  httpHeaderFields  包含httpHeader的信息（字典）
 *@param  requestDelegate   回调方法接收对象
 *@return request请求
 *
 */
+ (TCWBRequest *)requestWithURL:(NSString *)url
                    AccessToken:(NSString *)accessToken 
                         appkey:(NSString *)appkey 
                         openId:(NSString *)openId 
                       clientip:(NSString *)clientip 
                  oauth_version:(NSString *)oauth_version 
                          scope:(NSString *)scope
                   postDataType:(WBRequestPostDataType)postDataType
                     httpMethod:(NSString *)httpMethod 
                         params:(NSDictionary *)params
                    httpHeaderFields:(NSDictionary *)httpHeaderFields
                       delegate:(id<WBRequestDelegate>)requestDelegate;

/*
 *function: 序列化url
 *@param  baseURL         带着授权的url
 *@param  params          私有参数
 *@param  httpMethod      请求类型:"GET"或者"POST"
 *
 */
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

- (NSData *)connect:(NSString *)urlString;
- (void)connect;
- (void)disconnect;

@end
