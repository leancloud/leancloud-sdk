	//
	//  DPWoDeShangHuController.m
	//  DianPingShangHu
	//
	//  Created by 丁道骏 on 14-2-15.
	//  Copyright (c) 2014年 dianping. All rights reserved.
	//

#import "DPWoDeShangHuController.h"

@implementation DPWoDeShangHuController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDataSource) name:DPLoginStatusChangedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDataSource) name:DPLocalObjectUploadedNotification object:nil];
	
	self.myShangHus = [DPConfig sharedConfigInstance].myShangHus;
	
	if (!self.myShangHus) {
		[self initDataSource];
	}
}

- (void)initDataSource
{
	AVUser * currentUser = [AVUser currentUser];
	if (currentUser) {
		[SVProgressHUD showWithStatus:DPFindMyShangHuOnServerWaitingSuggestion];
		[[DPConfig sharedConfigInstance] initMyShangHusWithCompletionBlock:^{
			self.myShangHus = [DPConfig sharedConfigInstance].myShangHus;
			[self.tableView reloadData];
			[SVProgressHUD dismiss];
		} andErrorBlock:nil];
	} else {
		[self performSegueWithIdentifier:@"Login" sender:nil];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setEditing:NO animated:NO];
    
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

#pragma mark - IBActions

- (IBAction)refreshMyShangHu:(id)sender {
	[self initDataSource];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.myShangHus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"DPCaoGaoXiangCell";
	DPCaoGaoXiangCell *caoGaoXiangCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	[caoGaoXiangCell configureWithShangHuOnServer:self.myShangHus[indexPath.row]];
	
	return caoGaoXiangCell;
}

#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowSelectedShangHuOnServer"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		
		AVObject *shangHuOnServer = self.myShangHus[indexPath.row];
		
        DPXiangXiXinXiController *xiangXiXinXiController = (DPXiangXiXinXiController *)[segue destinationViewController];
		xiangXiXinXiController.shangHuOnServer = shangHuOnServer;
		xiangXiXinXiController.viewMode = ViewModeServerEdit;
		
    }
}

@end
