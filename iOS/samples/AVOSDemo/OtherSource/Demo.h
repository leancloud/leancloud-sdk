//
//  Demo.h
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Demo : NSObject
@property(nonatomic,readonly) NSString *sourcePath;
@property(nonatomic,weak) UITextView *outputView;
-(NSArray*)allDemoMethod;

-(void)log:(NSString*)msg;
@end
