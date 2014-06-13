//
//  DPZhuCeController.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-19.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPZhuCeController.h"

@implementation DPZhuCeController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
	
	[self.usernameTextField becomeFirstResponder];
}

-(IBAction)signUp:(id)sender {
	if (!self.emailTextField.text || !self.usernameTextField.text || !self.passwordTextField.text || [self.emailTextField.text isEqualToString:@""] || [self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
		UIAlertView *emptyFieldAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPEmptyFieldSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
		[emptyFieldAlertView show];
	} else {
		[self sendSignUpRequest];
	}
}

- (void)sendSignUpRequest
{
    AVUser *user = [AVUser user];
	
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
	user.email = self.emailTextField.text;
	
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
			[[NSNotificationCenter defaultCenter] postNotificationName:DPLoginStatusChangedNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
			UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPRegisterFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	if (textField == self.emailTextField) {
		[self signUp:nil];
	} else if (textField == self.passwordTextField) {
		[self.emailTextField becomeFirstResponder];
	} else if (textField == self.usernameTextField) {
		[self.passwordTextField becomeFirstResponder];
	}
	return YES;
}

@end
