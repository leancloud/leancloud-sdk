//
//  AVSubclassAdvanced.m
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVSubclassAdvanced.h"

//导入AVObject的子类Student
#import "Student.h"

@implementation AVSubclassAdvanced

+(void)initialize{
    /* 重要! 注册子类
     * App生命周期内 只需要执行一次即可
     * 所以也可以放在App开启时, 比如didFinishLaunchingWithOptions
     */
#warning 为了引起你的注意! 如果明白了用法可以删除这行
    [Student registerSubclass];
}


-(void)demoCreateSubclass{
    Student *aStudent=[Student object];
    aStudent.name=@"XiaoMing";
    aStudent.age=12;
    aStudent.gender=GenderMale;
    
    [aStudent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self log:[NSString stringWithFormat:@"创建成功 %@",[aStudent description]]];
        }else{
            [self log:[NSString stringWithFormat:@"创建失败 %@",[error description]]];
        }
    }];
}

MakeSourcePath
@end
