//
//  RegisterViewController.h
//  TutorialAVOSCloud
//

#import <UIKit/UIKit.h>


@interface RegisterViewController : UIViewController

@property (nonatomic, strong) UITextField *userRegisterTextField;
@property (nonatomic, strong) UITextField *passwordRegisterTextField;


-(void)signUpUserPressed:(id)sender;

@end
