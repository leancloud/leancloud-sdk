//
//  SourceViewController.m
//  AVOSDemo
//
//  Created by Travis on 13-12-11.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "SourceViewController.h"

static NSString *html=nil;

@interface SourceViewController ()
    @property (nonatomic) UIWebView *webView;
@end

@implementation SourceViewController

+(NSString *)htmlRoot{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"html"];
}

+(void)initialize{
    html=[NSString stringWithContentsOfFile:[[self htmlRoot] stringByAppendingPathComponent:@"index.html"] encoding:NSUTF8StringEncoding error:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.webView.scalesPageToFit=YES;
    self.view.backgroundColor=self.webView.backgroundColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [self.view addSubview:self.webView];
    
    [self performSelector:@selector(loadSource) withObject:nil afterDelay:0.1];
}

-(void)loadSource{
    if (self.filePath) {
        self.title=[self.filePath lastPathComponent];
        
        NSString *code=[NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
        
        if (code) {
            [self.webView
             loadHTMLString:[html stringByReplacingOccurrencesOfString:@"__CODE__" withString:code]
             baseURL:[NSURL fileURLWithPath:[[self class] htmlRoot] isDirectory:YES]];
        }
        
    }
}

@end
