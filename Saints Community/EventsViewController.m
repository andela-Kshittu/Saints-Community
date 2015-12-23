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
    
    // Do any additional setup after loading the view.
    [Utils initSidebar:self barButton:self.sidebarButton];
     [Utils sharedInstance].fetchedEvents = [[Utils sharedInstance] fetchData:@"Events"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[Utils sharedInstance].fetchedEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EventsTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Set up the cell...
    //    FailedBankInfo *info = [failedBankInfos objectAtIndex:indexPath.row];
    //    cell.textLabel.text = info.name;
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
    //                                 info.city, info.state];
    NSManagedObject *info = [Utils sharedInstance].fetchedEvents[indexPath.row];
    UIImageView * eventImage = (UIImageView *)[cell viewWithTag:1];
    UILabel * title = (UILabel *)[cell viewWithTag:2];
    UILabel * date = (UILabel *)[cell viewWithTag:3];
   
    
    eventImage.image = [UIImage imageWithData:[info valueForKey:@"image_url"]];
    title.text = [info valueForKey:@"title"];
    date.text = [info valueForKey:@"updated_date"];
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
