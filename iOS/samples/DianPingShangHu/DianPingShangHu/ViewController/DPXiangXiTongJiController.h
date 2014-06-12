//
//  DPXiangXiTongJiController.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-24.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPCaoGaoXiangCell.h"
#import "DPXiangXiXinXiController.h"

@interface DPXiangXiTongJiController : UIViewController <
	UITableViewDataSource,
	UITableViewDelegate
>

@property (strong, nonatomic) NSString *selectedQueryKey;
@property (strong, nonatomic) NSArray *selectedQueryResult;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
