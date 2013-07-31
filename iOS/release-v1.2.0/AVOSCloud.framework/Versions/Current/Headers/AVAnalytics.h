//
//  AVAnalytics.h
//  AVOS Cloud
//
//  Created by Zhu Zeng on 6/20/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAnalytics : NSObject

+ (void)trackAppOpenedWithLaunchOptions:(NSDictionary *)launchOptions;
+ (void)trackAppOpenedWithRemoteNotificationPayload:(NSDictionary *)userInfo;
+ (void)setChannel:(NSString *)channel;


@end
