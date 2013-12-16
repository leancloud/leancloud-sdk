//
//  AppDelegate.m
//  AVOSDemo
//
//  Created by Travis on 13-11-5.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoListC.h"


#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

#define AVOSCloudAppID  @"cw87ufwen91hgrcm9iol5engs9w9woooo3gi2p8jy5j1a2hl"
#define AVOSCloudAppKey @"b163v82v1txfnrnylngkmr4elgliih7yk8t9t0w2h73c9ymp"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置AVOSCloud
    [AVOSCloud setApplicationId:AVOSCloudAppID
                      clientKey:AVOSCloudAppKey];
    
    
    //统计应用启动情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    /**可选 统计应用崩溃数据
     *
     * 其他可用方法:
     *
     * * 捕获异常, 并询问用户是否忽略, 可以使应用保持在运行状态而不闪退.
     * [AVAnalytics setCrashReportEnabled:(BOOL) andIgnore:(BOOL)]
     *
     * * 功能同上, 但是可以自定义询问用户的文字
     * [AVAnalytics setCrashReportEnabled:(BOOL) withIgnoreAlertTitle:(NSString *)
     *    andMessage:(NSString *) andQuitTitle:(NSString *) andContinueTitle:(NSString *)]
     */
    [AVAnalytics setCrashReportEnabled:YES];
    
    
    //可选 打开推送功能 因为推送只支持真机上, 我们可以加个编译时判断
    //同样会防止在模拟器运行时得到`didFailToRegisterForRemoteNotificationsWithError`的错误提醒
    
#if !TARGET_IPHONE_SIMULATOR
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
#endif
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController=[self rootController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //推送功能打开时, 注册当前的设备, 同时记录用户活跃, 方便进行有针对的推送
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    
    //可选 但是很重要. 我们可以在任何地方给currentInstallation设置任意值,方便进行有针对的推送
    //比如如果我们知道用户的年龄了,可以加上下面这一行 这样推送时我们可以选择age>20岁的用户进行通知
    //[currentInstallation setObject:@"28" forKey:@"age"];
    
    //我们当然也可以设置根据地理位置提醒 发挥想象力吧!
    
    
    //当然别忘了任何currentInstallation的变更后做保存
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    //可选 通过统计功能追踪打开提醒失败, 或者用户不授权本应用推送
    [AVAnalytics event:@"开启推送失败" label:[error description]];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //可选 通过统计功能追踪通过提醒打开应用的行为
    [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    
    //这儿你可以加入自己的代码 根据推送的数据进行相应处理
}



#pragma mark -
#pragma mark DemoApp的方法, 不需要关注
#pragma mark -

-(UIViewController *)rootController{
    NSDictionary *config=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DemoConfig" ofType:@"plist"]];
    
    NSMutableArray *tabs=[NSMutableArray array];
    
    NSArray *keys=[config allKeys];
    
    for (int i=0; i<keys.count; i++) {
        NSString *key=keys[i];
        id object =config[key];
        if ([object isKindOfClass:[NSArray class]]) {
            DemoListC *listC=[[DemoListC alloc] init];
            listC.title=NSLocalizedString(key, nil);
            listC.tabBarItem.image=[UIImage imageNamed:@"cloud"];
            
            listC.contents=object;
            [tabs addObject:listC];
        }else if ([object isKindOfClass:[NSString class]]) {
            Class cl= NSClassFromString(object);
            if (cl) {
                UIViewController * controller=[[cl alloc] init];
                controller.title=NSLocalizedString(key, nil);
                [tabs addObject:controller];
            }
        }
    }
    
    UITabBarController *tabC=[[UITabBarController alloc] init];
    tabC.delegate=self;
    [tabC setViewControllers:tabs];
    
    tabC.title=[tabs[0] title];
    
    if ([tabC respondsToSelector:@selector(edgesForExtendedLayout)])
        tabC.edgesForExtendedLayout = UIRectEdgeNone;

    
    UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:tabC];
    //nc.navigationBar.barStyle=UIBarStyleBlack;
    return nc;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    tabBarController.title=viewController.title;
}

@end
