//
//  LoginViewController.h
//  TutorialAVOSCloud
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController


@property (nonatomic, strong) IBOutlet UITextField *userTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;


-(IBAction)logInPressed:(id)sender;

@end
