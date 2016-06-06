//
//  EventsViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "EventsViewController.h"
#import "Utils.h"
#import <CoreData/CoreData.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"

@interface EventsViewController ()
@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([Utils sharedInstance].isEventsNetworkError) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[Utils sharedInstance] getAllEvents];
        });
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
    [Utils initSidebar:self barButton:self.sidebarButton];
    
    // fetch events
    [Utils sharedInstance].fetchedEvents = [[Utils sharedInstance] fetchData:@"Events"];
    
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
    while ([Utils sharedInstance].fetchedUpdates.count < 1 && [Utils sharedInstance].isEventsNetworkError) {
        [NSThread sleepForTimeInterval:5.0f];
        [Utils sharedInstance].fetchedEvents = [[Utils sharedInstance] fetchData:@"Events"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[Utils sharedInstance].fetchedEvents count];
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
    
    static NSString *CellIdentifier = @"EventsTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSManagedObject *info = [Utils sharedInstance].fetchedEvents[indexPath.row];
    UIImageView * eventImage = (UIImageView *)[cell viewWithTag:1];
    UILabel * title = (UILabel *)[cell viewWithTag:2];
    UILabel * date = (UILabel *)[cell viewWithTag:3];
   
    
    [eventImage sd_setImageWithURL:[NSURL URLWithString:[info valueForKey:@"image_url"]]
                   placeholderImage:[UIImage imageNamed:@"upcoming.png"]];
    title.text = [info valueForKey:@"title"];
    date.text = [info valueForKey:@"updated_date"];
    
    //this is an hack for table cells bg on ipad
    cell.backgroundColor = cell.contentView.backgroundColor;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [Utils sharedInstance].selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"EventDetails" sender:nil];
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
