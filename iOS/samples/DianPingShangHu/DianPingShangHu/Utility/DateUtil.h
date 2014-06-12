//
//  DateUtil.h
//  xiangqu
//
//  Created by 丁道骏 on 13-12-9.
//  Copyright (c) 2013年 Infinite Reader Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DateType) {
	DateTypeDefault = (1UL << 1),//输出全部年月日
	DateTypeYearMonth = (1UL << 2),//只输出年月
	DateTypeMonthDayHourMinute = (1UL << 3),//输出月日时分
};

#define DateFormatterTypeDefault @"yyyy-MM-dd"

@interface DateUtil : NSObject

@property (strong, nonatomic) NSDateFormatter *formatter;

@property (assign, nonatomic) DateType dateType;

- (id)initWithDateType:(DateType)dateType;
- (NSString *)dateStringWithDate:(NSDate *)date;
- (NSString *)dateWithJsonDateString:(NSString *)jsonDateString;

@end
