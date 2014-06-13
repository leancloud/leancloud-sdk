//
//  DPXiangXiXinXiController.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-16.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "ShangHu.h"
#import "DPXiangXiXinXiCell.h"
#import "DPTianJiaCell.h"
#import "DPXiangXiXinXiController.h"
#import "DPTianJiaController.h"
#import "DPLocalPersistence.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import <MobileCoreServices/MobileCoreServices.h>

typedef NS_ENUM(NSUInteger, ViewMode) {
	ViewModeLocal = (1UL << 1),
	ViewModeServerEdit = (1UL << 2),
	ViewModeServerNoEdit = (1UL << 3),
};

@interface DPXiangXiXinXiController : UIViewController <
NSFetchedResultsControllerDelegate,
UITableViewDataSource,
UITabBarDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
MWPhotoBrowserDelegate,
DPTianJiaControllerDelegate
>

@property (nonatomic, assign) ViewMode viewMode;
@property (nonatomic, assign) BOOL isNeedUpdateImages;

@property (nonatomic, strong) AVObject *shangHuOnServer;
@property (nonatomic, strong) ShangHu *shangHu;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableDictionary *generalAddField;
@property (nonatomic, strong) NSMutableDictionary *optionalAddField;
@property (nonatomic, strong) NSMutableDictionary *addField;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *uploadToServerBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *photoWallBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addPhotoBarButtonItem;

- (IBAction)deleteCurrentDraft:(id)sender;
- (IBAction)addImages:(id)sender;
- (IBAction)uploadDraftToServer:(id)sender;
- (IBAction)enterPhotoWall:(id)sender;
- (IBAction)editInformation:(id)sender;

@end
