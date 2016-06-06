//
//  UpdatesViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "UpdatesViewController.h"
#import "Utils.h"
#import <CoreData/CoreData.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"

@interface UpdatesViewController ()
@end

@implementation UpdatesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([Utils sharedInstance].isUpdatesNetworkError) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[Utils sharedInstance] getAllUpdates];
        });
    }
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [Utils initSidebar:self barButton:self.sidebarButton];
    
    // fetch update
    [Utils sharedInstance].fetchedUpdates = [[Utils sharedInstance] fetchData:@"Updates"];
    
    //confirm if update were fetched, if not keep retrying
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fetchTableData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

-(void)fetchTableData{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utils hasConnectivity]) {
            [Utils connectionAlert:self];
        }
    });
    while ([Utils sharedInstance].fetchedUpdates.count < 1 && [Utils sharedInstance].isUpdatesNetworkError) {
         [NSThread sleepForTimeInterval:5.0f];
        [Utils sharedInstance].fetchedUpdates = [[Utils sharedInstance] fetchData:@"Updates"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[Utils sharedInstance].fetchedUpdates count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_4_OR_LESS) {
        return 80;
    } else if(IS_IPHONE_5){
        return 80;
    } else if (IS_IPHONE_6){
        return 80;
    } else if(IS_IPHONE_6P){
        return 80;
    } else {
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"UpdatesTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSManagedObject *info =  [Utils sharedInstance].fetchedUpdates[indexPath.row];
    UIImageView * updateImage = (UIImageView *)[cell viewWithTag:1];
    UILabel * title = (UILabel *)[cell viewWithTag:2];
    UILabel * date = (UILabel *)[cell viewWithTag:3];
    
    [updateImage sd_setImageWithURL:[NSURL URLWithString:[info valueForKey:@"image_url"]]
                   placeholderImage:[UIImage imageNamed:@"info.png"]];
    title.text = [info valueForKey:@"title"];
    date.text = [info valueForKey:@"updated_date"];
    
    //this is an hack for table cells bg on ipad
    cell.backgroundColor = cell.contentView.backgroundColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [Utils sharedInstance].selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"UpdateDetails" sender:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
