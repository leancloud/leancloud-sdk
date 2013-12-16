//
//  DemoRunC.m
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "DemoRunC.h"

@interface DemoRunC ()

@end

@implementation DemoRunC


-(void)run{
    SEL selector = NSSelectorFromString(self.methodName);
    ((void (*)(id, SEL))[self.demo methodForSelector:selector])(self.demo, selector);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UITextView *textView=[[UITextView alloc] initWithFrame:self.view.bounds];
    
    textView.editable=NO;
    textView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:textView];
    
    textView.text=@"点击右上角'运行'按钮查看运行结果";
    
    self.demo.outputView=textView;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"运行" style:UIBarButtonItemStyleBordered target:self action:@selector(run)];
}



@end
