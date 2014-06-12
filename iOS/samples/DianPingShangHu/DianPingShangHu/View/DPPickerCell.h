//
//  DPPickerCell.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-21.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

@interface DPPickerCell : UIView

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

- (void)configWithContent:(NSString *)content;

@end
