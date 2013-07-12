//
//  PFRelation.h
//  Parse
//
//  Created by Shyam Jayaraman on 5/11/12.
//  Copyright (c) 2012 Parse Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVObject.h"
#import "AVQuery.h"

/*!
 A class that is used to access all of the children of a many-to-many relationship.  Each instance
 of PFRelation is associated with a particular parent object and key.
 */
@interface AVRelation : NSObject {
    AVObject *parent;
    NSString *key;
    NSString *targetClass;
}

@property (nonatomic, retain) NSString *targetClass;


#pragma mark Accessing objects
/*!
 @return A ParseQuery that can be used to get objects in this relation.
 */
- (AVQuery *)query;


#pragma mark Modifying relations

/*!
 Adds a relation to the passed in object.
 @param object ParseObject to add relation to.
 */
- (void)addObject:(AVObject *)object;

/*!
 Removes a relation to the passed in object.
 @param object ParseObject to add relation to.
 */
- (void)removeObject:(AVObject *)object;
@end


