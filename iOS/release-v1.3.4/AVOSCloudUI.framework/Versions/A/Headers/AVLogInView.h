//
//  AVLoginView.h
//  paas
//
//  Created by Summer on 13-3-26.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AVLogInFieldsNone = 0,
    AVLogInFieldsUsernameAndPassword = 1 << 0,
    AVLogInFieldsPasswordForgotten = 1 << 1,
    AVLogInFieldsLogInButton = 1 << 2,
    AVLogInFieldsFacebook = 1 << 3,
    AVLogInFieldsTwitter = 1 << 4,
    AVLogInFieldsSignUpButton = 1 << 5,
    AVLogInFieldsDismissButton = 1 << 6,
    AVLogInFieldsSinaWeibo = 1 << 7,
    
    AVLogInFieldsDefault = AVLogInFieldsUsernameAndPassword | AVLogInFieldsLogInButton | AVLogInFieldsSignUpButton | AVLogInFieldsPasswordForgotten | AVLogInFieldsDismissButton
} AVLogInFields;

/*!
 The class provides a standard log in interface for authenticating a AVUser.
 */
@interface AVLogInView : UIView

/*! @name Creating Log In View */
/*!
 Initializes the view with the specified log in elements.
 @param fields A bitmask specifying the log in elements which are enabled in the view
 */
- (id)initWithFields:(AVLogInFields) fields;

/*! @name Customizing the Logo */

/// The logo. By default, it is the AVOS Cloud logo.
@property (nonatomic, retain) UIView *logo;

/*! @name Accessing Log In Elements */

/// The bitmask which specifies the enabled log in elements in the view
@property (nonatomic, readonly, assign) AVLogInFields fields;

/// The username text field. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UITextField *usernameField;

/// The password text field. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UITextField *passwordField;

/// The password forgotten button. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UIButton *passwordForgottenButton;

/// The log in button. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UIButton *logInButton;

/// The Facebook button. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UIButton *facebookButton;

/// The Twitter button. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UIButton *twitterButton;

/// The sign up button. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UIButton *signUpButton;

/// The dismiss button. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UIButton *dismissButton;

/// The dismiss button. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UIButton *sinaWeiboButton;

@end


