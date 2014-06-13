//
//  DPFenLeiGuanLiController.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-20.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "Tag.h"
#import "Type.h"
#import "DPFenLeiGuanLiCell.h"

typedef NS_ENUM(NSUInteger, Category) {
	CategoryType = (1UL << 1),
	CategoryTag = (1UL << 2),
};

@interface DPFenLeiGuanLiController : UIViewController <
	NSFetchedResultsControllerDelegate,
	UIAlertViewDelegate,
	UIActionSheetDelegate,
	UITableViewDataSource,
	UITableViewDelegate
>

@property (assign, nonatomic) Category category;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *categoryTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;

- (IBAction)switchCategory:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)addNewCategory:(id)sender;
- (IBAction)enterEditMode:(id)sender;

@end
