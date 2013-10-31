//
//  AVFileHTTPRequestOperation.h
//  paas
//
//  Created by Summer on 13-5-27.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AFJSONRequestOperation.h"

@interface AVFileHTTPRequestOperation : AFJSONRequestOperation
@property (copy) NSString *localPath;
@end
