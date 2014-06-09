//
//  AVSearchQuery.h
//  paas
//
//  Created by yang chaozhong on 5/30/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVSearchQuery : NSObject

/*!
 *  使用 queryString 构造一个 AVSearchQuery 对象
 *  @return AVSearchQuery 实例
 */
+ (instancetype)searchWithQueryString:(NSString *)queryString;

/*!
 *  查询的 className，默认为 nil，即包括所有启用了应用内搜索的 Class
 */
@property (nonatomic, retain) NSString *className;

/*!
 *  返回集合大小上限，默认值为100，最大为1000
 */
@property (nonatomic, assign) int limit;

/*!
 * 查询字符串，具体语法参考 http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#query-string-syntax
 */
@property (nonatomic, retain) NSString *queryString;

/*!
 *  符合查询条件的记录条数
 */
@property (nonatomic, assign) int hits;

/*!
 *  当前页面的lastId，用于分页，可选。
 */
@property (nonatomic, retain) NSString *lastId;

/*!
 *  查询的字段列表，可选。
 */
@property (nonatomic, retain) NSArray *fields;

/*!
 *  返回结果的高亮语法，默认为 "*"
 *  语法规则可以参考 http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-request-highlighting.html#highlighting-settings
 */
@property (nonatomic, retain) NSString *highlights;


/*!
 * 缓存策略
 */
@property (readwrite, assign) AVCachePolicy cachePolicy;

/* !
 * 最多缓存时间，单位为秒，默认值 24*3600 秒
 */
@property (readwrite, assign) NSTimeInterval maxCacheAge;

#pragma mark - Find methods

/*!
 *  根据查询条件获取结果对象
 *  @return AVObjects 数组
 */
- (NSArray *)findObjects;

/*!
 *  根据查询条件获取结果对象，如果有 error，则设置一个 error
 *  @param error 指针
 *  @return AVObjects 数组
 */
- (NSArray *)findObjects:(NSError **)error;

/*!
 *  异步获取搜索结果，并回调block
 *  @param block 需要有这样的方法签名 (NSArray *objects, NSError *error)
 */
- (void)findInBackground:(AVArrayResultBlock)block;

@end
