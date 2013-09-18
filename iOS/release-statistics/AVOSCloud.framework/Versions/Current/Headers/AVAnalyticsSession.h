//
//  AVAnalyticsSession.h
//  paas
//
//  Created by Zhu Zeng on 8/15/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAnalyticsSession : NSObject

@property (nonatomic, readwrite, strong) NSMutableArray * activities;
@property (nonatomic, readwrite, strong) NSMutableArray * events;
@property (nonatomic, readwrite, copy) NSString * sessionId;
@property (nonatomic, readwrite) NSTimeInterval start;
@property (nonatomic, readwrite) NSTimeInterval end;
@property (nonatomic, readwrite) NSTimeInterval pause;
@property (nonatomic, readwrite) NSTimeInterval backgroud;
@property (nonatomic, readwrite, copy) NSString * currentActivityName;

-(void)beginSession;
-(void)endSession;
-(void)pauseSession;
-(void)resumeSession;
-(BOOL)shouldRegardAsNewSession;

-(void)addActivity:(NSString *)name seconds:(int)seconds;
-(void)beginActivity:(NSString *)name;
-(void)endActivity:(NSString *)name;

-(void)addEvent:(NSString *)eventId
     attributes:(NSDictionary *)attributes;


-(NSDictionary *)jsonDictionary:(NSDictionary *)additionalInfo;

@end
