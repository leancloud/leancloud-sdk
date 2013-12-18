//
//  paas.h
//  paas
//
//  Created by Zhu Zeng on 2/25/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVConstants.h"
#import "AVGeoPoint.h"
#import "AVObject.h"
#import "AVQuery.h"
#import "AVUser.h"
#import "AVFile.h"
#import "AVAnonymousUtils.h"
#import "AVACL.h"
#import "AVInstallation.h"
#import "AVPush.h"
#import "AVOSCloud.h"
#import "AVCloud.h"
#import "AVAnalytics.h"
#import "AVRelation.h"
#import "AVSubclassing.h"

typedef enum AVStorageType : NSInteger {
    AVStorageTypeQiniu = 0,
    AVStorageTypeParse,
    AVStorageTypeS3,
    AVStorageTypeNum
} AVStorageType;

typedef enum AVLogLevel : NSUInteger {
    AVLogLevelNone      = 0,
    AVLogLevelError     = 1 << 0,
    AVLogLevelWarning   = 1 << 1,
    AVLogLevelInfo      = 1 << 2,
    AVLogLevelVerbose   = 1 << 3,
    AVLogLevelDefault   = AVLogLevelError | AVLogLevelWarning
} AVLogLevel;

#define kAVDefaultNetworkTimeoutInterval 10.0

@interface AVOSCloud : NSObject

/** @name Connecting to AVOS Cloud */

/*!
 Sets the applicationId and clientKey of your application.
 @param applicationId The applicaiton id for your AVOS Cloud application.
 @param applicationId The client key for your AVOS Cloud application.
 */
+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;
+ (NSString *)getApplicationId;
+ (NSString *)getClientKey;

+ (void)useAVCloud;
+ (void)setStorageType:(AVStorageType)type;

+ (void)useAVCloudUS;
+ (void)useAVCloudCN;

+ (NSTimeInterval)networkTimeoutInterval;
+ (void)setNetworkTimeoutInterval:(NSTimeInterval)time;

// log
+ (void)setLogLevel:(AVLogLevel)level;
+ (AVLogLevel)logLevel;

#pragma mark Schedule work
// default 30 days
+ (NSInteger)queryCacheExpiredDays;
+ (void)setQueryCacheExpiredDays:(NSInteger)days;
// default 30 days
+ (NSInteger)fileCacheExpiredDays;
+ (void)setFileCacheExpiredDays:(NSInteger)days;


typedef AVUser PFUser;
typedef AVObject PFObject;
typedef AVGeoPoint PFGeoPoint;
typedef AVQuery PFQuery;
typedef AVFile PFFile;
typedef AVAnonymousUtils PFAnonymousUtils;
typedef AVACL PFACL;
typedef AVRole PFRole;
typedef AVInstallation PFInstallation;
typedef AVPush PFPush;
typedef AVOSCloud Parse;
typedef AVCloud PFCloud;
typedef AVAnalytics PFAnalytics;
typedef AVRelation PFRelation;


@end
