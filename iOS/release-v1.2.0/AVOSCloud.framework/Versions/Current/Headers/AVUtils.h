//
//  AVUtils.h
//  paas
//
//  Created by Zhu Zeng on 2/27/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVConstants.h"
#import "AVOSCloud.h"
#import "LoggerClient.h"

#define classNameTag @"className"

@class AVObject;

@interface AVUtils : NSObject

+(void)warnMainThreadIfNecessary;

+(BOOL)containsProperty:(Class)objectClass property:(NSString *)name;

+(AVObject *)avObjectFromDictionary:(NSDictionary *)src
                          className:(NSString *)className;
+(void)copyPropertiesFrom:(NSObject *)src
                 toObject:(NSObject *)target;
+(void)copyPropertiesFromDictionary:(NSDictionary *)src
                           toObject:(AVObject *)target;
+(void)copyPropertiesFromDictionary:(NSDictionary *)src
                         toNSObject:(NSObject *)target;
+(NSMutableDictionary *)dictionaryFromObject:(NSObject *)target;

+ (BOOL)array:(NSArray *)array containObjectById:(NSString *)objectId;

+(NSString *)stringFromDate:(NSDate *)date;
+(NSDictionary *)dictionaryFromDate:(NSDate *)date;
+(NSDate *)dateFromDictionary:(NSDictionary *)dict;

+(NSDictionary *)dictionaryFromData:(NSData *)data;
+(NSData *)dataFromDictionary:(NSDictionary *)dict;

+(NSString *)batchPath;
+(NSString *)batchSavePath;
+(NSMutableDictionary *)serverDataDictionary:(NSDictionary *)dict;

+(BOOL)isUserClass:(NSString *)className;
+(BOOL)isInstallationClass:(NSString *)className;

+(NSString *)objectPath:(NSString *)objectClass
               objectId:(NSString *)objectId;

+(NSString *)jsonString:(NSDictionary *)dictionary;

+(void)performSelectorIfCould:(id)target
                     selector:(SEL)selector
                       object:(id)arg1
                       object:(id)arg2;

+ (NSString *)generateUUID;

#pragma mark - Block
/**
 typedef void (^PFBooleanResultBlock)(BOOL succeeded, NSError *error);
 typedef void (^PFIntegerResultBlock)(int number, NSError *error);
 typedef void (^PFArrayResultBlock)(NSArray *objects, NSError *error);
 typedef void (^PFObjectResultBlock)(AVObject *object, NSError *error);
 typedef void (^PFSetResultBlock)(NSSet *channels, NSError *error);
 typedef void (^PFUserResultBlock)(AVUser *user, NSError *error);
 typedef void (^PFDataResultBlock)(NSData *data, NSError *error);
 typedef void (^PFDataStreamResultBlock)(NSInputStream *stream, NSError *error);
 typedef void (^PFStringResultBlock)(NSString *string, NSError *error);
 typedef void (^PFIdResultBlock)(id object, NSError *error);
 typedef void (^PFProgressBlock)(int percentDone);
 */
+ (void)callBooleanResultBlock:(PFBooleanResultBlock)block
                         error:(NSError *)error;

+ (void)callIntegerResultBlock:(PFIntegerResultBlock)block
                        number:(int)number
                         error:(NSError *)error;

+ (void)callArrayResultBlock:(PFArrayResultBlock)block
                       array:(NSArray *)array
                       error:(NSError *)error;

+ (void)callObjectResultBlock:(PFObjectResultBlock)block
                       object:(AVObject *)object
                        error:(NSError *)error;

+ (void)callUserResultBlock:(PFUserResultBlock)block
                       user:(AVUser *)user
                      error:(NSError *)error;

+ (void)callIdResultBlock:(PFIdResultBlock)block
                   object:(id)object
                    error:(NSError *)error;

+ (void)callProgressBlock:(PFProgressBlock)block
                  percent:(int)percentDone;


+(void)callSetResultBlock:(PFSetResultBlock)block
                      set:(NSSet *)set
                    error:(NSError *)error;



#pragma mark - Data for server
+ (NSMutableDictionary *)parsedDictionary:(NSMutableDictionary *)dic;
+ (id)parsedObject:(id)obj;

#pragma mark - Data from server
// response: Dictionary/Array or Simple Objects like String/Number(all from json)
+ (id)processedResultFromId:(id)response;
+ (id)processedResultFromArray:(NSArray *)array;
+ (id)processedResultFromDic:(NSDictionary *)dic;

#pragma mark - String Util
+ (NSString *)MIMEType:(NSString *)filePathOrName;
+ (NSString *)MIMETypeFromPath:(NSString *)fullPath;
+ (NSString *)contentTypeForImageData:(NSData *)data;

#pragma mark - Something about log

+ (void)setBonjourForLog;

// the level is only for NSLogger
typedef enum LoggerLevel : NSUInteger {
    LoggerLevelError = 0,
    LoggerLevelWarning,
    LoggerLevelInfo,
    LoggerLevelVerbose,
    LoggerLevelInternal,
    LoggerLevelNum
} LoggerLevel;

#define LOG_DOMAIN @"avos.cloud.ios"
#define LOG_DEFAULT_LEVEL LoggerLevelInternal

// the last method, if debug log all, else log with level
#ifdef DEBUG
    #define AVLog(level, ...) LogMessage(LOG_DOMAIN, level, __VA_ARGS__)
#else
    #define AVLog(level, ...) if (([AVOSCloud logLevel] & (1 << level)) > 0) LogMessage(LOG_DOMAIN, level, __VA_ARGS__)
#endif

// all the no level log
#define VLog(...) AVLog(LOG_DEFAULT_LEVEL, __VA_ARGS__)

// recommand methods
#define AVLogE(fmt,...) AVLog(LoggerLevelError, (@"%s [Line %d] " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#define AVLogW(fmt,...) AVLog(LoggerLevelWarning, (@"%s [Line %d] " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#define AVLogI(fmt,...) AVLog(LoggerLevelInfo, (@"%s [Line %d] " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#define AVLogV(fmt,...) AVLog(LoggerLevelVerbose, (@"%s [Line %d] " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#define AVLogIn(fmt,...) AVLog(LoggerLevelInternal, (@"%s [Line %d] " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)

@end



