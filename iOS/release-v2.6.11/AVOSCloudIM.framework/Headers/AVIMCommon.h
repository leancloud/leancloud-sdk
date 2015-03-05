//
//  AVIMCommon.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 12/4/14.
//  Copyright (c) 2014 LeanCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVOSCloud/AVOSCloud.h>

//#define AVIM_USE_PROTOCOL_MESSAGE_PACK 1

@class AVIMConversation;

extern NSString *AVOSCloudIMErrorDomain;

extern NSInteger const kAVIMErrorInvalidCommand;
extern NSInteger const kAVIMErrorInvalidArguments;
extern NSInteger const kAVIMErrorConversationNotFound;
extern NSInteger const kAVIMErrorTimeout;
extern NSInteger const kAVIMErrorConnectionLost;
extern NSInteger const kAVIMErrorInvalidData;

typedef void (^AVIMBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^AVIMArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^AVIMConversationResultBlock)(AVIMConversation *conversation, NSError *error);
