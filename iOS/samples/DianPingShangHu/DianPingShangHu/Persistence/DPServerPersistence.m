	//
	//  AVObjectBasic.m
	//  AVOSDemo
	//
	//  Created by Travis on 13-12-12.
	//  Copyright (c) 2013年 AVOS. All rights reserved.
	//

#import "DPServerPersistence.h"

@implementation DPServerPersistence

+ (DPServerPersistence *)sharedServerPersistenceInstance
{
    static dispatch_once_t  onceToken;
    static DPServerPersistence * sharedServerPersistenceInstance;
	
    dispatch_once(&onceToken, ^{
        sharedServerPersistenceInstance = [[DPServerPersistence alloc] init];
    });
    return sharedServerPersistenceInstance;
}

- (void)uploadShangHuToServer:(ShangHu *)shangHu withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	AVObject *shangHuToBeUpload = [AVObject objectWithClassName:DPServerTableShangHu];
	NSDictionary *addField = [DPConfig sharedConfigInstance].addField;
	
	for (int i = 0; i < [addField allValues].count; i ++) {
		NSMutableDictionary *rowsDictionary = [addField allValues][i];
		
		for (int j = 0; j < [rowsDictionary allValues].count; j ++) {
			NSString *key = [rowsDictionary allKeys][j];
			[shangHuToBeUpload setObject:[shangHu valueForKey:key] forKey:key];
		}
	}
	
	[shangHuToBeUpload setObject:[AVUser currentUser].username forKey:@"author"];
	
	[shangHuToBeUpload saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			if (completionBlock) {
				completionBlock();
			}
		} else {
			if (errorBlock) {
				errorBlock();
			}
		}
	}];
}

- (void)deleteObject:(AVObject *)object withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	AVObject *objectToBeDelete = [AVObject objectWithoutDataWithClassName:DPServerTableShangHu objectId:object.objectId];
	[objectToBeDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
 		if (error) {
			if (errorBlock) {
				errorBlock();
			}
		} else if (succeeded) {
			if (completionBlock) {
				completionBlock();
			}
		}
	}];
}

- (void)createObject:(AVObject *)object withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error) {
			errorBlock();
		} else if (succeeded) {
			completionBlock();
		}
	}];
}

- (void)updateObject:(AVObject *)object withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	
}

- (void)findAllObject:(AVObject *)object withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	
}

@end
