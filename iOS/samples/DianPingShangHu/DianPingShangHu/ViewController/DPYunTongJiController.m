	//
	//  DPWoDeShangHuController.m
	//  DianPingShangHu
	//
	//  Created by 丁道骏 on 14-2-15.
	//  Copyright (c) 2014年 dianping. All rights reserved.
	//

#import "DPYunTongJiController.h"

@implementation DPYunTongJiController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDataSourceWithCurrentMode) name:DPLoginStatusChangedNotification object:nil];
	
	self.titleArray = [DPConfig sharedConfigInstance].analyzeMode;
	self.navigationItem.title = self.titleArray[0];
	self.analyzeMode = AnalyzeModeUser;
	
	self.allUsers = [DPConfig sharedConfigInstance].allUsers;
	self.allUserFeedsCount = [DPConfig sharedConfigInstance].allUserFeedsCount;
	
	if (!self.allUsers || !self.allUserFeedsCount) {
		[self initUserModeDataSource];
	}
}

- (void)initDataSourceWithCurrentMode
{
	switch (self.analyzeMode) {
		case AnalyzeModeUser:
			return [self initUserModeDataSource];
			break;
			
		case AnalyzeModeType:
			return [self initTypeModeDataSource];;
			break;
			
		case AnalyzeModeTag:
			return [self initTagModeDataSource];
			break;
            
        case AnalyzeModeArea:
			return [self initAreaModeDataSource];
			break;
			
		default:
			break;
	}
}

- (void)initAreaModeDataSource
{
	AVUser * currentUser = [AVUser currentUser];
	if (currentUser) {
		[SVProgressHUD showWithStatus:DPFindShangHuOnServerWaitingSuggestion];
        [[DPConfig sharedConfigInstance] countAllAreaFeedsWithCompletionBlock:^{
            
            self.defaultArea = [DPConfig sharedConfigInstance].defaultArea;
            self.allAreaFeedsCount = [DPConfig sharedConfigInstance].allAreaFeedsCount;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            
        } andErrorBlock:^{
            
        }];
	} else {
		[self performSegueWithIdentifier:@"Login" sender:nil];
	}
}

- (void)initUserModeDataSource
{
	AVUser * currentUser = [AVUser currentUser];
	if (currentUser) {
		[SVProgressHUD showWithStatus:DPFindShangHuOnServerWaitingSuggestion];
		[[DPConfig sharedConfigInstance] initAllUsersOnServerWithCompletionBlock:^{
			[[DPConfig sharedConfigInstance] countAllUserFeedsWithCompletionBlock:^{
				
				self.allUsers = [DPConfig sharedConfigInstance].allUsers;
				self.allUserFeedsCount = [DPConfig sharedConfigInstance].allUserFeedsCount;
				[self.tableView reloadData];
				[SVProgressHUD dismiss];
				
			} andErrorBlock:^{
				
			}];
		} andErrorBlock:^{
		
		}];
	} else {
		[self performSegueWithIdentifier:@"Login" sender:nil];
	}
}

- (void)initTypeModeDataSource
{
	AVUser * currentUser = [AVUser currentUser];
	if (currentUser) {
		[SVProgressHUD showWithStatus:DPFindShangHuOnServerWaitingSuggestion];
			[[DPConfig sharedConfigInstance] countAllTypeFeedsWithCompletionBlock:^{
				
				self.defaultType = [DPConfig sharedConfigInstance].defaultType;
				self.allTypeFeedsCount = [DPConfig sharedConfigInstance].allTypeFeedsCount;
				[self.tableView reloadData];
				[SVProgressHUD dismiss];
				
			} andErrorBlock:^{
				
			}];
	} else {
		[self performSegueWithIdentifier:@"Login" sender:nil];
	}
}

- (void)initTagModeDataSource
{
	AVUser * currentUser = [AVUser currentUser];
	if (currentUser) {
		[SVProgressHUD showWithStatus:DPFindShangHuOnServerWaitingSuggestion];
			[[DPConfig sharedConfigInstance] countAllTagFeedsWithCompletionBlock:^{
				
				self.defaultTag = [DPConfig sharedConfigInstance].defaultTag;
				self.allTagFeedsCount = [DPConfig sharedConfigInstance].allTagFeedsCount;
				[self.tableView reloadData];
				[SVProgressHUD dismiss];
				
			} andErrorBlock:^{
				
			}];
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

- (IBAction)refreshallUsersShangHus:(id)sender {
	switch (self.analyzeMode) {
		case AnalyzeModeUser: {
			[self initUserModeDataSource];
			break;
		}
		case AnalyzeModeType: {
			[self initTypeModeDataSource];
			break;
		}
		case AnalyzeModeTag: {
			[self initTagModeDataSource];
			break;
		}
        case AnalyzeModeArea: {
			[self initAreaModeDataSource];
			break;
		}
		default:
			break;
	}
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (self.analyzeMode) {
		case AnalyzeModeUser:
			return self.allUsers.count;
			break;
			
		case AnalyzeModeType:
			return self.defaultType.count;
			break;
			
		case AnalyzeModeTag:
			return self.defaultTag.count;
			break;
            
        case AnalyzeModeArea:
			return self.defaultArea.count;
			break;
			
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"DPCaoGaoXiangCell";
	DPCaoGaoXiangCell *caoGaoXiangCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	switch (self.analyzeMode) {
		case AnalyzeModeUser: {
			AVUser *user = self.allUsers[indexPath.row];
			NSNumber *feedCountNumber = (NSNumber *)[self.allUserFeedsCount objectForKey:user.username];
			NSInteger feedCount = [feedCountNumber integerValue];
			[caoGaoXiangCell configureWithUsernameOnServer:user.username andFeedsCount:feedCount];
			break;
		}
			
		case AnalyzeModeType: {
			Type *type = self.defaultType[indexPath.row];
			NSString *typeName = [type valueForKey:@"name"];
			NSNumber *feedCountNumber = (NSNumber *)[self.allTypeFeedsCount objectForKey:typeName];
			NSInteger feedCount = [feedCountNumber integerValue];
			[caoGaoXiangCell configureWithCategoryNameOnServer:typeName andFeedsCount:feedCount];
			break;
		}
			
		case AnalyzeModeTag: {
			Tag *tag = self.defaultTag[indexPath.row];
			NSString *tagName = [tag valueForKey:@"name"];
			NSNumber *feedCountNumber = (NSNumber *)[self.allTagFeedsCount objectForKey:tagName];
			NSInteger feedCount = [feedCountNumber integerValue];
			[caoGaoXiangCell configureWithCategoryNameOnServer:tagName andFeedsCount:feedCount];
			break;
		}
            
        case AnalyzeModeArea: {
			Area *area = self.defaultArea[indexPath.row];
			NSString *areaName = [area valueForKey:@"name"];
			NSNumber *feedCountNumber = (NSNumber *)[self.allAreaFeedsCount objectForKey:areaName];
			NSInteger feedCount = [feedCountNumber integerValue];
			[caoGaoXiangCell configureWithCategoryNameOnServer:areaName andFeedsCount:feedCount];
			break;
		}
			
		default:
			break;
	}
	
	return caoGaoXiangCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[SVProgressHUD showWithStatus:DPFindShangHuOnServerWaitingSuggestion];
	__block NSString *queryValue = nil;
	NSString *queryKey = nil;
	
	switch (self.analyzeMode) {
		case AnalyzeModeUser: {
			AVUser *user = self.allUsers[indexPath.row];
			queryValue = user.username;
			queryKey = @"author";
			break;
		}
			
		case AnalyzeModeType: {
			Type *type = self.defaultType[indexPath.row];
			queryValue = [type valueForKey:@"name"];
			queryKey = @"type";
			break;
		}
			
		case AnalyzeModeTag: {
			Tag *tag = self.defaultTag[indexPath.row];
			queryValue = [tag valueForKey:@"name"];
			queryKey = @"tag";
			break;
		}
            
        case AnalyzeModeArea: {
			Area *area = self.defaultArea[indexPath.row];
			queryValue = [area valueForKey:@"name"];
			queryKey = @"area";
			break;
		}
			
		default:
			break;
	}
	
	if (queryKey && queryValue) {
		[[DPConfig sharedConfigInstance] initFeedsOfQueryKey:queryKey andQueryValue:queryValue WithCompletionBlock:^{
			self.selectedQueryResult = [[DPConfig sharedConfigInstance].allQueryResult objectForKey:queryValue];
			self.selectedQueryKey = queryValue;
			[SVProgressHUD dismiss];
			[self performSegueWithIdentifier:@"showSelectedAnalysis" sender:self];
		} andErrorBlock:^{
			UIAlertView *loadFailedAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPGetServerDataFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
			[loadFailedAlertView show];
		}];
	}
}

- (IBAction)switchCategory:(id)sender
{
	UIActionSheet *switchCategoryActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择统计方式：" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	for (NSString *title in self.titleArray) {
		[switchCategoryActionSheet addButtonWithTitle:title];
	}
	
	[switchCategoryActionSheet addButtonWithTitle:@"取消"];
	[switchCategoryActionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 0: {
			self.analyzeMode = AnalyzeModeUser;
			[self initUserModeDataSource];
			break;
		}
		case 1: {
			self.analyzeMode = AnalyzeModeType;
			[self initTypeModeDataSource];
			break;
		}
		case 2: {
			self.analyzeMode = AnalyzeModeTag;
			[self initTagModeDataSource];
			break;
		}
        case 3: {
			self.analyzeMode = AnalyzeModeArea;
			[self initAreaModeDataSource];
			break;
		}
		default:
			break;
	}
	
	if (buttonIndex < self.titleArray.count) {
		self.navigationItem.title = self.titleArray[buttonIndex];
	}
}

#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSelectedAnalysis"]) {
		
        DPXiangXiTongJiController *xiangXiTongJiController = (DPXiangXiTongJiController *)[segue destinationViewController];
		xiangXiTongJiController.selectedQueryKey = self.selectedQueryKey;
		xiangXiTongJiController.selectedQueryResult = self.selectedQueryResult;
    }
}

@end
