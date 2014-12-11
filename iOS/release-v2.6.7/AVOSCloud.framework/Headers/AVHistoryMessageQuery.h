//
//  AVHistoryMessageQuery.h
//  AVOS
//
//  Created by Qihe Bian on 10/21/14.
//
//

#import <Foundation/Foundation.h>
#import "AVHistoryMessage.h"
#import "AVConstants.h"

@interface AVHistoryMessageQuery : NSObject
@property(nonatomic)int64_t timestamp;
@property(nonatomic)int limit;

+ (instancetype)query;
+ (instancetype)queryWithTimestamp:(int64_t)timestamp limit:(int)limit;

+ (instancetype)queryWithConversationId:(NSString *)conversationId;
+ (instancetype)queryWithConversationId:(NSString *)conversationId timestamp:(int64_t)timestamp limit:(int)limit;

+ (instancetype)queryWithFromPeerId:(NSString *)fromPeerId;
+ (instancetype)queryWithFromPeerId:(NSString *)fromPeerId timestamp:(int64_t)timestamp limit:(int)limit;

+ (instancetype)queryWithFirstPeerId:(NSString *)firstPeerId secondPeerId:(NSString *)secondPeerId;
+ (instancetype)queryWithFirstPeerId:(NSString *)firstPeerId secondPeerId:(NSString *)secondPeerId timestamp:(int64_t)timestamp limit:(int)limit;

+ (instancetype)queryWithGroupId:(NSString *)groupId;
+ (instancetype)queryWithGroupId:(NSString *)groupId timestamp:(int64_t)timestamp limit:(int)limit;

-(NSArray *)find;
-(NSArray *)find:(NSError **)error;
-(void)findInBackgroundWithCallback:(AVArrayResultBlock)callback;
@end
