//
//  AlbumsViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 23/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AlbumViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Utils.h"
#import "Tracks.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <ChameleonFramework/Chameleon.h>
#import <CoreData/CoreData.h>
#import "MBProgressHUD.h"

@interface AlbumsViewController ()

@end

@implementation AlbumsViewController
{
    NSArray *searchResults;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils initSidebar:self barButton:self.sidebarButton];
    self.tabBarController.tabBarItem.title = @"Audio Folders";
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if([Utils sharedInstance].fetchedTracks.count < 1 && ![Utils hasConnectivity]){
        [Utils connectionAlert:self];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self reloadTableItems];
    });
    } else if ([Utils sharedInstance].fetchedTracks.count > 1 &&![Utils hasConnectivity]){
        [Utils offlineAlert:self];
    }
    
    if (![Utils sharedInstance].isResume) {
        [Utils sharedInstance].currentTrack = 1;
        if ([[Utils sharedInstance].fetchedTracks  count] > 0) {
            [Utils sharedInstance].albumTracks = [[[Utils sharedInstance].fetchedTracks  objectAtIndex:0] valueForKey:@"tracks"];
            [Utils sharedInstance].albumTitle = [[[Utils sharedInstance].fetchedTracks  objectAtIndex:0] valueForKey:@"name"];
            [Utils sharedInstance].albumImageUrl = [[[Utils sharedInstance].fetchedTracks  objectAtIndex:0] valueForKey:@"coverImage"];
        }
    }
}

-(void)reloadTableItems{
    while ([Utils sharedInstance].fetchedTracks.count < 1) {
        [NSThread sleepForTimeInterval:5.0f];
        if ([Utils sharedInstance].isAlbumsNetworkError) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[Utils sharedInstance] getAllTracks];
            });
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.tableView reloadData];
    });
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [[Utils sharedInstance].fetchedTracks count];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [[Utils sharedInstance].fetchedTracks filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *rowItem = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
         rowItem = searchResults[indexPath.row];
         self.searchDisplayController.searchResultsTableView.backgroundColor = self.searchDisplayController.searchBar.backgroundColor;
        self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
         cell.backgroundColor = [UIColor clearColor];
    } else {
         rowItem = [Utils sharedInstance].fetchedTracks[indexPath.row];
    }


    UIImageView * albumImage = (UIImageView *)[cell viewWithTag:1];
    UILabel * title = (UILabel *)[cell viewWithTag:2];
    UILabel * date = (UILabel *)[cell viewWithTag:3];

    title.text = [rowItem valueForKey:@"name"];
    date.text = [NSString stringWithFormat: @"Sermon by: %@", [rowItem valueForKey:@"artist"]];
    
        // Here we use the new provided sd_setImageWithURL: method to load the web image
    [albumImage sd_setImageWithURL:[NSURL URLWithString:[rowItem valueForKey:@"coverImage"]]
                      placeholderImage:[UIImage imageNamed:@"music_folder.png"]];
    
    //this is an hack for table cells bg on ipad
    cell.backgroundColor = cell.contentView.backgroundColor;
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    NSManagedObject * selectedAlbum = nil;
    
    if (self.searchDisplayController.active) {
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        selectedAlbum = [searchResults objectAtIndex:indexPath.row];
    } else {
        indexPath = [self.tableView indexPathForSelectedRow];
        selectedAlbum = [[Utils sharedInstance].fetchedTracks objectAtIndex:indexPath.row];
    }
    
    AlbumViewController *detailViewController = [segue destinationViewController];
    detailViewController.album = selectedAlbum;
}

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
