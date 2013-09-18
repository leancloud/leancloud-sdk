//
//  AVAnalyticsUtils.h
//  paas
//
//  Created by Zhu Zeng on 8/15/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAnalyticsUtils : NSObject

+(NSMutableDictionary *)deviceInfo;
+(NSString *)randomString:(int)length;
+(NSTimeInterval)currentTimestamp;


@end
