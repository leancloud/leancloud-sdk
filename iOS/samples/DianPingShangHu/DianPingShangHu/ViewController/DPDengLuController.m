//
//  DPDengLuController.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-15.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPDengLuController.h"

@implementation DPDengLuController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.isLogin = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
	
	[self.emailTextField becomeFirstResponder];
}

- (IBAction)cancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(id)sender
{
	if (!self.emailTextField.text || !self.passwordTextField.text || [self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
		UIAlertView *emptyFieldAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPEmptyFieldSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
		[emptyFieldAlertView show];
	} else {
		[self sendLoginRequest];
	}
}

- (void)sendLoginRequest
{
    [AVUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
        if (user) {
			[[NSNotificationCenter defaultCenter] postNotificationName:DPLoginStatusChangedNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPLoginFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [errorAlertView show];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	if (textField == self.emailTextField) {
		[self.passwordTextField becomeFirstResponder];
	} else if (textField == self.passwordTextField) {
		[self login:nil];
	}
	return YES;
}

- (IBAction)forgetPassword:(id)sender {
	if (self.isLogin) {
		self.forgetPasswordBarButtonItem.title = @"登录";
		self.sendVerifyEmailButton.hidden = NO;
		self.loginButton.hidden = YES;
		self.registerButton.hidden = YES;
		self.emailLabel.text = @"电子邮箱：";
		self.emailTextField.placeholder = @"请输入您的电子邮箱";
		self.passwordLabel.hidden = YES;
		self.passwordTextField.hidden = YES;
		self.isLogin = NO;
	} else {
		self.forgetPasswordBarButtonItem.title = @"忘记密码";
		self.sendVerifyEmailButton.hidden = YES;
		self.loginButton.hidden = NO;
		self.registerButton.hidden = NO;
		self.emailLabel.text = @"用 户 名：";
		self.emailTextField.placeholder = @"请输入您的用户名";
		self.passwordLabel.hidden = NO;
		self.passwordTextField.hidden = NO;
		self.isLogin = YES;
	}
}

- (IBAction)sendVerifyEmail:(id)sender {
	if (!self.emailTextField.text || [self.emailTextField.text isEqualToString:@""]) {
		UIAlertView *emptyFieldAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPEmptyFieldSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
		[emptyFieldAlertView show];
	} else {
		[self sendVerifyEmailRequest];
	}
}

- (void)sendVerifyEmailRequest {
	[AVUser requestPasswordResetForEmailInBackground:self.emailTextField.text block:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"发送成功！" message:@"请您前往邮箱重新设置密码！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [errorAlertView show];
		} else {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"发送失败..." message:@"请检查邮箱地址是否有误！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [errorAlertView show];
		}
	}];
}

@end
