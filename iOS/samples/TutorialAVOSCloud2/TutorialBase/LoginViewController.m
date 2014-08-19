//
//  LoginViewController.m
//  TutorialAVOSCloud
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import <AVOSCloud/AVOSCloud.h>

@implementation LoginViewController

@synthesize userTextField = _userTextField, passwordTextField = _passwordTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userTextField.placeholder = @"Your User name";
    self.userTextField.text = @"";
    self.passwordTextField.placeholder = @"Your password";
    self.passwordTextField.text = @"123456";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.userTextField = nil;
    self.passwordTextField = nil;
}


#pragma mark IB Actions

//Login button pressed
-(IBAction)logInPressed:(id)sender
{
    [AVUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
        if (user) {
            //Open the wall
            [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

@end
