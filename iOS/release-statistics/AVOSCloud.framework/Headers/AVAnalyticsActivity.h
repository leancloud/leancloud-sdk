//
//  AVAnalyticsActivity.h
//  paas
//
//  Created by Zhu Zeng on 8/2/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAnalyticsActivity : NSObject

@property (nonatomic, readwrite) NSTimeInterval start;
@property (nonatomic, readwrite) NSTimeInterval end;
@property (nonatomic, readwrite) NSString * activityName;

-(id)initWithName:(NSString *)name;
-(void)updateStartTimeStamp;
-(void)updateEndTimeStamp;
-(NSDictionary *)jsonDictionary;

@end


@interface AVAnalyticsEvent : NSObject

@property (nonatomic, readwrite) NSTimeInterval start;
@property (nonatomic, readwrite) NSTimeInterval end;
@property (nonatomic, readwrite) NSString * eventName;
@property (nonatomic, readwrite) NSMutableDictionary * attributes;

-(id)initWithName:(NSString *)name;
-(void)updateStartTimeStamp;
-(void)updateEndTimeStamp;
-(NSDictionary *)jsonDictionary;

@end