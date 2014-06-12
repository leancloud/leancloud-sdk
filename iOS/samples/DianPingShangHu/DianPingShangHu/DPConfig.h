//
//  DPConfig.h
//  DianPingShangHu
//
//  Created by 丁道骏 on 14-2-20.
//  Copyright (c) 2014年 dianping. All rights reserved.
//

#import "Type.h"
#import "Tag.h"
#import "Area.h"

typedef void (^CompletionBlock)(void);
typedef void (^ErrorBlock)(void);

extern NSString *const DPApplicationId;
extern NSString *const DPClientKey;

extern NSString *const DPLoginStatusChangedNotification;
extern NSString *const DPServerObjectUpdatedNotification;
extern NSString *const DPLocalObjectUploadedNotification;

extern NSString *const DPServerObjectIdKey;

extern NSString *const DPNoImagesSuggestion;
extern NSString *const DPEmptyFieldSuggestion;
extern NSString *const DPLoginFailedSuggestion;
extern NSString *const DPRegisterFailedSuggestion;
extern NSString *const DPUpToServerFailedSuggestion;
extern NSString *const DPNoDraftToUpSuggestion;
extern NSString *const DPAddFailedSuggestion;
extern NSString *const DPSaveFailedSuggestion;
extern NSString *const DPDeleteFailedSuggestion;
extern NSString *const DPGetServerDataFailedSuggestion;
extern NSString *const DPGetShangHuImageDataFailedSuggestion;

extern NSString *const DPLocatingFailedSuggestion;
extern NSString *const DPAddSuccessSuggestion;
extern NSString *const DPSaveSuccessSuggestion;
extern NSString *const DPDeleteSuccessSuggestion;

extern NSString *const DPUpToServerSuccessSuggestion;
extern NSString *const DPUpToServerWaitingSuggestion;
extern NSString *const DPFindShangHuOnServerWaitingSuggestion;
extern NSString *const DPFindMyShangHuOnServerWaitingSuggestion;
extern NSString *const DPGetShangHuImageDataWaitingSuggestion;

extern NSString *const DPServerTableShangHu;
extern NSString *const DPServerTableType;
extern NSString *const DPServerTableTag;

@interface DPConfig : NSObject

#pragma mark - 云统计界面查看方式
@property (nonatomic, strong) NSMutableArray *analyzeMode;

#pragma mark - 分类管理界面查看方式
@property (nonatomic, strong) NSMutableArray *categoryManageMode;

#pragma mark - 服务器所有用户
@property (strong, nonatomic) NSMutableArray *allUsers;

#pragma mark - 服务器所有用户、标签、分类统计
@property (nonatomic, strong) NSMutableDictionary *allUserFeedsCount;
@property (nonatomic, strong) NSMutableDictionary *allTypeFeedsCount;
@property (nonatomic, strong) NSMutableDictionary *allTagFeedsCount;
@property (nonatomic, strong) NSMutableDictionary *allAreaFeedsCount;

#pragma mark - 服务器所有查询结果
@property (nonatomic, strong) NSMutableDictionary *allQueryResult;

#pragma mark - 我的商户
@property (strong, nonatomic) NSMutableArray *myShangHus;

#pragma mark - 程序是否第一次启动
@property (nonatomic, assign) BOOL isFirstRunning;

#pragma mark - 设置
@property (nonatomic, strong) NSMutableDictionary *generalSettingField;
@property (nonatomic, strong) NSMutableDictionary *accountSettingField;
@property (nonatomic, strong) NSMutableDictionary *settingField;

#pragma mark - 添加
@property (nonatomic, strong) NSMutableDictionary *generalAddField;
@property (nonatomic, strong) NSMutableDictionary *optionalAddField;
@property (nonatomic, strong) NSMutableDictionary *addField;

#pragma mark - 默认分类
@property (nonatomic, strong) NSMutableArray *defaultType;

#pragma mark - 默认标签
@property (nonatomic, strong) NSMutableArray *defaultTag;

#pragma mark - 默认区域
@property (nonatomic, strong) NSMutableArray *defaultArea;

+ (DPConfig *)sharedConfigInstance;
- (void)initConfigData;
- (void)initDefaultData;
- (void)initDataBase;
- (void)initMyShangHusWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock;

- (void)initAllUsersOnServerWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock;

- (void)countAllUserFeedsWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock;
- (void)countAllTypeFeedsWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock;
- (void)countAllTagFeedsWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock;
- (void)countAllAreaFeedsWithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock;

- (void)initFeedsOfQueryKey:(NSString *)queryKey andQueryValue:(NSString *)queryValue WithCompletionBlock:(CompletionBlock)completionBlock andErrorBlock:(ErrorBlock)errorBlock;
@end