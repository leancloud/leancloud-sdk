//
//  DPTianJiaController.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-15.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "ShangHu.h"
#import "Type.h"
#import "Tag.h"
#import "DPTianJiaCell.h"
#import "DPPickerController.h"
#import "DPLocationInputController.h"

@class DPTianJiaController;
@protocol DPTianJiaControllerDelegate <NSObject>

@required
- (void)tianJiaController:(DPTianJiaController *)tianJiaController didEditObject:(id)object;

@end

@interface DPTianJiaController : UITableViewController <
	UITextFieldDelegate,
	UIAlertViewDelegate
>

@property (nonatomic, weak) id<DPTianJiaControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isEditMode;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, assign) BOOL isNeedToBeSave;

@property (nonatomic, strong) ShangHu *shangHu;
@property (nonatomic, strong) AVObject *shangHuOnServer;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableDictionary *generalAddField;
@property (nonatomic, strong) NSMutableDictionary *optionalAddField;
@property (nonatomic, strong) NSMutableDictionary *addField;
@property (strong, nonatomic) IBOutlet DPPickerController *tagPickerController;
@property (strong, nonatomic) IBOutlet DPPickerController *typePickerController;
@property (strong, nonatomic) IBOutlet DPPickerController *areaPickerController;
@property (strong, nonatomic) IBOutlet DPLocationInputController *locationInputController;
@property (strong, nonatomic) IBOutlet UIPickerView *tagPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *typePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *areaPickerView;
@property (strong, nonatomic) IBOutlet UIView *locationInputView;

- (IBAction)save:(id)sender;
- (IBAction)checkIsNeedToBeSaveBeforeBack:(id)sender;

@end
