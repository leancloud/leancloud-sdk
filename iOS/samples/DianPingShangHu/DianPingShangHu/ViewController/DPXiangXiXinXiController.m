	//
	//  DPXiangXiXinXiController.m
	//  DianPingShangHu
	//
	//  Created by 丁道骏 on 14-2-16.
	//  Copyright (c) 2014年 dianping. All rights reserved.
	//

#import "DPXiangXiXinXiController.h"

@implementation DPXiangXiXinXiController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	switch (self.viewMode) {
		case ViewModeLocal:
			self.uploadToServerBarButtonItem.enabled = YES;
			self.deleteBarButtonItem.enabled = YES;
			self.addPhotoBarButtonItem.enabled = NO;
			self.photoWallBarButtonItem.enabled = NO;
			self.navigationItem.rightBarButtonItem.enabled = YES;
			break;
			
		case ViewModeServerEdit:
			self.uploadToServerBarButtonItem.enabled = NO;
			self.deleteBarButtonItem.enabled = YES;
			self.addPhotoBarButtonItem.enabled = YES;
			self.photoWallBarButtonItem.enabled = YES;
			self.navigationItem.rightBarButtonItem.enabled = YES;
			break;
			
		case ViewModeServerNoEdit:
			self.uploadToServerBarButtonItem.enabled = NO;
			self.deleteBarButtonItem.enabled = NO;
			self.addPhotoBarButtonItem.enabled = NO;
			self.photoWallBarButtonItem.enabled = YES;
			self.navigationItem.rightBarButtonItem.enabled = NO;
			break;
			
		default:
			break;
	}
	
	self.isNeedUpdateImages = YES;
	self.photos = [NSMutableArray array];
	self.thumbs = [NSMutableArray array];
	self.generalAddField = [DPConfig sharedConfigInstance].generalAddField;
    self.optionalAddField = [DPConfig sharedConfigInstance].optionalAddField;
    self.addField = [DPConfig sharedConfigInstance].addField;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadDraftToServer:) name:DPLoginStatusChangedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageData) name:DPServerObjectUpdatedNotification object:nil];
}

- (void)updateImageData {
	self.isNeedUpdateImages = YES;
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
    static NSString *CellIdentifier = @"DPXiangXiXinXiCell";
    DPXiangXiXinXiCell *xiangXiXinXiCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableDictionary *rowsDictionary = [self.addField allValues][indexPath.section];
	NSString *keyValues = [rowsDictionary allKeys][indexPath.row];
	NSString *rowValues = [rowsDictionary allValues][indexPath.row];
    
	if (self.viewMode == ViewModeLocal) {
		[xiangXiXinXiCell configureOnKey:keyValues withField:rowValues andContent:[self.shangHu valueForKey:keyValues]];
	} else {
		[xiangXiXinXiCell configureOnKey:keyValues withField:rowValues andContent:[self.shangHuOnServer valueForKey:keyValues]];
	}
	
    return xiangXiXinXiCell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sureToDeleteButtonIndex = [alertView firstOtherButtonIndex];
    if (sureToDeleteButtonIndex == buttonIndex) {
		if (self.viewMode == ViewModeLocal) {
			[[DPLocalPersistence sharedLocalPersistenceInstance] deleteObject:self.shangHu withCompletionBlock:^{
				[self.navigationController popViewControllerAnimated:YES];
			} andErrorBlock:nil];
		} else {
			[[DPServerPersistence sharedServerPersistenceInstance] deleteObject:self.shangHuOnServer withCompletionBlock:^{
				[self.navigationController popViewControllerAnimated:YES];
			} andErrorBlock:nil];
		}
    }
}

- (IBAction)deleteCurrentDraft:(id)sender {
    UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您真的要删除该条信息吗？\n该操作无法恢复！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlertView show];
}

- (void)initImageData:(NSString *)objectId WithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock {
	
	AVQuery *query = [AVQuery queryWithClassName:DPServerTableShangHu];
	
	query.cachePolicy = kAVCachePolicyNetworkElseCache;
	query.maxCacheAge = 3600;
	[query includeKey:@"images"];
	
	[query getObjectInBackgroundWithId:objectId block:^(AVObject *object, NSError *error) {
		if (object) {
			NSArray *images = [object objectForKey:@"images"];
			if (images.count == 0) {
				UIAlertView *noImagesAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPNoImagesSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
				[noImagesAlertView show];
				[SVProgressHUD dismiss];
				self.isNeedUpdateImages = YES;
				return;
			}
			for (AVFile *image in images) {
				__block NSMutableArray *errorArray = [NSMutableArray array];
				
				MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:image.url]];
				[image getThumbnail:YES width:100 height:100 withBlock:^(UIImage * thumb, NSError *error) {
					if (thumb) {
						MWPhoto *thumbPhoto = [MWPhoto photoWithImage:thumb];
						[self.thumbs addObject:thumbPhoto];
						[self.photos addObject:photo];
					} else {
						[errorArray addObject:error];
					}
						//NSLog(@"------%d, %d, %d", self.thumbs.count, errorArray.count, images.count);
					if (self.thumbs.count + errorArray.count == images.count) {
						if (completionBlock) {
							completionBlock();
						}
					}
				}];
			}
        } else {
			if (errorBlock) {
				errorBlock();
			}
        }
    }];
}

- (IBAction)enterPhotoWall:(id)sender {
	if (self.isNeedUpdateImages) {
		[self.photos removeAllObjects];
		[self.thumbs removeAllObjects];
		
		[SVProgressHUD showWithStatus:DPGetShangHuImageDataWaitingSuggestion];
		
		[self initImageData:self.shangHuOnServer.objectId WithCompletionBlock:^{
			[SVProgressHUD dismiss];
			self.isNeedUpdateImages = NO;
			[self performSegueWithIdentifier:@"showPhotoWall" sender:self];
		} andErrorBlock:^{
			UIAlertView *loadImagesErrorAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPGetShangHuImageDataFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
			[loadImagesErrorAlertView show];
		}];
	} else {
		[self performSegueWithIdentifier:@"showPhotoWall" sender:self];
	}
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
	if (index < self.thumbs.count)
        return self.thumbs[index];
    return nil;
}

- (IBAction)addImages:(id)sender {
	UIActionSheet *switchCategoryActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取", @"现拍一张", nil];
	
	[switchCategoryActionSheet showFromBarButtonItem:self.uploadToServerBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: {
			UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
			imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
			
			[self presentViewController:imagePickerController animated:YES completion:nil];
			break;
		}
			
		case 1: {
			UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
			imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
			imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
			
			[self presentViewController:imagePickerController animated:YES completion:nil];
			break;
		}
			
		default:
			break;
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	[picker dismissViewControllerAnimated:YES completion:^{
		[self uploadImagesToServer:image];
	}];
}

- (void)uploadImagesToServer:(UIImage *)image
{
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
	__block AVFile *imageFile = [AVFile fileWithName:@"image.JPG" data:imageData];
	[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			[self bindImagesToCurrentInfo:imageFile];
		} else {
			UIAlertView *uploadErrorAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPUpToServerFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
			[uploadErrorAlertView show];
		}
	} progressBlock:^(NSInteger percentDone) {
		[SVProgressHUD showProgress:percentDone / 100.0f status:DPUpToServerWaitingSuggestion maskType:SVProgressHUDMaskTypeGradient];
	}];
}

- (void)bindImagesToCurrentInfo:(AVFile *)file
{
	AVObject *infoToBeUpdate = [AVObject objectWithoutDataWithClassName:DPServerTableShangHu objectId:self.shangHuOnServer.objectId];
	
	[infoToBeUpdate fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
		if (object) {
			[object addObject:file forKey:@"images"];
			[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (succeeded) {
					[[NSNotificationCenter defaultCenter] postNotificationName:DPServerObjectUpdatedNotification object:nil userInfo:@{DPServerObjectIdKey:object.objectId}];
					[SVProgressHUD showSuccessWithStatus:DPUpToServerSuccessSuggestion];
				} else {
					UIAlertView *uploadErrorAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPUpToServerFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
					[uploadErrorAlertView show];
				}
			}];
		} else {
			UIAlertView *uploadErrorAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPUpToServerFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
			[uploadErrorAlertView show];
		}
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadDraftToServer:(id)sender {
	AVUser * currentUser = [AVUser currentUser];
	
	if (currentUser != nil) {
		[[DPServerPersistence sharedServerPersistenceInstance] uploadShangHuToServer:self.shangHu withCompletionBlock:^{
			[[DPLocalPersistence sharedLocalPersistenceInstance] deleteObject:self.shangHu withCompletionBlock:^{
				[[NSNotificationCenter defaultCenter] postNotificationName:DPLocalObjectUploadedNotification object:nil];
				[SVProgressHUD showSuccessWithStatus:DPUpToServerSuccessSuggestion];
				[self.navigationController popViewControllerAnimated:YES];
			} andErrorBlock:nil];
		} andErrorBlock:^{
			UIAlertView *uploadErrorAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPUpToServerFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
			[uploadErrorAlertView show];
		}];
	} else {
		[self performSegueWithIdentifier:@"Login" sender:nil];
	}
}

- (IBAction)editInformation:(id)sender {
	if (self.viewMode == ViewModeLocal) {
		[self performSegueWithIdentifier:@"EditLocalInfo" sender:self];
	} else {
		[self performSegueWithIdentifier:@"EditServerInfo" sender:self];
	}
}

- (void)tianJiaController:(DPTianJiaController *)tianJiaController didEditObject:(id)object
{
	if (self.viewMode == ViewModeLocal) {
		self.shangHu = (ShangHu *)object;
	} else {
		self.shangHuOnServer = (AVObject *)object;
	}
	[self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditLocalInfo"]) {
        DPTianJiaController *tianJiaController = (DPTianJiaController *)[segue destinationViewController];
        tianJiaController.isEditMode = YES;
		tianJiaController.isLocal = YES;
        tianJiaController.shangHu = self.shangHu;
		tianJiaController.delegate = self;
		
    } else if ([[segue identifier] isEqualToString:@"EditServerInfo"]) {
		DPTianJiaController *tianJiaController = (DPTianJiaController *)[segue destinationViewController];
        tianJiaController.isEditMode = YES;
		tianJiaController.isLocal = NO;
        tianJiaController.shangHuOnServer = self.shangHuOnServer;
		tianJiaController.delegate = self;
	} else if ([[segue identifier] isEqualToString:@"showPhotoWall"]) {
		MWPhotoBrowser *browser = (MWPhotoBrowser *)[segue destinationViewController];
		browser.displayActionButton = NO;
		browser.displayNavArrows = YES;
		browser.displaySelectionButtons = NO;
		browser.alwaysShowControls = NO;
		browser.zoomPhotosToFill = YES;
		browser.enableGrid = YES;
		browser.startOnGrid = YES;
		browser.delegate = self;
		[browser setCurrentPhotoIndex:0];
	}
}

@end