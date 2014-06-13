
#import "DPLocalPersistence.h"

@implementation DPLocalPersistence

+ (DPLocalPersistence *)sharedLocalPersistenceInstance
{
    static dispatch_once_t  onceToken;
    static DPLocalPersistence * sharedLocalPersistenceInstance;
	
    dispatch_once(&onceToken, ^{
        sharedLocalPersistenceInstance = [[DPLocalPersistence alloc] init];
    });
    return sharedLocalPersistenceInstance;
}

- (void)deleteObject:(NSManagedObject *)object withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	[object MR_deleteInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
	
	[[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
		if (error) {
			if (errorBlock) {
				errorBlock();
			}
		} else if (success) {
			if (completionBlock) {
				completionBlock();
			}
		}
	}];
}

- (void)createObject:(NSManagedObject *)object withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	[[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
		if (error) {
			errorBlock();
		} else if (success) {
			completionBlock();
		}
	}];
}

- (void)updateObject:(NSManagedObject *)object withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{

}

- (void)findAllObject:(NSManagedObject *)object withCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	
}

@end