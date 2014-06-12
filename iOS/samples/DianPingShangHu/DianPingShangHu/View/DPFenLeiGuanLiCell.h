//
//  DPCaoGaoXiangCell.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-16.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "Type.h"
#import "Tag.h"

@interface DPFenLeiGuanLiCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *numberOfDraft;

- (void)configureWithType:(Type *)type;
- (void)configureWithTag:(Tag *)tag;
	
@end
