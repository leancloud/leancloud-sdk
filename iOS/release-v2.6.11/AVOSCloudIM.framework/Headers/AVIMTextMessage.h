//
//  AVIMTextMessage.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 1/12/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import "AVIMTypedMessage.h"

@interface AVIMTextMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>
+ (instancetype)messageWithText:(NSString *)text
                     attributes:(NSDictionary *)attributes;
@end
