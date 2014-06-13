	//
	//  DPConfig.m
	//  DianPingShangHu
	//
	//  Created by 丁道骏 on 14-2-20.
	//  Copyright (c) 2014年 dianping. All rights reserved.
	//

#import "DPConfig.h"

NSString *const DPApplicationId = @"0rpcywjj9uw9r7k5ajemhfkyjr4omtpx6pi0qeq9iabftqug";
NSString *const DPClientKey = @"uqy35nhq6nhwtmk1ec33iifo8w02o958rtq4lrg5d0embz7x";

NSString *const DPLoginStatusChangedNotification = @"DPLoginStatusChangedNotification";
NSString *const DPServerObjectUpdatedNotification = @"DPServerObjectUpdatedNotification";
NSString *const DPLocalObjectUploadedNotification = @"DPLocalObjectUploadedNotification";

NSString *const DPServerObjectIdKey = @"DPServerObjectIdKey";

NSString *const DPNoImagesSuggestion = @"该商户暂时还没有图片！";
NSString *const DPEmptyFieldSuggestion = @"输入框不能为空！";
NSString *const DPLoginFailedSuggestion = @"请检查您的用户名和密码是否有误，\n或待稍后网络状况良好时重试！";
NSString *const DPRegisterFailedSuggestion = @"请检查您的用户名和邮箱格式是否有误，\n或待稍后网络状况良好时重试！";
NSString *const DPUpToServerFailedSuggestion = @"上传失败，\n请待稍后网络状况良好时重试！";
NSString *const DPNoDraftToUpSuggestion = @"没有需要上传的草稿，\n请先添加一条草稿后重试！";
NSString *const DPAddFailedSuggestion = @"添加失败！";
NSString *const DPSaveFailedSuggestion = @"保存失败！";
NSString *const DPDeleteFailedSuggestion = @"删除失败！";
NSString *const DPGetServerDataFailedSuggestion = @"加载失败，\n请待稍后网络状况良好时重试！";
NSString *const DPGetShangHuImageDataFailedSuggestion = @"加载商户图片失败，\n请待稍后网络状况良好时重试！";

NSString *const DPLocatingFailedSuggestion = @"定位失败，\n应用可能无权使用当前位置，\n或待稍后网络状况良好时重试！";;
NSString *const DPAddSuccessSuggestion = @"添加成功！";
NSString *const DPSaveSuccessSuggestion = @"保存成功！";
NSString *const DPDeleteSuccessSuggestion = @"删除成功！";
NSString *const DPUpToServerSuccessSuggestion = @"上传成功！";
NSString *const DPUpToServerWaitingSuggestion = @"正在上传...";
NSString *const DPFindShangHuOnServerWaitingSuggestion = @"正在查询所有商户信息...";
NSString *const DPFindMyShangHuOnServerWaitingSuggestion = @"正在查询您的商户信息...";
NSString *const DPGetShangHuImageDataWaitingSuggestion = @"正在加载商户图片...";

NSString *const DPServerTableShangHu = @"ShangHu";
NSString *const DPServerTableType = @"Type";
NSString *const DPServerTableTag = @"Tag";

@implementation DPConfig

+ (DPConfig *)sharedConfigInstance
{
    static dispatch_once_t  onceToken;
    static DPConfig * sharedConfigInstance;
	
    dispatch_once(&onceToken, ^{
        sharedConfigInstance = [[DPConfig alloc] init];
    });
    return sharedConfigInstance;
}

- (id)init {
	if (self == [super init]) {
		if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstRunning"]) {
			self.isFirstRunning = YES;
		} else {
			self.isFirstRunning = NO;
		}
	}
	return self;
}

- (void)initConfigData {
	[self initSettingConfigData];
	[self initAddConfigData];
	[self initAnalyzeConfigData];
	
	[self initGeneralConfigData];
}

- (void)initGeneralConfigData {
	self.allQueryResult = [NSMutableDictionary dictionary];
}

- (void)initAnalyzeConfigData
{
	self.analyzeMode = [NSMutableArray arrayWithArray:@[@"按作者", @"按分类", @"按标签", @"按区域"]];
    self.categoryManageMode = [NSMutableArray arrayWithArray:@[@"商户标签", @"商户分类"]];
}

- (void)initNetworkData {
	[self initMyShangHusWithCompletionBlock:nil andErrorBlock:nil];
}

- (void)initFeedsOfQueryKey:(NSString *)queryKey andQueryValue:(NSString *)queryValue WithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock;
{
	AVQuery *query = [AVQuery queryWithClassName:DPServerTableShangHu];
	
	query.cachePolicy = kAVCachePolicyCacheElseNetwork;
	query.maxCacheAge = 3600;
	[query whereKey:queryKey equalTo:queryValue];
	
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (objects) {
			[self.allQueryResult setObject:objects forKey:queryValue];
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

- (void)initMyShangHusWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	AVUser * currentUser = [AVUser currentUser];
	
	if (currentUser != nil) {
		NSString *username = currentUser.username;
		AVQuery *query = [AVQuery queryWithClassName:DPServerTableShangHu];
		
		query.cachePolicy = kAVCachePolicyNetworkElseCache;
		query.maxCacheAge = 3600;
		[query whereKey:@"author" equalTo:username];
		
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (objects) {
				self.myShangHus = [NSMutableArray arrayWithArray:objects];
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
}

- (void)initAllUsersOnServerWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	AVQuery * query = [AVUser query];
	query.cachePolicy = kAVCachePolicyCacheElseNetwork;
	
		//设置缓存有效期
	query.maxCacheAge = 4 * 3600;
	
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (objects) {
			self.allUsers = [NSMutableArray arrayWithArray:objects];
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

- (void)countAllUserFeedsWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	self.allUserFeedsCount = [NSMutableDictionary dictionary];
	
	for (AVUser *user in self.allUsers) {
		__block NSString *username = user.username;
		__block BOOL isAllUserCounted = NO;
		
		AVQuery *query = [AVQuery queryWithClassName:DPServerTableShangHu];
		
		query.cachePolicy = kAVCachePolicyCacheThenNetwork;
		query.maxCacheAge = 4 * 3600;
		[query whereKey:@"author" equalTo:username];
		
		[query countObjectsInBackgroundWithBlock:^(NSInteger count, NSError *error) {
			if (!error) {
				[self.allUserFeedsCount setObject:[NSNumber numberWithInteger:count] forKey:username];
				
				if (self.allUsers.count == self.allUserFeedsCount.count) {
					isAllUserCounted = YES;
				}
				if (completionBlock && isAllUserCounted) {
					completionBlock();
				}
			} else {
				if (errorBlock) {
					errorBlock();
				}
			}
		}];
	}
}

- (void)countAllTypeFeedsWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	self.allTypeFeedsCount = [NSMutableDictionary dictionary];
	
	for (Type *type in self.defaultType) {
		__block NSString *typeName = [type valueForKey:@"name"];
		__block BOOL isAllTypeCounted = NO;
		
		AVQuery *query = [AVQuery queryWithClassName:DPServerTableShangHu];
		
		query.cachePolicy = kAVCachePolicyCacheThenNetwork;
		query.maxCacheAge = 4 * 3600;
		[query whereKey:@"type" equalTo:typeName];
		
		[query countObjectsInBackgroundWithBlock:^(NSInteger count, NSError *error) {
			if (!error) {
				[self.allTypeFeedsCount setObject:[NSNumber numberWithInteger:count] forKey:typeName];
				
				if (self.defaultType.count == self.allTypeFeedsCount.count) {
					isAllTypeCounted = YES;
				}
				if (completionBlock && isAllTypeCounted) {
					completionBlock();
				}
			} else {
				if (errorBlock) {
					errorBlock();
				}
			}
		}];
	}
}

- (void)countAllTagFeedsWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	self.allTagFeedsCount = [NSMutableDictionary dictionary];
	
	for (Tag *tag in self.defaultTag) {
		__block NSString *tagName = [tag valueForKey:@"name"];
		__block BOOL isAllTagCounted = NO;
		
		AVQuery *query = [AVQuery queryWithClassName:DPServerTableShangHu];
		
		query.cachePolicy = kAVCachePolicyCacheThenNetwork;
		query.maxCacheAge = 4 * 3600;
		[query whereKey:@"tag" equalTo:tagName];
		
		[query countObjectsInBackgroundWithBlock:^(NSInteger count, NSError *error) {
			if (!error) {
				[self.allTagFeedsCount setObject:[NSNumber numberWithInteger:count] forKey:tagName];
				
				if (self.defaultTag.count == self.allTagFeedsCount.count) {
					isAllTagCounted = YES;
				}
				if (completionBlock && isAllTagCounted) {
					completionBlock();
				}
			} else {
				if (errorBlock) {
					errorBlock();
				}
			}
		}];
	}
}

- (void)countAllAreaFeedsWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock
{
	self.allAreaFeedsCount = [NSMutableDictionary dictionary];
	
	for (Area *area in self.defaultArea) {
		__block NSString *areaName = [area valueForKey:@"name"];
		__block BOOL isAllAreaCounted = NO;
		
		AVQuery *query = [AVQuery queryWithClassName:DPServerTableShangHu];
		
		query.cachePolicy = kAVCachePolicyCacheThenNetwork;
		query.maxCacheAge = 4 * 3600;
		[query whereKey:@"area" equalTo:areaName];
		
		[query countObjectsInBackgroundWithBlock:^(NSInteger count, NSError *error) {
			if (!error) {
				[self.allAreaFeedsCount setObject:[NSNumber numberWithInteger:count] forKey:areaName];
				
				if (self.defaultArea.count == self.allAreaFeedsCount.count) {
					isAllAreaCounted = YES;
				}
				if (completionBlock && isAllAreaCounted) {
					completionBlock();
				}
			} else {
				if (errorBlock) {
					errorBlock();
				}
			}
		}];
	}
}

- (void)initSettingConfigData {
	self.generalSettingField = [NSMutableDictionary dictionaryWithDictionary:@{@"categoryManage" : @"类别管理",
																			   @"clearCache" : @"清空缓存"}];
	self.accountSettingField = [NSMutableDictionary dictionaryWithDictionary:@{@"logInLogOut" : @"登录"}];
	
	self.settingField = [NSMutableDictionary dictionaryWithDictionary:@{@"常用工具" : self.generalSettingField, @"我的账户" : self.accountSettingField}];
}

- (void)initAddConfigData {
	self.generalAddField = [NSMutableDictionary dictionaryWithDictionary:@{
																		   @"name" : @"商户名称",
																		   @"phone" : @"电话",
																		   @"address" : @"地址",
																		   @"location" : @"位置"}];
	self.optionalAddField = [NSMutableDictionary dictionaryWithDictionary:@{
																			@"type" : @"商户分类",
																			@"tag" : @"商户标签",
                                                                            @"area" : @"所在区域"}];
	self.addField = [NSMutableDictionary dictionaryWithDictionary:@{
																	@"基本信息" : self.generalAddField,
																	@"可选信息" : self.optionalAddField}];
}

- (void)initDefaultData {
	[self initDefaultTypeConfigData];
	[self initDefaultTagConfigData];
    [self initDefaultAreaConfigData];
	[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFirstRunning"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	self.isFirstRunning = NO;
}

- (void)initDataBase {
    [self initTypeDataBase];
	[self initTagDataBase];
    [self initAreaDataBase];
}

- (void)initTypeDataBase {
    NSFetchedResultsController *fetchedResultsController = [Type MR_fetchAllSortedBy:@"name"
                                              ascending:NO
                                          withPredicate:nil
                                                groupBy:nil
                                               delegate:nil
                                              inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    self.defaultType = [NSMutableArray arrayWithArray:[fetchedResultsController fetchedObjects]];
}

- (void)initTagDataBase {
    NSFetchedResultsController *fetchedResultsController = [Tag MR_fetchAllSortedBy:@"name"
                                                                          ascending:NO
                                                                      withPredicate:nil
                                                                            groupBy:nil
                                                                           delegate:nil
                                                                          inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    self.defaultTag = [NSMutableArray arrayWithArray:[fetchedResultsController fetchedObjects]];
}

- (void)initAreaDataBase {
    NSFetchedResultsController *fetchedResultsController = [Area MR_fetchAllSortedBy:@"name"
                                                                          ascending:NO
                                                                      withPredicate:nil
                                                                            groupBy:nil
                                                                           delegate:nil
                                                                          inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    self.defaultArea = [NSMutableArray arrayWithArray:[fetchedResultsController fetchedObjects]];
}

- (void)initDefaultAreaConfigData {
	self.defaultArea = [NSMutableArray array];
	NSArray *areaItems = [NSMutableArray arrayWithArray:@[@"瑶海区", @"庐阳区", @"蜀山区", @"包河区", @"新站区", @"政务区", @"经开区", @"滨湖新区", @"高新区", @"巢湖市", @"肥东县", @"肥西县", @"长丰县", @"庐江县"]];
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	
	for (NSString *areaName in areaItems) {
		Area *area = [Area MR_createInContext:localContext];
		[area setValue:areaName forKey:@"name"];
		[self.defaultArea addObject:area];
	}
	
	[localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
		if (error) {
			NSLog(@"保存Area出错：%@", [error description]);
		}
	}];
}

- (void)initDefaultTypeConfigData {
	self.defaultType = [NSMutableArray array];
	NSArray *typeItems = [NSMutableArray arrayWithArray:@[@"徽菜", @"江浙菜", @"川菜", @"东北菜", @"清真菜", @"粤菜", @"海鲜", @"日本料理", @"韩国料理", @"火锅", @"小吃简餐", @"面包甜点", @"新疆菜", @"西餐"]];
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	
	for (NSString *typeName in typeItems) {
		Type *type = [Type MR_createInContext:localContext];
		[type setValue:typeName forKey:@"name"];
		[self.defaultType addObject:type];
	}
	
	[localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
		if (error) {
			NSLog(@"保存Type出错：%@", [error description]);
		}
	}];
}

- (void)initDefaultTagConfigData {
	self.defaultTag = [NSMutableArray array];
	NSArray *tagItems = [NSMutableArray arrayWithArray:@[@"情侣约会", @"朋友聚餐", @"家庭聚会", @"商务宴请", @"休闲小憩", @"无线上网", @"免费停车", @"生日优惠", @"有景观位", @"随便吃吃"]];
	
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	
	for (NSString *tagName in tagItems) {
		Tag *tag = [Tag MR_createInContext:localContext];
		[tag setValue:tagName forKey:@"name"];
		[self.defaultTag addObject:tag];
	}
	
	[localContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
		if (error) {
			NSLog(@"保存Tag出错：%@", [error description]);
		}
	}];
}

@end