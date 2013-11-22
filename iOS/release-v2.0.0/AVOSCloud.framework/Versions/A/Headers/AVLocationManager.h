//
//  AVLocationManager.h
//  paas
//
//  Created by Summer on 13-3-16.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class AVGeoPoint;

@interface AVLocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong, readonly) CLLocation *lastLocation;

+ (AVLocationManager *)sharedInstance;
- (void)updateWithBlock:(void(^)(AVGeoPoint *geoPoint, NSError *error))block;

@end
