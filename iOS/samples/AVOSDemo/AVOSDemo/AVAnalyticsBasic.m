//
//  AVAnalyticsBasic.m
//  AVOSDemo
//
//  Created by Travis on 13-12-23.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVAnalyticsBasic.h"

@implementation AVAnalyticsBasic

/*
"Reverse"   ="冲正";
"Refund"    ="退货";
"Swip"      ="刷卡";
"Device"    ="刷卡器";
"Cups"      ="CUPS";
*/

-(void)demoAnalyticsDeviceError{
    [AVAnalytics event:@"刷卡器错误"];
}

-(void)demoAnalyticsSwipSuccess{
    [AVAnalytics event:@"刷卡成功"];
}

-(void)demoAnalyticsSwipError{
    [AVAnalytics event:@"刷卡失败"];
}

-(void)demoAnalyticsRefund{
    [AVAnalytics event:@"退货"];
}

-(void)demoAnalyticsReverse{
    [AVAnalytics event:@"冲正"];
}

-(void)demoAnalyticsCupsError{
    [AVAnalytics event:@"CUPS错误"];
}

MakeSourcePath
@end
