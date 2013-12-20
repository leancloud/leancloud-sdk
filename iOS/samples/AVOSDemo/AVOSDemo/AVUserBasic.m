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

-(void)demoResetPassword{
    //假设用户的邮箱是这个 重置密码链接会发到这里 用户打开会重新填写新密码
    NSString *email=@"test@somemail.com";
    
    //如果用户忘记了密码 可以通过这个方法来重置密码
    [AVUser requestPasswordResetForEmailInBackground:@"test@somemail.com" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self log:[NSString stringWithFormat:@"重置密码的连接已经发送到用户邮箱 %@",email]];
        }else{
            [self log:[NSString stringWithFormat:@"重置密码出错 %@",[error description]]];
        }
    }];
}

MakeSourcePath
@end
