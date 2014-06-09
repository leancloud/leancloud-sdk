//
//  LoginViewController.m
//  TutorialAVOSCloud
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Constants.h"
#import <AVOSCloud/AVOSCloud.h>
#import "WallPicturesViewController.h"

@implementation LoginViewController

@synthesize userTextField = _userTextField, passwordTextField = _passwordTextField;


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
    self.title = @"Log In";
    self.view.backgroundColor = RGB(50, 50, 50);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 218, 31)];
    textField.center = CGPointMake(self.view.frame.size.width/2, 35);
    textField.font = [UIFont systemFontOfSize:14];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    self.userTextField = textField;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 218, 31)];
    textField.center = CGPointMake(self.view.frame.size.width/2, 75);
    textField.font = [UIFont systemFontOfSize:14];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.secureTextEntry = YES;
    [self.view addSubview:textField];
    self.passwordTextField = textField;
    
    self.userTextField.placeholder = @"Your User name";
    self.userTextField.text = @"";
    self.passwordTextField.placeholder = @"Your password";
    self.passwordTextField.text = @"123456";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 218, 37);
    button.center = CGPointMake(self.view.frame.size.width/2, 120);
    [button setTitleColor:RGB(0, 145, 255) forState:UIControlStateNormal];
    [button setTitle:@"Log In" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(logInPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(85, 156, 0, 0)];
    label.textColor = [UIColor whiteColor];
    label.text = @"New user?";
    label.font = [UIFont systemFontOfSize:17];
    [label sizeToFit];
    [self.view addSubview:label];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(188, 148, 81, 37);
    [button setTitleColor:RGB(0, 145, 255) forState:UIControlStateNormal];
    [button setTitle:@"Sign Up" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Actions

//Login button pressed
-(void)logInPressed:(id)sender
{
    [AVUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
        if (user) {
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

-(void)registerPressed:(id)sender
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
