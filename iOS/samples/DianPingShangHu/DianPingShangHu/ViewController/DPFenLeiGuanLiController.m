	//
	//  DPFenLeiGuanLiController.m
	//  DianPingShangHu
	//
	//  Created by 丁道骏 on 14-2-20.
	//  Copyright (c) 2014年 dianping. All rights reserved.
	//

#import "DPFenLeiGuanLiController.h"

@implementation DPFenLeiGuanLiController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSArray *titleArray = [DPConfig sharedConfigInstance].categoryManageMode;
	self.navigationItem.title = titleArray[0];
	self.category = CategoryTag;
    self.fetchedResultsController = [Tag MR_fetchAllSortedBy:@"name"
												   ascending:NO
											   withPredicate:nil
													 groupBy:nil
													delegate:self
												   inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

#pragma mark - IBActions

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.categoryTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *selectedObject  = [self.fetchedResultsController objectAtIndexPath:indexPath];
		
        [selectedObject MR_deleteInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
			if (error) {

			} else if (success) {

			}
		}];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"DPFenLeiGuanLiCell";
	DPFenLeiGuanLiCell *fenLeiGuanLiCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    Type *type = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [fenLeiGuanLiCell configureWithType:type];
	
	return fenLeiGuanLiCell;
}

#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.categoryTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.categoryTableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		break;
		
        case NSFetchedResultsChangeDelete:
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		break;
		
        case NSFetchedResultsChangeUpdate: {
			DPFenLeiGuanLiCell *fenLeiGuanLiCell = (DPFenLeiGuanLiCell *)[tableView cellForRowAtIndexPath:indexPath];
			Type *type = [self.fetchedResultsController objectAtIndexPath:indexPath];
			[fenLeiGuanLiCell configureWithType:type];
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
		[self.categoryTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
		break;
		
        case NSFetchedResultsChangeDelete:
		[self.categoryTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
		break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.categoryTableView endUpdates];
}

- (IBAction)switchCategory:(id)sender {
	NSArray *titleArray = [DPConfig sharedConfigInstance].categoryManageMode;
	UIActionSheet *switchCategoryActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择查看类别：" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	for (NSString *title in titleArray) {
		[switchCategoryActionSheet addButtonWithTitle:title];
	}
	
	[switchCategoryActionSheet addButtonWithTitle:@"取消"];
	[switchCategoryActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSArray *titleArray = [DPConfig sharedConfigInstance].categoryManageMode;
	
	switch (buttonIndex) {
		case 0: {
			self.category = CategoryTag;
			self.fetchedResultsController = [Tag MR_fetchAllSortedBy:@"name"
														   ascending:NO
													   withPredicate:nil
															 groupBy:nil
															delegate:self
														   inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
			break;
		}
		case 1: {
			self.category = CategoryType;
			self.fetchedResultsController = [Type MR_fetchAllSortedBy:@"name"
															ascending:NO
														withPredicate:nil
															  groupBy:nil
															 delegate:self
															inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
			break;
		}
		default:
			break;
	}
	
	if (buttonIndex < titleArray.count) {
		self.navigationItem.title = titleArray[buttonIndex];
		[self.categoryTableView reloadData];
	}
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addNewCategory:(id)sender {
	UIAlertView *addNewCategoryAlertView = [[UIAlertView alloc] initWithTitle:@"请输入名称：" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
	addNewCategoryAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[addNewCategoryAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sureToAddButtonIndex = [alertView firstOtherButtonIndex];
    if (sureToAddButtonIndex == buttonIndex) {
		UITextField *addTextField = [alertView textFieldAtIndex:0];
		NSString *categoryName = addTextField.text;
		
		[self saveCategoryToLocal:categoryName];
	}
}

- (void)saveCategoryToLocal:(NSString *)categoryName {
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	__block NSManagedObject *objectToBeAdd;
	switch (self.category) {
		case CategoryTag:
			objectToBeAdd = [Tag MR_createInContext:localContext];
			break;
			
		case CategoryType:
			objectToBeAdd = [Type MR_createInContext:localContext];
			break;
			
		default:
			break;
	}
	if (objectToBeAdd) {
		[objectToBeAdd setValue:categoryName forKey:@"name"];
		
		[localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
			if (error) {
				[SVProgressHUD showErrorWithStatus:DPAddFailedSuggestion];
			} else if (success) {
                switch (self.category) {
                    case CategoryTag:
                        [[DPConfig sharedConfigInstance].defaultTag addObject:objectToBeAdd];
                        break;
                        
                    case CategoryType:
                        [[DPConfig sharedConfigInstance].defaultType addObject:objectToBeAdd];
                        break;
                        
                    default:
                        break;
                }
				[SVProgressHUD showSuccessWithStatus:DPAddSuccessSuggestion];
			}
		}];
	}
}

- (IBAction)enterEditMode:(id)sender {
	if (self.categoryTableView.editing) {
		[self.categoryTableView setEditing:NO animated:YES];
		self.editBarButtonItem.title = @"编辑";
	} else {
		[self.categoryTableView setEditing:YES animated:YES];
		self.editBarButtonItem.title = @"完成";
	}
}

@end
