//
//  ShangHu.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-25.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShangHu : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * editTime;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * type;

@end
