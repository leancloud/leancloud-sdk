//
//  DPSheZhiController.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-15.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPSheZhiController.h"

@implementation DPSheZhiController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.generalSettingField = [DPConfig sharedConfigInstance].generalSettingField;
	self.accountSettingField = [DPConfig sharedConfigInstance].accountSettingField;
	
	self.settingField = [DPConfig sharedConfigInstance].settingField;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.settingField.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.settingField allKeys][section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSMutableDictionary *rowsDictionary = [self.settingField allValues][section];
	return rowsDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DPSheZhiCell";
    DPSheZhiCell *sheZhiCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	[sheZhiCell resetToDefaultStatus];
    NSMutableDictionary *rowsDictionary = [self.settingField allValues][indexPath.section];
	
	NSString *rowKey = [rowsDictionary allKeys][indexPath.row];
	NSString *rowValues = [rowsDictionary allValues][indexPath.row];
	
	[sheZhiCell configureOnKey:rowKey withField:rowValues andIcon:[UIImage imageNamed:rowKey]];
	
	return sheZhiCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableDictionary *rowsDictionary = [self.settingField allValues][indexPath.section];
	NSString *rowKey = [rowsDictionary allKeys][indexPath.row];
	
	if ([rowKey isEqualToString:@"categoryManage"]) {
		[self performSegueWithIdentifier:@"ShowFenLeiGuanLi" sender:self];
	} else if ([rowKey isEqualToString:@"clearCache"]) {
		[self clearCaches];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sureToDeleteButtonIndex = [alertView firstOtherButtonIndex];
    if (sureToDeleteButtonIndex == buttonIndex) {
		[AVFile clearAllCachedFiles];
		[AVQuery clearAllCachedResults];
		[SVProgressHUD showSuccessWithStatus:@"清除缓存成功！"];
    }
}

- (void)clearCaches
{
	UIAlertView *clearCachesAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您真的要清空缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [clearCachesAlertView show];
}

@end