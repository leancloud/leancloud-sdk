//
//  AVSignUpViewController.h
//  paas
//
//  Created by Summer on 13-3-26.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVSignUpView.h"
#import "AVOSCloud/AVUser.h"

@protocol AVSignUpViewControllerDelegate;

/*!
 The class that presents and manages a standard authentication interface for signing up a AVUser.
 */
@interface AVSignUpViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

/*! @name Configuring Sign Up Elements */

///
/*!
 A bitmask specifying the log in elements which are enabled in the view.
 enum {
 AVSignUpFieldsUsernameAndPassword = 0,
 AVSignUpFieldsEmail = 1 << 0,
 AVSignUpFieldsAdditional = 1 << 1, // this field can be used for something else
 AVSignUpFieldsSignUpButton = 1 << 2,
 AVSignUpFieldsDismissButton = 1 << 3,
 AVSignUpFieldsDefault = AVSignUpFieldsUsernameAndPassword | AVSignUpFieldsEmail | AVSignUpFieldsSignUpButton | AVSignUpFieldsDismissButton
 };
 */
@property (nonatomic) AVSignUpFields fields;

/// The sign up view. It contains all the enabled log in elements.
@property (nonatomic, readonly, retain) AVSignUpView *signUpView;

/*! @name Configuring Sign Up Behaviors */
/// The delegate that responds to the control events of AVSignUpViewController.
@property (nonatomic, assign) id<AVSignUpViewControllerDelegate> delegate;

@end

/*! @name Notifications */
/// The notification is posted immediately after the sign up succeeds.
extern NSString *const AVSignUpSuccessNotification;

/// The notification is posted immediately after the sign up fails.
/// If the delegate prevents the sign up to start, the notification is not sent.
extern NSString *const AVSignUpFailureNotification;

/// The notification is posted immediately after the user cancels sign up.
extern NSString *const AVSignUpCancelNotification;

/*!
 The protocol defines methods a delegate of a AVSignUpViewController should implement.
 All methods of the protocol are optional.
 */
@protocol AVSignUpViewControllerDelegate <NSObject>
@optional

/*! @name Customizing Behavior */

/*!
 Sent to the delegate to determine whether the sign up request should be submitted to the server.
 @param info a dictionary which contains all sign up information that the user entered.
 @result a boolean indicating whether the sign up should proceed.
 */
- (BOOL)signUpViewController:(AVSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info;

/// Sent to the delegate when a AVUser is signed up.
- (void)signUpViewController:(AVSignUpViewController *)signUpController didSignUpUser:(AVUser *)user;

/// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(AVSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error;

/// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(AVSignUpViewController *)signUpController;
@end


