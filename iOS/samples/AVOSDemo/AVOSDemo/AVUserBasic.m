//
//  AVUserBasic.m
//  AVOSDemo
//
//  Created by Travis on 13-12-17.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVUserBasic.h"

@implementation AVUserBasic

-(void)demoUserRegister{
    AVUser *user= [AVUser user];
    user.username=@"XiaoMing";
    user.password=@"123456";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self log:[NSString stringWithFormat:@"用户注册成功 %@",[user description]]];
            
            //注册成功后也可以直接通过currentUser获取当前登陆用户
            [self log:[NSString stringWithFormat:@"当前用户 %@",[[AVUser currentUser] username]]];
            
        }else{
            [self log:[NSString stringWithFormat:@"用户注册出错 %@",[error description]]];
        }
    }];
}


-(void)demoUserLogin{
    
    [AVUser logInWithUsernameInBackground:@"XiaoMing" password:@"123456" block:^(AVUser *user, NSError *error) {
        if (user) {
            [self log:[NSString stringWithFormat:@"登陆成功 %@",[user description]]];
            
            //注册成功后也可以直接通过currentUser获取当前登陆用户
            [self log:[NSString stringWithFormat:@"当前用户 %@",[[AVUser currentUser] username]]];
            
        }else{
            [self log:[NSString stringWithFormat:@"登陆出错 %@",[error description]]];
        }
    }];
}
MakeSourcePath
@end
