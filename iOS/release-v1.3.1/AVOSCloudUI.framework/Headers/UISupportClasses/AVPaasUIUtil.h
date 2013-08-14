//
//  AVPaasUIUtil.h
//  paas
//
//  Created by Summer on 13-3-28.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVPaasUIUtil : NSObject

+(BOOL) validateEmail: (NSString *) candidate;
+(BOOL) validateUsername:(NSString *)username;

@end
