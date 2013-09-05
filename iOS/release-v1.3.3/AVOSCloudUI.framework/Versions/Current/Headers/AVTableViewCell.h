//
//  AVTableViewCell.h
//  paas
//
//  Created by Summer on 13-3-29.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVImageView.h"

/*!
 The AVTableViewCell is a table view cell which can download and display remote images stored on AVOS Cloud server. When used in a AVQueryTableViewController, the downloading and displaying of the remote images are automatically managed by the AVQueryTableViewController.
 */
@interface AVTableViewCell : UITableViewCell

/// The imageView of the table view cell. AVImageView supports remote image downloading.
@property (nonatomic, readonly, retain) AVImageView *imageView;
@end

