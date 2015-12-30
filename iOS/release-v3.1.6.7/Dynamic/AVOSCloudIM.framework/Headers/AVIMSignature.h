//
//  AVIMSignature.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 12/4/14.
//  Copyright (c) 2014 LeanCloud Inc. All rights reserved.
//

#import "AVIMCommon.h"

@interface AVIMSignature : NSObject

/**
 *  Signture result signed by server master key.
 */
@property (nonatomic, strong) NSString *signature;

/**
 *  Timestamp used to contruct signature.
 */
@property (nonatomic) int64_t timestamp;

/**
 *  Nonce string used to contruct signature
 */
@property (nonatomic, strong) NSString *nonce;

/**
 *  Error in the course of getting signature from server. Commonly network error. Please set it if any error when getting signature.
 */
@property (nonatomic, strong) NSError *error;

@end

@protocol AVIMSignatureDataSource <NSObject>
@optional

/*!
 对一个操作进行签名. 注意:本调用会在后台线程被执行
 @param clientId - 操作发起人的 id
 @param conversationId － 操作所属对话的 id
 @param action － 操作的种类，主要有：
            "open": 表示登录一个账户
            "start": 表示创建一个对话
            "join": 表示操作发起人要加入对话
            "invite": 表示邀请其他人加入对话
            "kick": 表示从对话中踢出部分人
 @param clientIds － 操作目标的 id 列表
 @return 一个 AVIMSignature 签名对象.
 */
- (AVIMSignature *)signatureWithClientId:(NSString *)clientId
                          conversationId:(NSString *)conversationId
                                  action:(NSString *)action
                       actionOnClientIds:(NSArray *)clientIds;
@end
