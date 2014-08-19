//
//  AVGroup.h
//  AVOS
//
//  Created by Qihe Bian on 7/22/14.
//
//

#import <Foundation/Foundation.h>
#import "AVConstants.h"
@class AVSession;
@protocol AVGroupDelegate;
typedef NS_ENUM(NSUInteger, AVGroupEvent) {
    AVGroupEventSelfJoined,
    AVGroupEventSelfLeft,
    AVGroupEventSelfRejected,
    AVGroupEventMemberJoined,
    AVGroupEventMemberLeft,
};
@interface AVGroup : NSObject

@property (nonatomic, weak) id <AVGroupDelegate> delegate;
@property (nonatomic, readonly) NSString *groupId;
/*!
 *  加入此group
 *  @return 无异常返回YES，否则返回NO
 */
- (BOOL)join;
/*!
 *  向此group发送消息
 *  @param message 文本消息
 *  @param transient 设置为 YES, 当且仅当某个 peer 在线才会收到该条消息，且该条消息既不会存为离线消息，也不会通过消息推送系统发出去.
 *         如果设置为 NO, 则该条消息会设法通过各种途径发到 peer 客户端，比如即时通信、推送、离线消息等。
 */
- (void)sendMessage:(NSString *)message isTransient:(BOOL)transient;
/*!
 *  将指定peerIds踢出group
 *  @param peerIds 需要踢出group的peerId列表
 *  @return 无异常返回YES，否则返回NO
 */
- (BOOL)kick:(NSArray *)peerIds;
/*!
 *  邀请peerIds加入group
 *  @param peerIds 需要邀请的peerId列表
 *  @return 无异常返回YES，否则返回NO
 */
- (BOOL)invite:(NSArray *)peerIds;
/*!
 *  退出group
 *  @return 无异常返回YES，否则返回NO
 */
- (BOOL)quit;
//- (NSArray *)queryMembers;
//- (BOOL)queryMemebersInBackgroudWithBlock:(AVArrayResultBlock)block;
@end

@protocol AVGroupDelegate <NSObject>
- (void)session:(AVSession *)session group:(AVGroup *)group didReceiveGroupMessage:(NSString *)message fromPeerId:(NSString *)peerId;
- (void)session:(AVSession *)session group:(AVGroup *)group didReceiveGroupEvent:(AVGroupEvent)event memberIds:(NSArray *)memberIds;
@end
