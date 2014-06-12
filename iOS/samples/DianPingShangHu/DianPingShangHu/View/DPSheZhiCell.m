//
//  DPSheZhiCell.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-19.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPSheZhiCell.h"

@implementation DPSheZhiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetToDefaultStatus {
	self.logInButton.hidden = YES;
	self.logOutButton.hidden = YES;
}

- (void)configureOnKey:(NSString *)fieldKey withField:(NSString *)field andIcon:(UIImage *)icon
{
	self.fieldKey = fieldKey;
	self.fieldLabel.text = field;
	self.fieldIcon.image = icon;
    
	if ([self.fieldKey isEqualToString:@"logInLogOut"]) {
		
		[self updateLoginStatus];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginStatus) name:DPLoginStatusChangedNotification object:nil];
	}
}

- (void)updateLoginStatus {
	AVUser * currentUser = [AVUser currentUser];
	
	if (currentUser != nil) {
		NSString *username = currentUser.username;
		self.fieldLabel.text = [NSString stringWithFormat:@"注销%@", username];
		self.logInButton.hidden = YES;
		self.logOutButton.hidden = NO;
	} else {
		self.fieldLabel.text = @"登录";
		self.logInButton.hidden = NO;
		self.logOutButton.hidden = YES;
	}
}

- (IBAction)logOut:(id)sender {
	UIAlertView *logoutAlertView = [[UIAlertView alloc] initWithTitle:@"注销" message:@"您真的要注销吗？\n之后必须重新登录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [logoutAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sureToDeleteButtonIndex = [alertView firstOtherButtonIndex];
    if (sureToDeleteButtonIndex == buttonIndex) {
		[AVUser logOut];
		[self updateLoginStatus];
    }
}

@end
