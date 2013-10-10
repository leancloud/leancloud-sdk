//
//  AVLogInViewController.h
//  paas
//
//  Created by Summer on 13-3-26.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVLogInView.h"
#import "AVSignUpViewController.h"
#import "AVOSCloud/AVUser.h"

@protocol AVLogInViewControllerDelegate;

/*!
 The class that presents and manages a standard authentication interface for logging in a AVUser.
 */
@interface AVLogInViewController : UIViewController <UITextFieldDelegate>

/*! @name Configuring Log In Elements */

/*!
 A bitmask specifying the log in elements which are enabled in the view.
 enum {
 AVLogInFieldsNone = 0,
 AVLogInFieldsUsernameAndPassword = 1 << 0,
 AVLogInFieldsPasswordForgotten = 1 << 1,
 AVLogInFieldsLogInButton = 1 << 2,
 AVLogInFieldsFacebook = 1 << 3,
 AVLogInFieldsTwitter = 1 << 4,
 AVLogInFieldsSignUpButton = 1 << 5,
 AVLogInFieldsDismissButton = 1 << 6,
 AVLogInFieldsDefault = AVLogInFieldsUsernameAndPassword | AVLogInFieldsLogInButton | AVLogInFieldsSignUpButton | AVLogInFieldsPasswordForgotten | AVLogInFieldsDismissButton
 };
 */
@property (nonatomic) AVLogInFields fields;

/// The log in view. It contains all the enabled log in elements.
@property (nonatomic, readonly, retain) AVLogInView *logInView;

/*! @name Configuring Log In Behaviors */
/// The delegate that responds to the control events of AVLogInViewController.
@property (nonatomic, assign) id<AVLogInViewControllerDelegate> delegate;

/// The facebook permissions that Facebook log in requests for.
/// If unspecified, the default is basic facebook permissions.
@property (nonatomic, retain) NSArray *facebookPermissions;

/// The sign up controller if sign up is enabled.
/// Use this to configure the sign up view, and the transition animation to the sign up view.
/// The default is a sign up view with a username, a password, a dismiss button and a sign up button.
@property (nonatomic, retain) AVSignUpViewController *signUpController;

@end

/*! @name Notifications */
/// The notification is posted immediately after the log in succeeds.
extern NSString *const AVLogInSuccessNotification;

/// The notification is posted immediately after the log in fails.
/// If the delegate prevents the log in from starting, the notification is not sent.
extern NSString *const AVLogInFailureNotification;

/// The notification is posted immediately after the log in is cancelled.
extern NSString *const AVLogInCancelNotification;

/*!
 The protocol defines methods a delegate of a AVLogInViewController should implement.
 All methods of the protocol are optional.
 */
@protocol AVLogInViewControllerDelegate <NSObject>
@optional

/*! @name Customizing Behavior */

/*!
 Sent to the delegate to determine whether the log in request should be submitted to the server.
 @param username the username the user tries to log in with.
 @param password the password the user tries to log in with.
 @result a boolean indicating whether the log in should proceed.
 */
- (BOOL)logInViewController:(AVLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password;

/*! @name Responding to Actions */
/// Sent to the delegate when a AVUser is logged in.
- (void)logInViewController:(AVLogInViewController *)logInController didLogInUser:(AVUser *)user;

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(AVLogInViewController *)logInController didFailToLogInWithError:(NSError *)error;

/// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(AVLogInViewController *)logInController;
@end


