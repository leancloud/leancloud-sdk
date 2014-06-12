//
//  DPLocationInputView.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-25.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPLocationInputController.h"

@implementation DPLocationInputController

- (void)initLocationSetting
{
	self.selectedCoordinate = kCLLocationCoordinate2DInvalid;
	self.locatingButton.hidden = NO;
	self.currentLocationActivityIndicatorView.hidden = YES;
	[self startUpdatingCurrentLocation];
}

- (void)destroyLocationSetting
{
	self.selectedCoordinate = kCLLocationCoordinate2DInvalid;
	self.locatingButton.hidden = NO;
	self.currentLocationActivityIndicatorView.hidden = YES;
	[self stopUpdatingCurrentLocation];
}

- (IBAction)startLocating:(id)sender {
	[self startUpdatingCurrentLocation];
}

#pragma mark - UI Handling

- (void)showCurrentLocationSpinner:(BOOL)show
{
    if (show) {
		self.locatingButton.hidden = YES;
        [self.currentLocationActivityIndicatorView startAnimating];
		self.currentLocationActivityIndicatorView.hidden = NO;
	}
    else {
		[self.currentLocationActivityIndicatorView stopAnimating];
		self.currentLocationActivityIndicatorView.hidden = YES;
		self.locatingButton.hidden = NO;
	}

}

#pragma mark - CLLocationManagerDelegate

- (void)startUpdatingCurrentLocation
{
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return;
	}
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        self.locationManager.distanceFilter = 10.0f;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	}
    
    [self.locationManager startUpdatingLocation];
    
    [self showCurrentLocationSpinner:YES];
}

- (void)stopUpdatingCurrentLocation
{
    [self.locationManager stopUpdatingLocation];
    
    [self showCurrentLocationSpinner:NO];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
		// if the location is older than 30s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 30) {
        return;
	}
    
    self.selectedCoordinate = [newLocation coordinate];
	self.locationXLabel.hidden = NO;
	self.locationYLabel.hidden = NO;
    
	NSString *latitude = [NSString stringWithFormat:@"%.6f", self.selectedCoordinate.latitude];
	NSString *longitude = [NSString stringWithFormat:@"%.6f", self.selectedCoordinate.longitude];
	self.locationYLabel.text = [NSString stringWithFormat:@"经度：%@", longitude];
	self.locationXLabel.text = [NSString stringWithFormat:@"纬度：%@", latitude];
    
    NSString *locationString = [NSString stringFromLocationX:latitude LocationY:longitude];
	[self.delegate locationInputController:self didLocatedLocation:locationString];
    [self stopUpdatingCurrentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopUpdatingCurrentLocation];
    self.selectedCoordinate = kCLLocationCoordinate2DInvalid;
	
    UIAlertView *locatingFailedAlertView = [[UIAlertView alloc] initWithTitle:nil message:DPLocatingFailedSuggestion delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [locatingFailedAlertView show];
}

@end
