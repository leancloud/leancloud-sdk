//
//  AVQueryTableViewController.m
//  paas
//
//  Created by Summer on 13-3-29.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVOSCloud/AVOSCloud.h"
//#import "AV_EGORefreshTableHeaderView.h"
#import "AVTableViewCell.h"

@interface AVQueryTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/*! @name Creating a AVQueryTableViewController */

/*!
 Initializes a query table view controller with the given style.
 @param style The UITableViewStyle for the table
 @result The initialized AVQueryTableViewController
 */
- (id)initWithStyle:(UITableViewStyle)otherStyle;

/*!
 The designated initializer.
 Initializes with a class name of the AVObjects that will be associated with this table.
 @param style The UITableViewStyle for the table
 @param aClassName The class name of the AVObjects that this table will display
 @result The initialized AVQueryTableViewController
 */
- (id)initWithStyle:(UITableViewStyle)style className:(NSString *)aClassName;

/*!
 Initializes with a class name of the AVObjects that will be associated with this table.
 @param aClassName The class name of the AVObjects that this table will display
 @result The initialized AVQueryTableViewController
 */
- (id)initWithClassName:(NSString *)aClassName;

/*! @name Configuring Behavior */

/// The table view managed by the controller object
@property (nonatomic, retain) UITableView *tableView;

/// The class of the AVObject this table will use as a datasource
@property (nonatomic, retain) NSString *className;

/// The key to use to display for the cell text label. This won't apply if you override tableView:cellForRowAtIndexPath:object:
@property (nonatomic, retain) NSString *textKey;

/// The key to use to display for the cell image view. This won't apply if you override tableView:cellForRowAtIndexPath:object:
@property (nonatomic, retain) NSString *imageKey;

/// The image to use as a placeholder for the cell images. This won't apply if you override tableView:cellForRowAtIndexPath:object:
@property (nonatomic, retain) UIImage *placeholderImage;

/// Whether the table should use the default loading view (default:YES)
@property (nonatomic, assign) BOOL loadingViewEnabled;

/// Whether the table should use the built-in pull-to-refresh feature (default:YES)
@property (nonatomic, assign) BOOL pullToRefreshEnabled;

/// Whether the table should use the built-in pagination feature (default:YES)
@property (nonatomic, assign) BOOL paginationEnabled;

/// The number of objects to show per page (default: 25)
@property (nonatomic, assign) NSUInteger objectsPerPage;

/// Whether the table is actively loading new data from the server
@property (nonatomic, assign) BOOL isLoading;

/**
 A Boolean value indicating if the controller clears the selection when the table appears.
 
 The default value of this property is YES. When YES, the table view controller clears the table's
 current selection when it receives a viewWillAppear: message. Setting this property to `NO`
 preserves the selection.
 */
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

/*! @name Responding to Events */

/*!
 Called when objects have loaded from AVOS Cloud. If you override this method, you must
 call [super objectsDidLoad] in your implementation.
 @param error The AVOS Cloud error from running the AVQuery, if there was any.
 */
- (void)objectsDidLoad:(NSError *)error;

/*!
 Called when objects will loaded from AVOS Cloud. If you override this method, you must
 call [super objectsWillLoad] in your implementation.
 */
- (void)objectsWillLoad;

/*! @name Accessing Results */

/// The array of AVObjects that is the UITableView data source
@property (nonatomic, retain, readonly) NSArray *objects;

/*!
 Returns an object at a particular indexPath. The default impementation returns
 the object at indexPath.row. If you want to return objects in a different
 indexPath order, like for sections, override this method.
 @param     indexPath   The indexPath
 @result    The object at the specified index
 */
- (AVObject *)objectAtIndex:(NSIndexPath *)indexPath;

/*! @name Querying */

/*!
 Override to construct your own custom AVQuery to get the objects.
 @result AVQuery that loadObjects will use to the objects for this table.
 */
- (AVQuery *)queryForTable;

/*!
 Clears the table of all objects.
 */
- (void)clear;

/*!
 Clears the table and loads the first page of objects.
 */
- (void)loadObjects;

/*!
 Loads the objects of the className at the specified page and appends it to the
 objects already loaded and refreshes the table.
 @param     page    The page of objects to load.
 @param     clear   Whether to clear the table after receiving the objects.
 */
- (void)loadObjects:(NSInteger)page clear:(BOOL)clear;

/*!
 Loads the next page of objects, appends to table, and refreshes.
 */
- (void)loadNextPage;

/*! @name Data Source Methods */

/*!
 Override this method to customize each cell given a AVObject that is loaded. If you
 don't override this method, it will use a default style cell and display either
 the first data key from the object, or it will display the key as specified
 with keyToDisplay.
 
 The cell should inherit from AVTableViewCell which is a subclass of UITableViewCell.
 
 @param tableView   The table view object associated with this controller.
 @param indexPath   The indexPath of the cell.
 @param object      The AVObject that is associated with the cell.
 @result            The cell that represents this object.
 */
- (AVTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(AVObject *)object;

/*!
 Override this method to customize the cell that allows the user to load the
 next page when pagination is turned on.
 @param tableView   The table view object associated with this controller.
 @param indexPath   The indexPath of the cell.
 @result            The cell that allows the user to paginate.
 */
- (AVTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath;


@end
