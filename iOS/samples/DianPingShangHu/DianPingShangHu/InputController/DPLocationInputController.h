//
//  DPLocationInputView.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-25.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "NSString+Location.h"
#import <CoreLocation/CoreLocation.h>

@class DPLocationInputController;
@protocol DPLocationInputControllerDelegate <NSObject>

@required
- (void)locationInputController:(DPLocationInputController *)locationInputController didLocatedLocation:(NSString *)locationString;

@end

@interface DPLocationInputController : NSObject <
	CLLocationManagerDelegate
>

@property (strong, nonatomic) IBOutlet UILabel *locationXLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationYLabel;
@property (strong, nonatomic) IBOutlet UIButton *locatingButton;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *currentLocationActivityIndicatorView;

@property (nonatomic, weak) id<DPLocationInputControllerDelegate> delegate;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (assign) CLLocationCoordinate2D selectedCoordinate;

- (void)initLocationSetting;
- (void)destroyLocationSetting;

- (IBAction)startLocating:(id)sender;

@end
