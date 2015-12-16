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

@interface UpdatesViewController (){
NSArray * updates;
}
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
    
    self.tableView.tableHeaderView.hidden = YES;
    [Utils initSidebar:self barButton:self.sidebarButton];
    updates = [[Utils sharedInstance] fetchData:@"Updates"];
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
    return [updates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"UpdatesTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Set up the cell...
//    FailedBankInfo *info = [failedBankInfos objectAtIndex:indexPath.row];
//    cell.textLabel.text = info.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
//                                 info.city, info.state];
    NSManagedObject *info = updates[indexPath.row];
    UIImageView * updateImage = (UIImageView *)[cell viewWithTag:1];
    UILabel * title = (UILabel *)[cell viewWithTag:2];
    UILabel * date = (UILabel *)[cell viewWithTag:3];
    
    updateImage.image = [UIImage imageWithData:[info valueForKey:@"image_url"]];
    title.text = [info valueForKey:@"title"];
    date.text = [info valueForKey:@"updated_date"];
    return cell;
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
