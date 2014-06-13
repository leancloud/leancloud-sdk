//
//  Type.m
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-21.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "NSString+Location.h"

@implementation NSString (Location)

+ (NSString *)stringFromLocationX:(NSString *)latitude LocationY:(NSString *)longitude
{
    NSString *locationString = [NSString stringWithFormat:@"%@_%@", latitude, longitude];
    return locationString;;
}

- (NSString *)latitudeString
{
	NSString *latitude = [self componentsSeparatedByString:@"_"][0];
	return latitude;
}

- (NSString *)longitudeString
{
	NSString *longitude = [self componentsSeparatedByString:@"_"][1];
	return longitude;
}

@end
