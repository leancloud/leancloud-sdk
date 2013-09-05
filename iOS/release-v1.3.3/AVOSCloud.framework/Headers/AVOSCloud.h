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

+ (void)useParseServer;
+ (void)useAVCloud;
+ (void)setStorageType:(AVStorageType)type;

+ (void)useAVCloudUS;
+ (void)useAVCloudCN;

+ (NSTimeInterval)networkTimeoutInterval;
+ (void)setNetworkTimeoutInterval:(NSTimeInterval)time;

// log
+ (void)setLogLevel:(AVLogLevel)level;
+ (AVLogLevel)logLevel;

#if PAAS_IOS_ONLY
/** @name Configuring Facebook Settings */

/*!
 Sets the Facebook application id that you are using with your AVOS Cloud application. You must set this in
 order to use the Facebook functionality in AVOS Cloud.
 @param applicationId The Facebook application id that you are using with your AVOS Cloud application.
 */
+ (void)setFacebookApplicationId:(NSString *)applicationId __attribute__ ((deprecated));

/*!
 Whether the Facebook application id has been set.
 */
+ (BOOL)hasFacebookApplicationId __attribute__ ((deprecated));

/** @name Configuring UI Settings */

/*!
 Set whether to show offline messages when using a AVOS Cloud view or view controller related classes.
 @param enabled Whether a UIAlert should be shown when the device is offline and network access is required
 from a view or view controller.
 */
+ (void)offlineMessagesEnabled:(BOOL)enabled;

/*!
 Set whether to show an error message when using a AVOS Cloud view or view controller related classes
 and a AVOS Cloud error was generated via a query.
 @param enabled Whether a UIAlert should be shown when a AVOS Cloud error occurs.
 */
+ (void)errorMessagesEnabled:(BOOL)enabled;
+ (NSString *)getFacebookApplicationId __attribute__ ((deprecated));
#endif


typedef AVUser PFUser;
typedef AVObject PFObject;
typedef AVGeoPoint PFGeoPoint;
typedef AVQuery PFQuery;
typedef AVFile PFFile;
typedef AVAnonymousUtils PFAnonymousUtils;
typedef AVACL PFACL;
typedef AVInstallation PFInstallation;
typedef AVPush PFPush;
typedef AVOSCloud Parse;
typedef AVCloud PFCloud;
typedef AVAnalytics PFAnalytics;

@end
