# 如何使用AVOS  Cloud的Push功能

本文将向您简单介绍如何使用AVOS cloud的推送功能。


# 登录到Apple的Developer Program Portal

https://developer.apple.com/account/ios/certificate/certificateList.action


创建您的app id，并且选择允许push。并且确保您的apple id不含有通配符

![Apple Developer Program Portal](images/push-apple-developer-port.png)

# 允许app的push功能

![Enable push](images/enable-push.png)

# 导出您的push证书并且保存为.p12格式 

![Export push certification](images/export-certification.png)

**请注意确保您的证书在导出时不带有密码保护**

# 将.p12文件上传到avos cloud

![upload push certification](images/upload-push-certifcation.png)

# 使用您的app id生成对应的provision profile

![dev profile](images/dev-profile.png)

# 添加push相关的代码

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Error %@", str);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"recevied %@", userInfo);
}

```

