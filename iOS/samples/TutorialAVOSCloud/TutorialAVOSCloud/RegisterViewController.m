//
//  RegisterViewController.m
//  TutorialAVOSCloud
//
//

#import "RegisterViewController.h"

#import <AVOSCloud/AVOSCloud.h>
#import "Constants.h"
#import "WallPicturesViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize userRegisterTextField = _userRegisterTextField, passwordRegisterTextField = _passwordRegisterTextField;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - View lifecycle
- (void)loadView {
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:super.view.frame];
    self.view = scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Sign Up";
    self.view.backgroundColor = RGB(50, 50, 50);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 218, 31)];
    textField.center = CGPointMake(self.view.frame.size.width/2, 35);
    textField.font = [UIFont systemFontOfSize:14];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    self.userRegisterTextField = textField;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 218, 31)];
    textField.center = CGPointMake(self.view.frame.size.width/2, 75);
    textField.font = [UIFont systemFontOfSize:14];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.secureTextEntry = YES;
    [self.view addSubview:textField];
    self.passwordRegisterTextField = textField;
    
    self.userRegisterTextField.placeholder = @"Username";
    self.userRegisterTextField.text = @"";
    self.passwordRegisterTextField.placeholder = @"Password";
    self.passwordRegisterTextField.text = @"";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 218, 37);
    button.center = CGPointMake(self.view.frame.size.width/2, 120);
    [button setTitleColor:RGB(0, 145, 255) forState:UIControlStateNormal];
    [button setTitle:@"Sign Up" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(signUpUserPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userRegisterTextField = nil;
    self.passwordRegisterTextField = nil;
}


#pragma mark Actions

////Sign Up Button pressed
-(void)signUpUserPressed:(id)sender
{
    AVUser *user = [AVUser user];
    user.username = self.userRegisterTextField.text;
    user.password = self.passwordRegisterTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //The registration was succesful, go to the wall
            //Open the wall
            WallPicturesViewController *vc = [[WallPicturesViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];


}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.userRegisterTextField resignFirstResponder];
    [self.passwordRegisterTextField resignFirstResponder];
}
@end
