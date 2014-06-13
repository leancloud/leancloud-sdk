//
//  DPCaoGaoXiangCell.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-16.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPFenLeiGuanLiCell.h"

@implementation DPFenLeiGuanLiCell

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

- (void)configureWithType:(Type *)type
{
	self.name.text = type.name;
}

- (void)configureWithTag:(Tag *)tag
{
	self.name.text = tag.name;
}

@end
