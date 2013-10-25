//
//  AVQQUtils.h
//  paas
//
//  Created by Zhu Zeng on 7/24/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCWBEngine.h"

@class AVQQUtils;
@protocol QQWeiboDelegate <NSObject>

@optional

- (void)weiboDidLogIn:(AVQQUtils *)utils;
- (void)weiboDidLogOut:(AVQQUtils *)utils;
- (void)weiboLogInDidCancel:(AVQQUtils *)utils;
- (void)weibo:(AVQQUtils *)utils logInDidFailWithError:(NSError *)error;
- (void)weibo:(AVQQUtils *)utils accessTokenInvalidOrExpired:(NSError *)error;

@end

@interface AVQQUtils : NSObject

@property (nonatomic, readwrite, strong) TCWBEngine * qqEngine;
@property (nonatomic, readwrite, assign) id callerDelegate;

+(AVQQUtils *)sharedInstance;

/*!
 Provides utility functions for working with Weibo in a Paas application.
 
 This class is currently for iOS only.
 */
- (void)initWithAppKey:(NSString *)appKey
             appSecret:(NSString *)appSecrect
        appRedirectURI:(NSString *)appRedirectURI
           andDelegate:(id<QQWeiboDelegate>)delegate;


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





@end
