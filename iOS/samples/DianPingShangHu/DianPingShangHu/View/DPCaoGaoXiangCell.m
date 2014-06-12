//
//  DPCaoGaoXiangCell.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-16.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPCaoGaoXiangCell.h"

@implementation DPCaoGaoXiangCell

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

	// Customize the appearance of table view cells.
- (void)configureWithShangHu:(ShangHu *)shangHu {
    
		// Configure the cell to show the book's title
    self.name.text = shangHu.name;

	NSDate *editTime = (NSDate *)[shangHu valueForKey:@"editTime"];
	DateUtil *dateUtil = [[DateUtil alloc] initWithDateType:DateTypeMonthDayHourMinute];
	NSString *editTimeString = [dateUtil dateStringWithDate:editTime];
	
	self.editTime.text = editTimeString;
}

- (void)configureWithShangHuOnServer:(AVObject *)shangHuOnServer
{
	self.name.text = [shangHuOnServer valueForKey:@"name"];
	
	NSDate *editTime = (NSDate *)[shangHuOnServer valueForKey:@"updatedAt"];
	DateUtil *dateUtil = [[DateUtil alloc] initWithDateType:DateTypeMonthDayHourMinute];
	NSString *editTimeString = [dateUtil dateStringWithDate:editTime];
	
	self.editTime.text = editTimeString;
}

- (void)configureWithUsernameOnServer:(NSString *)username andFeedsCount:(NSInteger)count
{
	self.name.text = username;
	self.editTime.text = [NSString stringWithFormat:@"%d个贡献", count];
}

- (void)configureWithCategoryNameOnServer:(NSString *)categoryName andFeedsCount:(NSInteger)count
{
	self.name.text = categoryName;
	self.editTime.text = [NSString stringWithFormat:@"%d条信息", count];
}

@end
