//
//  AVSignUpView.h
//  paas
//
//  Created by Summer on 13-3-26.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AVSignUpFieldsUsernameAndPassword = 0,
    AVSignUpFieldsEmail = 1 << 0,
    AVSignUpFieldsAdditional = 1 << 1, // this field can be used for something else
    AVSignUpFieldsSignUpButton = 1 << 2,
    AVSignUpFieldsDismissButton = 1 << 3,
    AVSignUpFieldsDefault = AVSignUpFieldsUsernameAndPassword | AVSignUpFieldsEmail | AVSignUpFieldsSignUpButton | AVSignUpFieldsDismissButton
} AVSignUpFields;

/*!
 The class provides a standard sign up interface for authenticating a AVUser.
 */
@interface AVSignUpView : UIScrollView

/*! @name Creating Sign Up View */
/*!
 Initializes the view with the specified sign up elements.
 @param fields A bitmask specifying the sign up elements which are enabled in the view
 */
- (id)initWithFields:(AVSignUpFields) fields;

/*! @name Customizing the Logo */

/// The logo. By default, it is the AVOS Cloud logo.
@property (nonatomic, retain) UIView *logo;

/*! @name Accessing Sign Up Elements */

/// The bitmask which specifies the enabled sign up elements in the view
@property (nonatomic, readonly, assign) AVSignUpFields fields;

/// The username text field.
@property (nonatomic, readonly, retain) UITextField *usernameField;

/// The password text field.
@property (nonatomic, readonly, retain) UITextField *passwordField;

/// The email text field. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UITextField *emailField;

/// The additional text field. It is nil if the element is not enabled.
/// This field is intended to be customized.
@property (nonatomic, readonly, retain) UITextField *additionalField;

/// The sign up button. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UIButton *signUpButton;

/// The dismiss button. It is nil if the element is not enabled.
@property (nonatomic, readonly, retain) UIButton *dismissButton;
@end


