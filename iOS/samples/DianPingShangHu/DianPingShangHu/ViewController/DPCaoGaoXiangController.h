//
//  DPCaoGaoXiangController.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-15.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPXiangXiXinXiController.h"
#import "DPTianJiaController.h"
#import "ShangHu.h"
#import "DPCaoGaoXiangCell.h"

@interface DPCaoGaoXiangController : UIViewController <
	NSFetchedResultsControllerDelegate,
	UITableViewDataSource,
	UITableViewDelegate
>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (strong, nonatomic) IBOutlet UITableView *draftTableView;

- (IBAction)editDraft:(id)sender;

@end
