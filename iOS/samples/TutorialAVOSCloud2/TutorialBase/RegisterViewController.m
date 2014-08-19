//
//  RegisterViewController.m
//  TutorialAVOSCloud
//
//

#import "RegisterViewController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize userRegisterTextField = _userRegisterTextField, passwordRegisterTextField = _passwordRegisterTextField;


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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userRegisterTextField = nil;
    self.passwordRegisterTextField = nil;
}


#pragma mark IB Actions

////Sign Up Button pressed
-(IBAction)signUpUserPressed:(id)sender
{
    AVUser *user = [AVUser user];
    user.username = self.userRegisterTextField.text;
    user.password = self.passwordRegisterTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //The registration was succesful, go to the wall
            [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];


}

@end
