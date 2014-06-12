//
//  DPAppDelegate.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-13.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "DPAppDelegate.h"

@implementation DPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AVOSCloud setApplicationId:DPApplicationId clientKey:DPClientKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	[MagicalRecord setupCoreDataStackWithStoreNamed:@"DianPing.sqlite"];
	
	DPConfig *config = [DPConfig sharedConfigInstance];
	[config performSelectorOnMainThread:@selector(initConfigData) withObject:nil waitUntilDone:YES];
	
	if (config.isFirstRunning) {
		[config performSelectorOnMainThread:@selector(initDefaultData) withObject:nil waitUntilDone:YES];
	} else {
        [config performSelectorOnMainThread:@selector(initDataBase) withObject:nil waitUntilDone:YES];
    }
	
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

@end
