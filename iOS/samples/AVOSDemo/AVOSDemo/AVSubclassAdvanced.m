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
