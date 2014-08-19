//
//  SourceViewController.h
//  AVOSDemo
//
//  Created by Travis on 13-12-11.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourceViewController : UIViewController
@property(nonatomic, copy) NSString *filePath;
@property (nonatomic) UIWebView *webView;
-(void)loadCode:(NSString *)code;
@end
