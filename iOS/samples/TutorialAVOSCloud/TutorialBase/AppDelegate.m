


#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloud/AVOSCloudUI.h>

#define appID @"pzqxg8l1rpaf8yybfjwy68079fpdsjvf1mtqaezlqqbv4wbc"
#define appKey @"fv7lmu3t4zd5e95tmllur7gtf488aericp85tjy0n80fzbfn"


@implementation AppDelegate

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init AVOS Cloud with app id and app key.
    [AVOSCloud setApplicationId:appID
                   clientKey:appKey];
    [AVOSCloud useAVCloudUS];
    
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
