//
//  DPTianJiaCell.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-16.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPXiangXiXinXiCell : UITableViewCell <
    UITextFieldDelegate
>

@property (strong, nonatomic) NSString *fieldKey;
@property (strong, nonatomic) IBOutlet UILabel *fieldLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

- (void)configureOnKey:(NSString *)fieldKey withField:(NSString *)field andContent:(NSString *)content;

@end