//
//  DPTianJiaController.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-15.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPTianJiaController.h"

@interface DPTianJiaController ()

@end

@implementation DPTianJiaController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.generalAddField = [DPConfig sharedConfigInstance].generalAddField;
    self.optionalAddField = [DPConfig sharedConfigInstance].optionalAddField;
    self.addField = [DPConfig sharedConfigInstance].addField;
	
    [self.typePickerController setDataSource:DataSourceType];
	[self.tagPickerController setDataSource:DataSourceTag];
	[self.areaPickerController setDataSource:DataSourceArea];
	[self.typePickerController initDataSource];
	[self.tagPickerController initDataSource];
	[self.areaPickerController initDataSource];
	
	if (self.isEditMode) {
		self.navigationItem.title = @"编辑";
	} else {
		self.navigationItem.title = @"添加";
	}
	
	self.isNeedToBeSave = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.locationInputController initLocationSetting];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[self.locationInputController destroyLocationSetting];
}

- (void)objectDidChange {
	self.isNeedToBeSave = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (IBAction)checkIsNeedToBeSaveBeforeBack:(id)sender
{
	if (self.isNeedToBeSave) {
		UIAlertView *askIfSaveAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"如果直接返回，改动将不会保存！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"直接返回", nil];
		[askIfSaveAlertView show];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSInteger sureToBackButtonIndex = [alertView firstOtherButtonIndex];
    if (sureToBackButtonIndex == buttonIndex) {
		[self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.addField.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.addField allKeys][section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *rowsDictionary = [self.addField allValues][section];
	return rowsDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"DPTianJiaCell";
	DPTianJiaCell *tianJiaCell = [[DPTianJiaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	tianJiaCell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    NSMutableDictionary *rowsDictionary = [self.addField allValues][indexPath.section];
	NSString *keyValues = [rowsDictionary allKeys][indexPath.row];
	NSString *rowValues = [rowsDictionary allValues][indexPath.row];
    
    if (self.isEditMode) {
		
		if (self.isLocal) {
			[tianJiaCell configureOnKey:keyValues withField:rowValues andContent:[self.shangHu valueForKey:keyValues]];
		} else {
			[tianJiaCell configureOnKey:keyValues withField:rowValues andContent:[self.shangHuOnServer valueForKey:keyValues]];
		}
    } else {
        [tianJiaCell configureOnKey:keyValues withField:rowValues];
    }
	
	if ([keyValues isEqualToString:@"type"]) {
		[tianJiaCell configureInputView:self.typePickerView];
		self.typePickerController.delegate = tianJiaCell;
	} else if ([keyValues isEqualToString:@"tag"]) {
		[tianJiaCell configureInputView:self.tagPickerView];
		self.tagPickerController.delegate = tianJiaCell;
	} else if ([keyValues isEqualToString:@"area"]) {
		[tianJiaCell configureInputView:self.areaPickerView];
		self.areaPickerController.delegate = tianJiaCell;
	} else if ([keyValues isEqualToString:@"location"]) {
		[tianJiaCell configureInputView:self.locationInputView];
		self.locationInputController.delegate = tianJiaCell;
	}
    return tianJiaCell;
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)saveAsLocalDraft {
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	ShangHu *shangHu = nil;
    
    if (self.isEditMode) {
        shangHu = self.shangHu;
    } else {
        shangHu = [ShangHu MR_createInContext:localContext];
    }
	
	[self setFieldForObject:shangHu];
	
	[shangHu setValue:[NSDate date] forKey:@"editTime"];
	
	[localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
		if (error) {
			[SVProgressHUD showErrorWithStatus:DPSaveFailedSuggestion];
		} else if (success) {
			[SVProgressHUD showSuccessWithStatus:DPSaveSuccessSuggestion];
			[self.delegate tianJiaController:self didEditObject:shangHu];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
}

- (void)updateSeverInfo {
	AVObject *shangHuOnServerToBeUpdate = [AVObject objectWithoutDataWithClassName:DPServerTableShangHu objectId:self.shangHuOnServer.objectId];
	
	[self setFieldForObject:shangHuOnServerToBeUpdate];
	[shangHuOnServerToBeUpdate setObject:[AVUser currentUser].username forKey:@"author"];
	
    [shangHuOnServerToBeUpdate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
			[SVProgressHUD showSuccessWithStatus:DPSaveSuccessSuggestion];
			[self.delegate tianJiaController:self didEditObject:shangHuOnServerToBeUpdate];
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			UIAlertView *uploadErrorAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPSaveFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
			[uploadErrorAlertView show];
		}
    }];
}

- (void)setFieldForObject:(id)object {
	for (int i = 0; i < [self.addField allValues].count; i ++) {
        NSMutableDictionary *rowsDictionary = [self.addField allValues][i];
        
		for (int j = 0; j < [rowsDictionary allValues].count; j ++) {
            
            DPTianJiaCell *tianJiaCell = (DPTianJiaCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            NSString *key = [rowsDictionary allKeys][j];
			if (self.isLocal) {
				[object setValue:tianJiaCell.fieldTextField.text forKey:key];
			} else {
				[object setObject:tianJiaCell.fieldTextField.text forKey:key];
			}
        }
	}
}

#pragma mark - IBActions
- (IBAction)save:(id)sender {
	if (self.isLocal) {
		[self saveAsLocalDraft];
	} else {
		[self updateSeverInfo];
	}
}

@end
