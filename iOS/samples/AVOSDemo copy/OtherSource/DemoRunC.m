//
//  DemoRunC.m
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "DemoRunC.h"
#import "SourceViewController.h"

@interface DemoRunC ()
@property(nonatomic,retain)UIBarButtonItem *runBtn;
@end

@implementation DemoRunC

-(void)setDemo:(Demo *)demo{
    _demo=demo;
    demo.controller=self;
}

-(void)run{
    UIActivityIndicatorView *av=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [av startAnimating];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:av];

    
    SEL selector = NSSelectorFromString(self.methodName);
    ((void (*)(id, SEL))[self.demo methodForSelector:selector])(self.demo, selector);
}

-(void)onFinish{
    self.runBtn.title=@"再次运行";
    self.navigationItem.rightBarButtonItem=self.runBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    
	UITextView *textView=[[UITextView alloc] initWithFrame:self.view.bounds];
    
    textView.editable=NO;
    textView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:textView];
    
    textView.text=@"点击右上角'运行'按钮查看运行结果\n";
    
    self.demo.outputView=textView;
    
    self.runBtn=[[UIBarButtonItem alloc] initWithTitle:@"运行" style:UIBarButtonItemStyleBordered target:self action:@selector(run)];
    self.navigationItem.rightBarButtonItem=self.runBtn;
    [self getMethodSourceCode];
}

-(void)getMethodSourceCode{
    if (self.demo.sourcePath) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *code=[NSString stringWithContentsOfFile:self.demo.sourcePath encoding:NSUTF8StringEncoding error:nil];
            
            if (code) {
                //找到这个方法的代码段, 并捕获方法内容
                NSString *ptn=[NSString stringWithFormat:@"-\\s{0,}\\(void\\)\\s{0,}%@\\s{0,}\\{([^-]+)\\}",self.methodName];
                
                NSError *err=nil;
                NSRegularExpression *re=[NSRegularExpression
                                         regularExpressionWithPattern:ptn
                                         options:NSRegularExpressionDotMatchesLineSeparators
                                         error:&err];
                
                if (err) {
                    
                }else{
                    NSTextCheckingResult *result =[re firstMatchInString:code options:NSMatchingReportCompletion range:NSMakeRange(0, code.length)];
                    if (result) {
                        NSString *methodCode=[code substringWithRange:[result rangeAtIndex:1]];
                        
                        //向前缩进一次
                        methodCode=[methodCode stringByReplacingOccurrencesOfString:@"\n    " withString:@"\n"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            SourceViewController *sc=[[SourceViewController alloc] init];
                            [self addChildViewController:sc];
                            [self.view addSubview:sc.webView];
                            self.sourceCodeView=sc.webView;
                            CGRect f=self.demo.outputView.frame;
                            float height=f.size.height*0.5;
                            [UIView animateWithDuration:0.25 animations:^{
                                sc.webView.frame=CGRectMake(0, f.origin.y, f.size.width, height);
                                sc.webView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                                self.demo.outputView.frame=CGRectMake(0, f.origin.y+height, f.size.width, f.size.height-height);
                            }];
                            
                            
                            
                            [sc loadCode:methodCode];
                            
                        });
                    }
                    
                }
            }
            
        });
        
        
        
    }

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||
        toInterfaceOrientation==UIInterfaceOrientationLandscapeRight
        ) {
        if (self.sourceCodeView) {
            
        }
    }
}

@end
