//
//  AVStatus.h
//  paas
//
//  Created by Travis on 13-12-23.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AVUser.h"
#import "AVQuery.h"

@class AVStatus;
typedef void (^AVStatusResultBlock)(AVStatus *status, NSError *error);


/**
 *  发送和获取状态更新和消息
 *  @warning AVStatus是类簇 不可继承
 */
@interface AVStatus : NSObject

/* 此状态在用户Inbox中的ID 
 * @warning 仅用于分片查询,不具有唯一性
 */
@property(nonatomic,readonly) NSUInteger messageId;

/**
 *  状态的创建时间
 */
@property(nonatomic,readonly) NSDate *createdAt;

/**
 *  到达收件箱类型, 默认是`default`,私信是`private`, 可以自定义任何类型
 */
@property(nonatomic,readonly) NSString *inboxType;

/**
 *  状态的内容
 */
@property(nonatomic,strong) NSDictionary *data;

/**
 *  状态的发出"人",可以是AVUser 也可以是任意的AVObject或者NSDictionary
 */
@property(nonatomic,readonly) id source;

/**
 *  获取某条状态
 *
 *  @param objectId 状态的objectId
 *  @param callback 回调结果
 */
+(void)getStatusWithID:(NSString *)objectId andCallback:(AVStatusResultBlock)callback;

/**
 *  删除当前用户发布的某条状态
 *
 *  @param objectId 状态的objectId
 *  @param callback 回调结果
 */
+(void)deleteStatusWithID:(NSString*)objectId andCallback:(AVBooleanResultBlock)callback;

/**
 *  获取当前用户发布的状态
 *
 *  @param sid      从某个状态id开始向下返回. 默认是`0`返回最新的.
 *  @param count    需要返回的条数 默认`100`，最大`100`
 *  @param callback 回调结果
 */
+(void)getStatusesWithMaxID:(NSUInteger)sid count:(NSUInteger)count andCallback:(AVArrayResultBlock)callback;

/**
 *  通过用户ID获取其发布的公开的状态列表
 *
 *  @param userId   用户的objectId
 *  @param sid      从某个状态id开始向下返回. 默认是`0`返回最新的.
 *  @param count    需要返回的条数 默认`100`，最大`100`
 *  @param callback 回调结果
 */
+(void) getStatusesOfUser:(NSString*)userId maxID:(NSUInteger)sid count:(NSUInteger)count andCallback:(AVArrayResultBlock)callback;

/**
 *  获取当前用户收件箱中的状态列表
 *
 *  @param callback 回调结果
 */
+(void)getInboxStatuses:(AVArrayResultBlock)callback;

/**
 *  获取当前用户私信列表
 *
 *  @param callback 回调结果
 */
+(void)getPrivteStatuses:(AVArrayResultBlock)callback;


/**
 *  获取当前用户未读状态条数
 *
 *  @param callback 回调结果
 */
+(void)getInboxUnreadStatusesCount:(AVIntegerResultBlock)callback;

/**
 *  获取当前用户特定类型未读状态条数
 *  @param inboxType 收件箱类型
 *  @param callback 回调结果
 */
+(void)getInboxUnreadStatusesCountWithInboxType:(NSString*)inboxType andCallback:(AVIntegerResultBlock)callback;

/**
 *  向用户的粉丝发送新状态
 *
 *  @param  status 状态
 *  @param  callback 回调结果
 */
+(void)sendStatusToFollowers:(AVStatus*)status andCallback:(AVBooleanResultBlock)callback;

/**
 *  向用户发私信
 *
 *  @param  status 状态
 *  @param  userId 接受私信的用户objectId
 *  @param  callback 回调结果
 */
+(void)sendPrivateStatus:(AVStatus*)status toUserWithID:(NSString*)userId andCallback:(AVBooleanResultBlock)callback;

@end


@interface AVUser(Friendship)
/* @name 好友关系 */

/**
 *  通过ID来关注其他用户
 *
 *  @param userId 要关注的用户objectId
 *  @param callback 回调结果
 */
-(void)follow:(NSString*)userId andCallback:(AVBooleanResultBlock)callback;

/**
 *  通过ID来取消关注其他用户
 *
 *  @param userId 要取消关注的用户objectId
 *  @param callback 回调结果
 *
 */
-(void)unfollow:(NSString*)userId andCallback:(AVBooleanResultBlock)callback;

/**
 *  获取当前用户粉丝的列表
 *
 *  @param callback 回调结果
 */
-(void)getFollowers:(AVArrayResultBlock)callback;

/**
 *  获取当前用户所关注的列表
 *
 *  @param callback 回调结果
 *
 */
-(void)getFollowees:(AVArrayResultBlock)callback;

/**
 *  同时获取当前用户的粉丝和关注列表
 *
 *  @param callback 回调结果, 列表字典包含`followers`数组和`followees`数组
 */
-(void)getFollowersAndFollowees:(AVDictionaryResultBlock)callback;


@end

