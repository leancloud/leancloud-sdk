//
//  LoginViewController.h
//  TutorialAVOSCloud
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController


@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *passwordTextField;


-(void)logInPressed:(id)sender;

@end
