//
//  DPCaoGaoXiangCell.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-16.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "ShangHu.h"
#import "DateUtil.h"

@interface DPCaoGaoXiangCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *editTime;

- (void)configureWithShangHu:(ShangHu *)shangHu;
- (void)configureWithShangHuOnServer:(AVObject *)shangHuOnServer;
- (void)configureWithUsernameOnServer:(NSString *)username andFeedsCount:(NSInteger)count;
- (void)configureWithCategoryNameOnServer:(NSString *)categoryName andFeedsCount:(NSInteger)count;

@end
