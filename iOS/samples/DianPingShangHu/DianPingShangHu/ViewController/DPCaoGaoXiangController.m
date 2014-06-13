	//
	//  DPCaoGaoXiangController.m
	//  DianPingShangHu
	//
	//  Created by 丁道骏 on 14-2-15.
	//  Copyright (c) 2014年 dianping. All rights reserved.
	//

#import "DPCaoGaoXiangController.h"
#import "DPAppDelegate.h"

@implementation DPCaoGaoXiangController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationItem.leftBarButtonItem setTitle:@"添加"];
	[self.navigationItem.leftBarButtonItem setTarget:self];
	[self.navigationItem.leftBarButtonItem setAction:@selector(AddNewDraft)];
	
    self.fetchedResultsController = [ShangHu MR_fetchAllSortedBy:@"editTime"
                                                       ascending:NO
                                                   withPredicate:nil
                                                         groupBy:nil
                                                        delegate:self
                                                       inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setEditing:NO animated:NO];
    
	NSIndexPath *tableSelection = [self.draftTableView indexPathForSelectedRow];
	[self.draftTableView deselectRowAtIndexPath:tableSelection animated:NO];
}

#pragma mark - IBActions

- (IBAction)editDraft:(id)sender
{
    if(self.draftTableView.editing) {
        [self.draftTableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
		[self.navigationItem.leftBarButtonItem setTitle:@"添加"];
		[self.navigationItem.leftBarButtonItem setTarget:self];
		[self.navigationItem.leftBarButtonItem setAction:@selector(AddNewDraft)];
	} else {
		[self.draftTableView setEditing:YES animated:YES];
		[self.navigationItem.rightBarButtonItem setTitle:@"完成"];
		[self.navigationItem.leftBarButtonItem setTitle:@"上传"];
		[self.navigationItem.leftBarButtonItem setTarget:self];
		[self.navigationItem.leftBarButtonItem setAction:@selector(uploadAllDraft)];
	}
}

- (void)uploadAllDraft {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
	
	if ([sectionInfo numberOfObjects] == 0) {
		UIAlertView *noDraftAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPNoDraftToUpSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
		[noDraftAlertView show];
		return;
	}
	
	[SVProgressHUD showWithStatus:DPUpToServerWaitingSuggestion];
	
	__block NSMutableArray *uploadedSuccessfulArray = [NSMutableArray array];
	__block NSMutableArray *uploadedFailedArray = [NSMutableArray array];
	__block NSInteger allDraftCount = [sectionInfo numberOfObjects];
	
	for (int i = 0; i < allDraftCount; i ++) {
		ShangHu *shangHu = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		[[DPServerPersistence sharedServerPersistenceInstance] uploadShangHuToServer:shangHu withCompletionBlock:^{
			
			[[DPLocalPersistence sharedLocalPersistenceInstance] deleteObject:shangHu withCompletionBlock:nil andErrorBlock:nil];
			
			[uploadedSuccessfulArray addObject:@"Successful"];
			if (uploadedSuccessfulArray.count + uploadedFailedArray.count == allDraftCount) {
				[self showUploadFinishTipWithSuccessfulCount:uploadedSuccessfulArray.count failedCount:uploadedFailedArray.count];
			}
		} andErrorBlock:^{
			[uploadedFailedArray addObject:@"Failed"];
			if (uploadedSuccessfulArray.count + uploadedFailedArray.count == allDraftCount) {
				[self showUploadFinishTipWithSuccessfulCount:uploadedSuccessfulArray.count failedCount:uploadedFailedArray.count];
			}
		}];
	}
}

- (void)showUploadFinishTipWithSuccessfulCount:(NSInteger)successfulCount failedCount:(NSInteger)failedCount
{
	[SVProgressHUD dismiss];
	NSString *tip = [NSString stringWithFormat:@"上传成功%d个，失败%d个", successfulCount, failedCount];
	if (failedCount > 0) {
		[tip stringByAppendingString:@"\n失败的仍然保存在草稿箱，请稍后再次尝试上传！"];
	}
	
	UIAlertView *uploadFinishAlertView = [[UIAlertView alloc] initWithTitle:nil message:tip delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
	[uploadFinishAlertView show];
}

- (void)AddNewDraft {
	[self performSegueWithIdentifier:@"AddNewDraft" sender:self];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.draftTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShangHu *selectedShangHu  = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [selectedShangHu MR_deleteInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
			if (error) {
				NSLog(@"删除ShangHu出错：%@", [error description]);
			} else if (success) {
				NSLog(@"删除ShangHu成功");
			}
		}];
	}
}

	// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"DPCaoGaoXiangCell";
	DPCaoGaoXiangCell *caoGaoXiangCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    ShangHu *shangHu = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [caoGaoXiangCell configureWithShangHu:shangHu];
	
	return caoGaoXiangCell;
}

#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.draftTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.draftTableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		break;
		
        case NSFetchedResultsChangeDelete:
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		break;
		
        case NSFetchedResultsChangeUpdate: {
			DPCaoGaoXiangCell *caoGaoXiangCell = (DPCaoGaoXiangCell *)[tableView cellForRowAtIndexPath:indexPath];
			ShangHu *shangHu = [self.fetchedResultsController objectAtIndexPath:indexPath];
			[caoGaoXiangCell configureWithShangHu:shangHu];
			break;
		}
        case NSFetchedResultsChangeMove:
		[tableView deleteRowsAtIndexPaths:[NSArray
										   arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[tableView insertRowsAtIndexPaths:[NSArray
										   arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
		[self.draftTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
		break;
		
        case NSFetchedResultsChangeDelete:
		[self.draftTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
		break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.draftTableView endUpdates];
}

#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowSelectedShangHu"]) {
        
        NSIndexPath *indexPath = [self.draftTableView indexPathForSelectedRow];
        ShangHu *selectedShangHu = (ShangHu *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
		
			// Pass the selected book to the new view controller.
        DPXiangXiXinXiController *xiangXiXinXiController = (DPXiangXiXinXiController *)[segue destinationViewController];
		xiangXiXinXiController.viewMode = ViewModeLocal;
        xiangXiXinXiController.shangHu = selectedShangHu;
    } else if ([[segue identifier] isEqualToString:@"AddNewDraft"]) {
        DPTianJiaController *tianJiaController = (DPTianJiaController *)[segue destinationViewController];
        tianJiaController.isEditMode = NO;
		tianJiaController.isLocal = YES;
    }
}

@end
