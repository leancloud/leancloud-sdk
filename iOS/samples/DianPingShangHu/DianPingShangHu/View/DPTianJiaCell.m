//
//  DPTianJiaCell.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-16.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPTianJiaCell.h"

@implementation DPTianJiaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentViews];
        [self.contentView addSubview:self.fieldLabel];
		[self.contentView addSubview:self.fieldTextField];
    }
    return self;
}

- (void)initContentViews
{
	self.fieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 124, 17)];
	self.fieldLabel.backgroundColor = [UIColor clearColor];
	self.fieldLabel.opaque = YES;
	self.fieldLabel.font = [UIFont fontWithName:@"HeiTi SC" size:13];
	
	self.fieldTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 9, 215, 30)];
	self.fieldTextField.borderStyle = UITextBorderStyleRoundedRect;
	self.fieldTextField.delegate = self;
	self.fieldTextField.returnKeyType = UIReturnKeyDone;
	self.fieldTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.fieldTextField.backgroundColor = [UIColor clearColor];
	self.fieldTextField.opaque = YES;
	self.fieldTextField.font = [UIFont fontWithName:@"HeiTi SC" size:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureOnKey:(NSString *)fieldKey withField:(NSString *)field
{
	[self configureOnKey:fieldKey withField:field andContent:@""];
}

- (void)configureOnKey:(NSString *)fieldKey withField:(NSString *)field andContent:(NSString *)content
{
	self.fieldKey = fieldKey;
	self.fieldLabel.text = field;
	self.fieldTextField.text = content;
}

- (void)configureInputView:(UIView *)inputView {
	self.fieldTextField.inputView = inputView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([self.fieldKey isEqualToString:@"type"] ||
		[self.fieldKey isEqualToString:@"tag"] ||
		[self.fieldKey isEqualToString:@"area"] ||
		[self.fieldKey isEqualToString:@"location"]) {
		return NO;
	} else {
		return YES;
	}
}

- (void)pickerController:(DPPickerController *)pickerController didSelectField:(NSString *)field {
	if (![field isEqualToString:self.fieldTextField.text]) {
		self.fieldTextField.text = field;
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
	}
}

- (void)locationInputController:(DPLocationInputController *)locationInputController didLocatedLocation:(NSString *)locationString {
	if (![locationString isEqualToString:self.fieldTextField.text]) {
		self.fieldTextField.text = locationString;
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
	}
}

@end
