//
//  AVObjectBasic.m
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVObjectBasic.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation AVObjectBasic

-(void)demoCreateObject{
    AVObject *object=[AVObject objectWithClassName:@"Student"];
    [object setObject:@"Mike" forKey:@"name"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSString *msg=nil;
        if (succeeded) {
            msg=[NSString stringWithFormat:@"创建成功: %@",[object description]];
            
        }else{
            msg=[NSString stringWithFormat:@"创建失败: %@",[error description]];
        }
        
        [self log:msg];
    }];
    
}

-(void)demoUpdateObject{
    //我们先创建一个Object 才可以更新
    AVObject *object=[AVObject objectWithClassName:@"Student"];
    [object setObject:@"Mike" forKey:@"name"];
    
    //Object也可以用同步方法保存
    [object save];
    
    [self log:[NSString stringWithFormat:@"创建一个Student, 名字是:%@",[object objectForKey:@"name"]]];
    
    
    //只要有了Object的id, 就可以进行操作了
    AVObject *object2=[AVObject objectWithoutDataWithClassName:@"Student" objectId:object.objectId];
    [object2 setObject:@"Jack" forKey:@"name"];
    [object2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSString *msg=nil;
        if (succeeded) {
            msg=[NSString stringWithFormat:@"更新成功: 名字变成了%@",[object2 objectForKey:@"name"]];
        }else{
            msg=[NSString stringWithFormat:@"更新失败: %@",[error description]];
        }
        [self log:msg];
    }];
    
}

-(void)demoDeleteObject{
    //我们先创建一个Object 才可以删除
    AVObject *object=[AVObject objectWithClassName:@"Student"];
    [object setObject:@"Mike" forKey:@"name"];
    
    //Object也可以用同步方法保存
    [object save];
    
    
    
    AVObject *object2=[AVObject objectWithoutDataWithClassName:@"Student" objectId:object.objectId];
    [object2 deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSString *msg=nil;
        if (succeeded) {
            msg=[NSString stringWithFormat:@"删除成功"];
        }else{
            msg=[NSString stringWithFormat:@"删除失败: %@",[error description]];
        }
        
        [self log:msg];
    }];
    
    
}

-(void)demoGetObject{
    AVObject *object=[AVObject objectWithoutDataWithClassName:@"Student" objectId:@"52a9570be4b0e2db54e5dcea"];
    
    [object fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        NSString *msg=nil;
        if (object) {
            msg=[NSString stringWithFormat:@"获取成功: %@",[object description]];
        }else{
            msg=[NSString stringWithFormat:@"获取失败: %@",[error description]];
        }
        
        [self log:msg];
    }];
    
}


MakeSourcePath
@end
