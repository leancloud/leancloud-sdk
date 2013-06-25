//
//  RegisterViewController.h
//  TutorialAVOSCloud
//

#import <UIKit/UIKit.h>


@interface RegisterViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *userRegisterTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordRegisterTextField;


-(IBAction)signUpUserPressed:(id)sender;

@end
