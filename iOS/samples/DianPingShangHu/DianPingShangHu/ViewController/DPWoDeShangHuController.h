//
//  DPWoDeShangHuController.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-15.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPCaoGaoXiangCell.h"
#import "DPXiangXiXinXiController.h"

@interface DPWoDeShangHuController : UIViewController <
	UITableViewDataSource,
	UITableViewDelegate
>

@property (strong, nonatomic) NSMutableArray *myShangHus;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)refreshMyShangHu:(id)sender;

@end
