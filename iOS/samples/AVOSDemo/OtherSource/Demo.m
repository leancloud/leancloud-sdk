//
//  Demo.m
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "Demo.h"
#import <objc/runtime.h>
#import "DemoRunC.h"

@implementation Demo

-(void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

-(void)log:(NSString*)msg{
    NSLog(@"%@",msg);
    NSString *text= self.outputView.text;
    self.outputView.text=[text stringByAppendingFormat:@"\n-------- RUN --------\n%@",msg];
    [self.outputView scrollRectToVisible:CGRectMake(0, self.outputView.contentSize.height, 1, 1) animated:YES];
    [self.controller onFinish];
}

/* 把方法名本地化*/
-(NSString*)localizedNameForMethod:(NSString*)mtd{
    //方法名都是标准骆驼命名法
    //简单的用正在分词
    //每个词都在Localizable.strings做好翻译就组成了一个本地化的显示名称
    NSRegularExpression *re=[[NSRegularExpression alloc] initWithPattern:@"[A-Z]" options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *results= [re matchesInString:mtd options:NSMatchingReportCompletion range:NSMakeRange(0, mtd.length-1)];
    
    if (results.count>0) {
        NSMutableArray *cpt=[NSMutableArray array];
        for (int i=0; i<results.count; i++) {
            NSString *sep=nil;
            NSTextCheckingResult *result=results[i];
            NSUInteger start= result.range.location;
            NSUInteger length=0;
            if (i<results.count-1) {
                NSTextCheckingResult *nextResult=results[i+1];
                length= nextResult.range.location-start;
                
            }else{
                length= mtd.length-start;
            }
            
            sep=[mtd substringWithRange:NSMakeRange(start, length)];
            
            [cpt addObject:NSLocalizedString(sep, nil)];
        }
        
        return [cpt componentsJoinedByString:@""];
    }
    
    return  mtd;
}

-(NSArray*)allDemoMethod{
    
    NSMutableArray * mts=[NSMutableArray array];
    
    Class currentClass = [self class];
    
    // Iterate over all instance methods for this class
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(currentClass, &methodCount);
    unsigned int i = 0;
    for (; i < methodCount; i++) {
        NSString *mtd=[NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding];
        
        NSString *name=[mtd substringFromIndex:4];
        
        
        
        //只显示demo开头的方法
        if ([mtd hasPrefix:@"demo"]) {
            NSDictionary *info=@{
                                 @"name":[self localizedNameForMethod:name],
                                 @"detail":[NSString stringWithFormat:@"方法示例: %@",mtd],
                                 @"method":mtd,
                                 };
            [mts addObject:info];
            
        }
        
    }
    free(methodList);
    
    
    
    return mts;
}

MakeSourcePath
@end
