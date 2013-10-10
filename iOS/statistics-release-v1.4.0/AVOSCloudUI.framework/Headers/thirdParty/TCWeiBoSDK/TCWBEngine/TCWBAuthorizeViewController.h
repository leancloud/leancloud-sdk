//
//  TCWBAuthorizeViewController.h
//  TCWeiBoSDKDemo
//
//  Created by wang ying on 12-9-7.
//  Copyright (c) 2012年 bysft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCWBGlobalUtil.h"

@class TCWBAuthorizeViewController;

@protocol TCWBAuthorizeViewControllerDelegate <NSObject>

@required

//授权成功回调
- (void)authorize:(TCWBAuthorizeViewController *)authorize didSucceedWithAccessToken:(NSString *)code; 
//授权失败回调
- (void)authorize:(TCWBAuthorizeViewController *)authorize didFailuredWithError:(NSError *)error;

@end

@interface TCWBAuthorizeViewController : UIViewController<UIWebViewDelegate, UIAlertViewDelegate>{
    UIWebView                                   *webView;
    UIActivityIndicatorView                     *indicatorView;
        
    NSString                                    *requestURLString;
    NSString                                    *returnCode;
    NSError                                     *err;                   // 假如授权失败，错误描述信息
    id<TCWBAuthorizeViewControllerDelegate>     delegate;
}

@property (nonatomic, retain) NSString                                  *requestURLString;
@property (nonatomic, retain) NSString                                  *returnCode;
@property (nonatomic, retain) NSError                                   *err;
@property (nonatomic, assign) id<TCWBAuthorizeViewControllerDelegate>   delegate;

@end
