//
//  NSString+AES256.h
//  paas
//
//  Created by Summer on 13-5-23.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES256)
- (NSString *)AES256Encrypt;
- (NSString *)AES256Decrypt;
@end
