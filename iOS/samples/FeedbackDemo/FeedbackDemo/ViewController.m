//
//  ViewController.m
//  FeedbackDemo
//
//  Created by yang chaozhong on 4/25/14.
//  Copyright (c) 2014 avoscloud. All rights reserved.
//

#import "ViewController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedbackButtonClicked:(id)sender {
    AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
    [agent showConversations:self title:@"feedback" contact:@"test@avoscloud.com"];
}
@end
