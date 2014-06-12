//
//  Type.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-21.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

@interface NSString (Location)

+ (NSString *)stringFromLocationX:(NSString *)latitude LocationY:(NSString *)longitude;

- (NSString *)latitudeString;
- (NSString *)longitudeString;

@end
