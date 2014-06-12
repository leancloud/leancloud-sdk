//
//  AVObjectBasic.h
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

@interface DPLocalPersistence : NSObject

+ (DPLocalPersistence *)sharedLocalPersistenceInstance;

- (void)deleteObject:(NSManagedObject *)object withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock;

@end
