//
//  AlbumViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 23/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import "AlbumViewController.h"
#import "NowPlayingViewController.h"
#import "Tracks.h"
#import "Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <ChameleonFramework/Chameleon.h>
#import "ACPDownloadView.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.album valueForKey:@"name"];
    [Utils sharedInstance].downloadedTracks = [[NSMutableArray alloc] init];
    
    self.albumPath = [NSString stringWithFormat:@"%@%@",[Utils sharedInstance].downloadPath,[[self.album valueForKey:@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
    [self fetchDownloadedTracks];
  
    
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)fetchDownloadedTracks{
    NSError *error = nil;
    NSArray *listOfFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self.albumPath stringByReplacingOccurrencesOfString:@"file:///" withString:@""] error:&error];
    NSLog(@"paths in list 1 %@", listOfFiles);
    
    for (NSString* track in listOfFiles) {
        [[Utils sharedInstance].downloadedTracks addObject:[self.albumPath stringByAppendingString:[NSString stringWithFormat:@"/%@", track]]];
    }
    NSLog(@"local tracks %@", [Utils sharedInstance].downloadedTracks);
    self.tracks = [self.album valueForKey:@"tracks"];
}

- (NSString *) getAlbumArtist
{
    return [self.album valueForKey:@"artist"];
}

- (NSString *) getAlbumInfo
{
    return [NSString stringWithFormat:@"Total tracks: %lu", [[self.album valueForKey:@"tracks"] count]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        if (IS_IPHONE_4_OR_LESS) {
          return 180;
        } else if(IS_IPHONE_5){
            return 180;
        } else if (IS_IPHONE_6){
            return 180;
        } else if(IS_IPHONE_6P){
            return 180;
        } else {
            return 300;
        }
    } else {
        if (IS_IPHONE_4_OR_LESS) {
            return 64;
        } else if(IS_IPHONE_5){
            return 64;
        } else if (IS_IPHONE_6){
            return 64;
        } else if(IS_IPHONE_6P){
            return 64;
        } else {
            return 100;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return  [self.tracks count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        static NSString *CellIdentifier = @"InfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        UIImageView *albumArtworkImageView = (UIImageView *)[cell viewWithTag:100];
        [albumArtworkImageView sd_setImageWithURL:[NSURL URLWithString:[self.album valueForKey:@"coverImage"]]
                                               placeholderImage:[UIImage imageNamed:@"music_folder.png"]];
        
        UILabel *albumArtistLabel = (UILabel *)[cell viewWithTag:101];
        albumArtistLabel.text = [self.album valueForKey:@"artist"];
        
        UILabel *albumInfoLabel = (UILabel *)[cell viewWithTag:102];
        albumInfoLabel.text = [self getAlbumInfo];
        UILabel *offlineTracksLabel = (UILabel *)[cell viewWithTag:104];
        offlineTracksLabel.text = [NSString stringWithFormat:@"Available offline: %lu", (unsigned long)[Utils sharedInstance].downloadedTracks.count];
        
        
        ACPDownloadView* downloadProgress = (ACPDownloadView*)[cell viewWithTag:105];
        
            [downloadProgress setActionForTap:^(ACPDownloadView *downloadView, ACPDownloadStatus status){
                switch (status) {
                    case ACPDownloadStatusNone:
                        [downloadView setIndicatorStatus:ACPDownloadStatusIndeterminate];
                        [[Utils sharedInstance].downloadingAlbums addObject:[self.album valueForKey:@"name"]];
                        [[Utils sharedInstance].downloadingAlbumsProgress setValue:[NSNumber numberWithFloat:0.0] forKey:[self.album valueForKey:@"name"]];
                        if ([Utils sharedInstance].downloadedTracks.count > 0){
                            NSLog(@"is downloading array %@",[Utils sharedInstance].downloadingAlbums);
                            // remove already downloaded tracks
                            int count = 0;
                            NSMutableArray *trackToDownload = [[NSMutableArray alloc] initWithArray:self.tracks];
                            for(NSString* track in [Utils sharedInstance].downloadedTracks){
                                count++;
                                NSString *currentTrackName = [NSString stringWithFormat:@"Track+%d", count];
                                if ([track containsString:currentTrackName]) {
                                    [trackToDownload removeObjectAtIndex:count - 1];
                                }
                            }
                            [[Utils sharedInstance] download:trackToDownload progressView:downloadView inAlbum:[self.album valueForKey:@"name"]];
                        } else {

                            NSLog(@"is downloading array %@",[Utils sharedInstance].downloadingAlbums);
                            NSLog(@"is downloading array %@",[Utils sharedInstance].downloadingAlbumsProgress);
                            [[Utils sharedInstance] download:self.tracks progressView:downloadView inAlbum:[self.album valueForKey:@"name"]];
                        }
                        [self loadProgressView:downloadView];
                        break;
                    case ACPDownloadStatusRunning:
                        [downloadView setIndicatorStatus:ACPDownloadStatusNone];
                        [[Utils sharedInstance].downloadingAlbums removeObject:[self.album valueForKey:@"name"]];
                        [[Utils sharedInstance].downloadingAlbumsProgress removeObjectForKey:[self.album valueForKey:@"name"]];
                        break;
                    case ACPDownloadStatusIndeterminate:
                        break;
                    case ACPDownloadStatusCompleted:
                        break;
                    default:
                        break;
                }
            }];
        
        UIButton* downloadButton = (UIButton *)[cell viewWithTag:103];
        downloadButton.layer.borderWidth = 1.0;
        downloadButton.layer.borderColor = [UIColor blackColor].CGColor;
        downloadButton.layer.cornerRadius = 10;
        downloadButton.hidden = YES;
        if ([[Utils sharedInstance].downloadingAlbumsProgress valueForKey:[self.album valueForKey:@"name"]] != nil) {
            [downloadProgress setIndicatorStatus:ACPDownloadStatusIndeterminate];
            [self loadProgressView:downloadProgress];
            
        }else{
            if ([Utils sharedInstance].downloadedTracks.count == self.tracks.count) {
                [downloadButton setEnabled:NO];
                [downloadButton setTitle:@"All tracks downloaded" forState:UIControlStateNormal];
                downloadProgress.hidden = YES;
                downloadButton.hidden = NO;
            }else if ([Utils sharedInstance].downloadedTracks.count > 0){
                [downloadProgress setIndicatorStatus:ACPDownloadStatusNone];
            }
        };
        
         cell.backgroundColor = [UIColor flatSandColor];
        return cell;
    } else {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Track %ld", (long)indexPath.row];
        cell.detailTextLabel.text = [self.album valueForKey:@"artist"];
        cell.imageView.image = [UIImage imageNamed:@"audio_file_filled-1.png"];
        // name to check in downloaded tracks
        NSString *currentTrackName = [NSString stringWithFormat:@"Track+%ld", (long)indexPath.row];
        
        for(NSString* track in [Utils sharedInstance].downloadedTracks){
            if ([track containsString:currentTrackName]) {
              // show offline image
                cell.imageView.image = [UIImage imageNamed:@"audio_file_filled.png"];
            }
        }
        //        this is an hack for table cells bg on ipad
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
}
- (void)increment:(NSTimer *)timer{
     NSString *albumName = timer.userInfo[@"album"];
    if ([[Utils sharedInstance].downloadingAlbums containsObject:albumName ]) {
    float progress = [(NSNumber*)[[Utils sharedInstance].downloadingAlbumsProgress valueForKey:albumName] floatValue] ;
    NSLog(@"album name : %@", albumName);
    NSLog(@"download progress object 2 %@", [Utils sharedInstance].downloadingAlbumsProgress);
    NSLog(@"Progress %f", progress);
    [timer.userInfo[@"progressView"] setIndicatorStatus:ACPDownloadStatusRunning];
    [timer.userInfo[@"progressView"] setProgress:progress
                                        animated:YES];
    } else{
        NSLog(@"called timer");
          [timer.userInfo[@"progressView"] setIndicatorStatus:ACPDownloadStatusNone];
          [self fetchDownloadedTracks];
          dispatch_async(dispatch_get_main_queue(), ^{
              [self.tableView reloadData];
          });
        [timer invalidate];
        timer = nil;
    }
}

-(void)loadProgressView:(ACPDownloadView * )progressView{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init]; // Populate this with your data.
    [data setValue:progressView forKey:@"progressView"];
    [data setValue:[self.album valueForKey:@"name"]
            forKey:@"album"];
    NSDictionary* userInfo = [[NSDictionary alloc] initWithDictionary:data];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(increment:)
                                            userInfo:userInfo repeats:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row > 0){
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init]; // Populate this with your data.
        
        [Utils sharedInstance].albumTitle = [self.album valueForKey:@"name"];
        [Utils sharedInstance].currentTrack = [[NSNumber numberWithInteger:indexPath.row] intValue];
        [Utils sharedInstance].albumTracks = self.tracks;
        [Utils sharedInstance].albumImageUrl = [self.album valueForKey:@"coverImage"];
    
    NSDictionary* userInfo = [[NSDictionary alloc] initWithDictionary:data];
    
    // Fire the notification along with your NSDictionary object.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"play" object:self userInfo:userInfo];
    
    [self.parentViewController.tabBarController setSelectedIndex:1];
    }
}

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
