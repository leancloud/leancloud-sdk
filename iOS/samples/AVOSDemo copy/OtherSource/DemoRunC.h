//
//  DemoRunC.h
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Demo.h"

@interface DemoRunC : UIViewController

@property(nonatomic, assign) Demo *demo;

@property(nonatomic, copy) NSString *methodName;

@property(nonatomic, retain) NSString *sourceCode;
@property(nonatomic,weak)UIView *sourceCodeView;

-(void)onFinish;
@end
