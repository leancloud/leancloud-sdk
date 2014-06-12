//
//  DPSheZhiController.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-15.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPSheZhiCell.h"

@interface DPSheZhiController : UIViewController <
	UITableViewDelegate,
	UITableViewDataSource
>

@property (nonatomic, strong) NSMutableDictionary *generalSettingField;
@property (nonatomic, strong) NSMutableDictionary *accountSettingField;
@property (nonatomic, strong) NSMutableDictionary *settingField;
@property (strong, nonatomic) IBOutlet UITableView *settingTableView;

@end
