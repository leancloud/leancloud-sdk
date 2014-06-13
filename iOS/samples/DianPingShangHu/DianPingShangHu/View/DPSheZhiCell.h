//
//  DPSheZhiCell.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-19.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

@interface DPSheZhiCell : UITableViewCell

@property (strong, nonatomic) NSString *fieldKey;
@property (strong, nonatomic) IBOutlet UILabel *fieldLabel;
@property (strong, nonatomic) IBOutlet UIImageView *fieldIcon;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong, nonatomic) IBOutlet UIButton *logInButton;

- (IBAction)logOut:(id)sender;
- (void)resetToDefaultStatus;
- (void)configureOnKey:(NSString *)fieldKey withField:(NSString *)field andIcon:(UIImage *)icon;

@end