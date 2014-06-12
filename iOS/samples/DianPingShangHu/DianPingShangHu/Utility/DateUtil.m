//
//  DateUtil.m
//  xiangqu
//
//  Created by 丁道骏 on 13-12-9.
//  Copyright (c) 2013年 Infinite Reader Ltd. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

- (id)initWithDateType:(DateType)dateType {
	if (self == [super init]) {
		self.formatter = [[NSDateFormatter alloc] init];
		self.dateType = dateType;
	}
	
	return self;
}

- (NSString *)dateWithJsonDateString:(NSString *)jsonDateString {
	
	switch (self.dateType) {
		case DateTypeDefault:
			[self.formatter setDateFormat:DateFormatterTypeDefault];
			break;
			
		case DateTypeMonthDayHourMinute:
			[self.formatter setDateFormat:DateFormatterTypeDefault];
			break;
			
		default:
			break;
	}
	
	NSDate* date = [self.formatter dateFromString:jsonDateString];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];

	NSInteger day = [components day];
	NSInteger month= [components month];
	NSInteger year= [components year];
	
	NSString *dateStringAfterFormat;
	
	switch (self.dateType) {
		case DateTypeDefault:
			dateStringAfterFormat = [NSString stringWithFormat:@"%d年%d月%d日", year, month, day];
				//NSLog(@"输出日期：%@", dateStringAfterFormat);
			break;
		case DateTypeMonthDayHourMinute:
			dateStringAfterFormat = [NSString stringWithFormat:@"%d月%d日", month, day];
				//NSLog(@"输出日期：%@", dateStringAfterFormat);
			break;
			
		default:
			break;
	}
	
	return dateStringAfterFormat;
}

- (NSString *)dateStringWithDateUseFormmat:(NSDate *)date {
	
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
	NSInteger year = [components year];
	NSInteger day = [components day];
	NSInteger month= [components month];
	NSInteger hour= [components hour];
	NSInteger minute = [components minute];
	
	NSString *dateStringAfterFormat;
	
	switch (self.dateType) {
		case DateTypeDefault:
			dateStringAfterFormat = [NSString stringWithFormat:@"%d年%d月%d日", year, month, day];
				//NSLog(@"输出日期：%@", dateStringAfterFormat);
			break;
		case DateTypeMonthDayHourMinute:
			dateStringAfterFormat = [NSString stringWithFormat:@"%d月%d日%d时%d分", month, day, hour, minute];
				NSLog(@"输出日期：%@", dateStringAfterFormat);
			break;
			
		default:
			break;
	}
	
	return dateStringAfterFormat;
}

- (NSString *)dateStringWithDate:(NSDate *)date {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM月dd日 HH:mm"];
	NSString *dateString = [formatter stringFromDate:date];
	return dateString;
}

@end
