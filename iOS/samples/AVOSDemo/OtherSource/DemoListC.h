//
//  DemoListC.h
//  AVOSDemo
//
//  Created by Travis on 13-12-11.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Demo.h"
#import "DemoRunC.h"
@interface DemoListC : UITableViewController

@property(nonatomic,retain) NSArray *contents;

@property(nonatomic,retain) Demo *demo;

@end
