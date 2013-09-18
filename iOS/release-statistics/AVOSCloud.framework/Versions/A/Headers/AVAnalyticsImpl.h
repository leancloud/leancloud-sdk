//
//  AVAnalyticsImpl.h
//  paas
//
//  Created by Zhu Zeng on 8/2/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVAnalytics.h"
#import "AVAnalyticsActivity.h"

@interface AVAnalyticsImpl : NSObject

@property (nonatomic, readwrite) BOOL enableCrashReport;
@property (nonatomic, readwrite) BOOL enableDebugLog;
@property (nonatomic, readwrite) ReportPolicy reportPolicy;
@property (nonatomic, readwrite, copy) NSString * appKey;
@property (nonatomic, readwrite, copy) NSString * appChannel;
@property (nonatomic, readwrite) double sendInterval;
@property (nonatomic, readwrite, strong) NSMutableArray * sessions;
@property (nonatomic, strong) NSTimer *timer;

+(AVAnalyticsImpl *)sharedInstance;


-(void)beginSession;
-(void)endSession;

-(void)addActivity:(NSString *)name seconds:(int)seconds;
-(void)beginActivity:(NSString *)name;
-(void)endActivity:(NSString *)name;
-(void)addEvent:(NSString *)eventId
     attributes:(NSDictionary *)attributes;

-(int)incMessageCount;
-(BOOL)exceedMessageCountThreshold;
-(void)resetMessageCount;

-(void)reportPolicyChanged;
-(void)sendWithBatch;
-(void)sendWithInterval;

-(NSArray *)allSessionData;
-(void)saveSessionsToServer:(BOOL)clearAfterSave;
-(void)clearAllSessionData;


@end
