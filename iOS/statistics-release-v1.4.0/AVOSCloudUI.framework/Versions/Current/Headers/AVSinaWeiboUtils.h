//
//  AVWeiboUtils.h
//  paas
//
//  Created by Zhu Zeng on 3/18/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "AVOSCloud/AVUser.h"
#import "AVOSCloud/AVConstants.h"
#import "SinaWeibo.h"

@interface AVSinaWeiboUtils : NSObject <SinaWeiboDelegate>

@property (nonatomic, readwrite, strong) SinaWeibo * sinaWeibo;

+(AVSinaWeiboUtils *)sharedInstance;

/*!
 Provides utility functions for working with Weibo in a Paas application.
 
 This class is currently for iOS only.
 */
- (void)initWithAppKey:(NSString *)appKey
             appSecret:(NSString *)appSecrect
        appRedirectURI:(NSString *)appRedirectURI
           andDelegate:(id<SinaWeiboDelegate>)delegate;

// use sso callback 
- (void)initWithAppKey:(NSString *)appKey
             appSecret:(NSString *)appSecrect
        appRedirectURI:(NSString *)appRedirectURI
     ssoCallbackScheme:(NSString *)ssoCallbackScheme
           andDelegate:(id<SinaWeiboDelegate>)delegate;

- (void)applicationDidBecomeActive;
- (BOOL)handleOpenURL:(NSURL *)url;

// Log in using OAuth Web authorization.
// If succeed, sinaweiboDidLogIn will be called.
- (void)logIn;

- (void)logInWithBlock:(PFUserResultBlock)block;

-(void)linkUser:(AVUser *)user
          block:(PFBooleanResultBlock)block;

-(BOOL)isLinkedWithUser:(AVUser *)user;

-(void)unlinkUser:(AVUser *)user
            block:(PFBooleanResultBlock)block;

// Log out.
// If succeed, sinaweiboDidLogOut will be called.
- (void)logOut;

// Check if user has logged in, or the authorization is expired.
- (BOOL)isLoggedIn;
- (BOOL)isAuthorizeExpired;


// isLoggedIn && isAuthorizeExpired
- (BOOL)isAuthValid;

- (SinaWeiboRequest*)requestWithURL:(NSString *)url
                            params:(NSMutableDictionary *)params
                httpMethod:(NSString *)httpMethod
    delegate:(id<SinaWeiboRequestDelegate>)delegate;

-(NSDictionary *)authData;

@end
