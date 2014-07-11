//
//  SearchResultController.m
//  AVOSDemo
//
//  Created by Qihe Bian on 6/9/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "SearchResultController.h"
#import "PBWebViewController.h"

static const int contentLabelTag = 1000;
@interface SearchResultController ()

@end

@implementation SearchResultController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 20, 0)];
        contentLabel.tag = contentLabelTag;
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //        contentLabel.shadowColor = [UIColor whiteColor];
        //        contentLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:contentLabel];
        

    }
    
    if (indexPath.row%2) {
        cell.backgroundColor=[UIColor colorWithRed:247/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    }else{
        cell.backgroundColor=[UIColor whiteColor];
    }
    AVObject *object = [self.objects objectAtIndex:indexPath.row];
//    NSString *appUrl = [object objectForKey:@"_app_url"];
//    NSString *deeplink = [object objectForKey:@"_deeplink"];
    NSMutableString *hightlight = [[[[object objectForKey:@"_highlight"] objectForKey:@"name"] firstObject] mutableCopy];
    NSMutableArray *ranges = [NSMutableArray array];
    NSRange range = [hightlight rangeOfString:@"<em>"];
    while (range.location != NSNotFound) {
        NSRange tempRange = NSMakeRange(range.location, 0);
        [hightlight replaceCharactersInRange:range withString:@""];
        range = [hightlight rangeOfString:@"</em>"];
        [hightlight replaceCharactersInRange:range withString:@""];
        tempRange.length = range.location - tempRange.location;
        NSValue *v = [NSValue valueWithRange:tempRange];
        [ranges addObject:v];
        range = [hightlight rangeOfString:@"<em>"];
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:hightlight];
    for (NSValue *v in ranges) {
        NSRange range = [v rangeValue];
        [string addAttribute:NSBackgroundColorAttributeName
                  value:[UIColor yellowColor]
                  range:range];
    }
    UILabel *contentLabel = (UILabel *)[[cell contentView] viewWithTag:contentLabelTag];
    contentLabel.attributedText = string;
    [contentLabel sizeToFit];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *object = [self.objects objectAtIndex:indexPath.row];
    NSString *appUrl = [object objectForKey:@"_app_url"];
    NSString *deeplink = [object objectForKey:@"_deeplink"];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:deeplink]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:deeplink]];
    } else {
        PBWebViewController *vc = [[PBWebViewController alloc] init];
        vc.URL = [NSURL URLWithString:appUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
