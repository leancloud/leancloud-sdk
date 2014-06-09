//
//  AVSearchQueryBasic.m
//  AVOSDemo
//
//  Created by Qihe Bian on 6/9/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "AVSearchQueryBasic.h"
#import "DemoRunC.h"
#import "SearchResultController.h"

static const int showResultButtonTag = 1000;
@implementation AVSearchQueryBasic {
    NSArray *_objects;
}

- (void)demoByKeywordQuery{
    AVSearchQuery *searchQuery = [AVSearchQuery searchWithQueryString:@"test"];
    searchQuery.className = @"Student";
    searchQuery.highlights = @"name";
    searchQuery.limit = 10;
    searchQuery.cachePolicy = kAVCachePolicyCacheElseNetwork;
    searchQuery.maxCacheAge = 60;
    searchQuery.fields = @[@"name"];
    [searchQuery findInBackground:^(NSArray *objects, NSError *error) {
        if (objects) {
            [self log:[NSString stringWithFormat:@"查询结果: \n%@", [objects description]]];
        }else{
            [self log:[NSString stringWithFormat:@"查询出错: \n%@", [error description]]];
        }
        _objects = objects;
        [self addButton];
    }];
}

- (void)addButton {
    if (![self.controller.view viewWithTag:showResultButtonTag]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"结果展示" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blackColor]];
        [button addTarget:self action:@selector(showResult:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = self.controller.view.frame;
        button.frame = CGRectMake(rect.size.width - 100, rect.size.height - 30, 100, 30);
        [self.controller.view addSubview:button];
    }
}

- (void)showResult:(id)sender {
    SearchResultController *vc = [[SearchResultController alloc] init];
    vc.objects = _objects;
    [self.controller.navigationController pushViewController:vc animated:YES];
}

MakeSourcePath
@end
