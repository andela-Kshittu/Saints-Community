//
//  SideBarViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "SideBarViewController.h"
#import "SWRevealViewController.h"
#import "Utils.h"


@interface SideBarViewController ()

@end

@implementation SideBarViewController{
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor blueColor];
    
    menuItems = @[@"title", @"home", @"updates", @"events", @"radio", @"streaming"];
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_background.png"]];
    
//    self.tableView.backgroundView = tempImageView;
    
//    
//    CGRect oldFrame = self.tableView.tableHeaderView.frame;
//    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + 44.0, oldFrame.size.width, oldFrame.size.height+44);
    
//    
//    [self.tableView.tableHeaderView setFrame:newFrame];
    
//    [self.tableView.tableHeaderView layoutIfNeeded];
//    [self.tableView layoutSubviews];
//      [self.tableView layoutIfNeeded];

    

}

-(void)viewWillLayoutSubviews{
   

}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIColor *headerCellColor = [UIColor colorWithRed:189.0/255 green:163.0/255 blue:29.0/255 alpha:1.00];
    if (indexPath.row > 0) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }else{
//        [cell setBackgroundColor:headerCellColor];
    }
    
//    UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-1,cell.frame.size.width,1)];
//    additionalSeparator.backgroundColor = [UIColor blackColor];
//    [cell addSubview:additionalSeparator];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //this is an hack for table cells bg on ipad
    cell.backgroundColor = cell.contentView.backgroundColor;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        if (IS_IPHONE_4_OR_LESS) {
            return 140;
        } else if(IS_IPHONE_5){
            return 140;
        } else if (IS_IPHONE_6){
            return 180;
        } else if(IS_IPHONE_6P){
            return 180;
        } else {
            return 260;
        }
    } else {
        if (IS_IPHONE_4_OR_LESS) {
            return 54;
        } else if(IS_IPHONE_5){
            return 54;
        } else if (IS_IPHONE_6){
            return 64;
        } else if(IS_IPHONE_6P){
            return 64;
        } else {
            return 100;
        }
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
