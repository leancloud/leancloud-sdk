//
//  AVSignature.h
//  paas
//
//  Created by yang chaozhong on 5/15/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVSignature : NSObject

@property (nonatomic, retain) NSString *signature;
@property (nonatomic, assign) long timestamp;
@property (nonatomic, retain) NSString *nonce;
@property (nonatomic, retain) NSString *action;
@property (nonatomic, retain) NSArray *signedPeerIds;

@end

@protocol AVSignatureDelegate <NSObject>
@optional
- (AVSignature *)createSignature:(NSString *)peerId watchedPeerIds:(NSArray *)watchedPeerIds;
- (AVSignature *)createSessionSignature:(NSString *)peerId watchedPeerIds:(NSArray *)watchedPeerIds action:(NSString *)action;
- (AVSignature *)createGroupSignature:(NSString *)peerId groupPeerIds:(NSArray *)groupPeerIds action:(NSString *)action;
@end