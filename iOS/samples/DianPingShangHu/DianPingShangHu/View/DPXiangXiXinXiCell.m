//
//  DPTianJiaCell.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-16.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPXiangXiXinXiCell.h"

@implementation DPXiangXiXinXiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureOnKey:(NSString *)fieldKey withField:(NSString *)field andContent:(NSString *)content
{
	self.fieldKey = fieldKey;
	self.fieldLabel.text = field;
    self.contentLabel.text = content;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
