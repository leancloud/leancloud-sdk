//
//  AVSession.h
//  paas
//
//  Created by yang chaozhong on 5/6/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVSignature.h"
#import "AVConstants.h"
#import "AVGroup.h"
@protocol AVSessionDelegate;

@interface AVSession : NSObject

@property (nonatomic, assign) id <AVSessionDelegate> sessionDelegate;
@property (nonatomic, assign) id <AVSignatureDelegate> signatureDelegate;

/*!
 *  发送消息Timeout，默认10秒
 */
@property (nonatomic, assign) int messageTimeout;

/*!
 *  打开 session 并关注一组 peer id 数组
 *  @param selfId 用户自己的peer id
 *  @param peerIds peer id 数组
 */
- (void)open:(NSString *)selfId withPeerIds:(NSArray *)peerIds;

///*!
// *  打开 session 用于群聊
// *  @param selfId 用户自己的peer id
// */
//- (void)openForGroupChat:(NSString *)selfId;

/*!
 *  增量关注一组 peers
 *  @param peerIds peer id 数组
 *  @return watch成功，返回 YES，否则返回 NO
 */
- (BOOL)watchPeers:(NSArray *)peerIds;

/*!
 *  取消关注一组 peers
 *  @param peerIds peer id 数组
 */
- (void)unwatchPeers:(NSArray *)peerIds;

/*!
 *  向一组 peers 发送消息
 *  @param message 文本消息
 *  @param transient 设置为 YES, 当且仅当某个 peer 在线才会收到该条消息，且该条消息既不会存为离线消息，也不会通过消息推送系统发出去.
 *         如果设置为 NO, 则该条消息会设法通过各种途径发到 peer 客户端，比如即时通信、推送、离线消息等。
 *  @param peerIds peer id 数组
 */
- (void)sendMessage:(NSString *)message isTransient:(BOOL)transient toPeerIds:(NSArray *)peerIds;

/*!
 *  关闭 session
 */
- (void)close;

/*!
 *  判断 session 是否 open
 *  @return 如果 open，则返回 YES， 否则返回 NO
 */
- (BOOL)isOpen;

/*!
 *  判断 session 是否 paused
 *  @discussion 这里的 paused 是指无网络连接、且已经 open 的 session 所处状态。
 *  @return 如果 paused，则返回 YES， 否则返回 NO
 */
- (BOOL)isPaused;

/*!
 *  判断某个用户是否 online
 *  @param peerId 用户的 peer id
 *  @return 如果 online，则返回 YES， 否则返回 NO
 */
- (BOOL)isOnline:(NSString *)peerId;

/*!
 *  判断是否 watch 了某个用户
 *  @param peerId 用户的 peer id
 *  @return 如果已经 watch，返回 YES，否则返回 NO
 */
- (BOOL)isWatching:(NSString *)peerId;

/*!
 *  获取自己的 peer id
 *  @return 用户的 peer id
 */
- (NSString *)getSelfPeerId;

/*!
 *  获取已经 watch 的那部分用户中，当前在线的用户
 *  @return 在线用户列表
 */
- (NSArray *)getOnlinePeers;

/*!
 *  获取传入的用户数组中，当前在线的用户
 *  @param peerIds 用户 peer id 数组
 *  @param block 回调 block，这个 block 应该包含如下参数签名:(NSArray *objects, NSError *error) 
 */
- (void)getOnlinePeers:(NSArray *)peerIds withBlock:(AVArrayResultBlock)block;

/*!
 *  获取已经 watch 的用户列表
 *  @return 用户列表
 */
- (NSArray *)getAllPeers;

///*!
// *  获取是否为群组聊天会话
// *  @return 如果是群组聊天会话，则返回 YES， 否则返回 NO
// */
//- (BOOL)isGroupSession;
/*!
 *  根据groupId构建一个AVGroup对象
 *  @return 如果已经存在groupId的group对象，则返回该对象，否则新建一个对象
 */
- (AVGroup *)getGroup:(NSString *)groupId;

///*!
// *  获取此会话的group对象
// *  @return 如果存在group对象则返回该对象，否则返回nil
// */
//- (AVGroup *)group;

@end

@protocol AVSessionDelegate <NSObject>

- (void)onSessionOpen:(AVSession *)session;
- (void)onSessionPaused:(AVSession *)session;
- (void)onSessionResumed:(AVSession *)seesion;
- (void)onSessionMessage:(AVSession *)session message:(NSString *)message peerId:(NSString *)peerId;
- (void)onSessionMessageSent:(AVSession *)session message:(NSString *)message toPeerIds:(NSArray *)peerIds;
- (void)onSessionMessageFailure:(AVSession *)session message:(NSString *)message toPeerIds:(NSArray *)peerIds;
- (void)onSessionStatusOnline:(AVSession *)session peers:(NSArray *)peerIds;
- (void)onSessionStatusOffline:(AVSession *)session peers:(NSArray *)peerId;
- (void)onSessionError:(AVSession *)session withException:(NSException *)exception;

@end