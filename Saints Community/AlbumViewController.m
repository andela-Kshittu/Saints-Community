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

@interface AlbumViewController ()

@end

@implementation AlbumViewController

@synthesize selectedAlbum;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.album = [[Utils sharedInstance].fetchedTracks objectAtIndex:selectedAlbum];
    self.title = [self.album objectForKey:@"name"];
    self.tracks = [self.album objectForKey:@"tracks"];
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//- (UIImage *) getAlbumArtworkWithSize: (CGSize) albumSize
//{
//    MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
//    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: albumTitle forProperty: MPMediaItemPropertyAlbumTitle];
//    [albumQuery addFilterPredicate:albumPredicate];
//    NSArray *albumTracks = [[[Tracks albums] objectAtIndex:selectedAlbum] objectForKey:@"tracks"];
    
//    for (int i = 0; i < [albumTracks count]; i++) {
//        
//        MPMediaItem *mediaItem = [albumTracks objectAtIndex:i];
//        UIImage *artworkImage;
//        
//        MPMediaItemArtwork *artwork = [mediaItem valueForProperty: MPMediaItemPropertyArtwork];
//        artworkImage = [artwork imageWithSize: CGSizeMake (1, 1)];
//        
//        if (artworkImage) {
//            artworkImage = [artwork imageWithSize:albumSize];
//            return artworkImage;
//        }
//        
//    }
    
//   return 
//    }

- (NSString *) getAlbumArtist
{
//    MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
//    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: albumTitle forProperty: MPMediaItemPropertyAlbumTitle];
//    [albumQuery addFilterPredicate:albumPredicate];
//    NSArray *albumTracks = [albumQuery items];
//    
//    for (int i = 0 ; i < [albumTracks count]; i++) {
//        
//        NSString *albumArtist = [[[albumTracks objectAtIndex:0] representativeItem] valueForProperty:MPMediaItemPropertyAlbumArtist];
//        
//        if (albumArtist) {
//            return albumArtist;
//        }
//    }
    
    return [self.album objectForKey:@"artist"];
}

- (NSString *) getAlbumInfo
{
//    MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
//    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: albumTitle forProperty: MPMediaItemPropertyAlbumTitle];
//    [albumQuery addFilterPredicate:albumPredicate];
//    NSArray *albumTracks = [albumQuery items];
//    
//    
//    NSString *trackCount;
//    
//    if ([albumTracks count] > 1) {
//        trackCount = [NSString stringWithFormat:@"%lu Songs", (unsigned long)[albumTracks count]];
//    } else {
//        trackCount = [NSString stringWithFormat:@"1 Song"];
//    }
//    
//    long playbackDuration = 0;
//    
//    for (MPMediaItem *track in albumTracks)
//    {
//        playbackDuration += [[track  valueForProperty:MPMediaItemPropertyPlaybackDuration] longValue];
//    }
//    
//    int albumMimutes = (playbackDuration /60);
//    NSString *albumDuration;
//    
//    if (albumMimutes > 1) {
//        albumDuration = [NSString stringWithFormat:@"%i Mins.", albumMimutes];
//    } else {
//        albumDuration = [NSString stringWithFormat:@"1 Min."];
//    }
    
    return [NSString stringWithFormat:@"Total tracks: %u", [[self.album objectForKey:@"tracks"] count]];
    
}

//- (BOOL) sameArtists
//{
//    MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
//    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: albumTitle forProperty: MPMediaItemPropertyAlbumTitle];
//    [albumQuery addFilterPredicate:albumPredicate];
//    NSArray *albumTracks = [albumQuery items];
//    
//    for (int i = 0 ; i < [albumTracks count]; i++) {
//        
//        if ([[[[albumTracks objectAtIndex:0] representativeItem] valueForProperty:MPMediaItemPropertyArtist] isEqualToString:[[[albumTracks objectAtIndex:i] representativeItem] valueForProperty:MPMediaItemPropertyArtist]]) {
//        } else {
//            return NO;
//        }
//    }
    
//    return YES;
//}

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
        return 120;
    } else {
        return 64;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
//    MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
//    
//    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: albumTitle forProperty: MPMediaItemPropertyAlbumTitle];
//    [albumQuery addFilterPredicate:albumPredicate];
//    
//    NSArray *albumTracks = [albumQuery items];
    
    return  [self.tracks count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        static NSString *CellIdentifier = @"InfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        UIImageView *albumArtworkImageView = (UIImageView *)[cell viewWithTag:100];
        [albumArtworkImageView sd_setImageWithURL:[NSURL URLWithString:[self.album objectForKey:@"coverImage"]]
                                               placeholderImage:[UIImage imageNamed:@"music_folder.png"]];
        
        UILabel *albumArtistLabel = (UILabel *)[cell viewWithTag:101];
        albumArtistLabel.text = [self.album objectForKey:@"artist"];
        
        UILabel *albumInfoLabel = (UILabel *)[cell viewWithTag:102];
        albumInfoLabel.text = [self getAlbumInfo];
        
//        self.tableView.backgroundColor = AverageColorFromImage(albumArtworkImageView.image);
        
        return cell;
    } else {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Track %ld", (long)indexPath.row];
        cell.detailTextLabel.text = [self.album objectForKey:@"artist"];
        cell.imageView.image = [UIImage imageNamed:@"music-1.png"];
//        MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
//        MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: albumTitle forProperty: MPMediaItemPropertyAlbumTitle];
//        [albumQuery addFilterPredicate:albumPredicate];
//        NSArray *albumTracks = [albumQuery items];
        
//        NSUInteger trackNumber = [[[albumTracks objectAtIndex:(indexPath.row-1)]  valueForProperty:MPMediaItemPropertyAlbumTrackNumber] unsignedIntegerValue];
//        
//        if (trackNumber) {
//            cell.textLabel.text = [NSString stringWithFormat:@"%lu. %@", (unsigned long)trackNumber, [[[albumTracks objectAtIndex:(indexPath.row-1)] representativeItem] valueForProperty:MPMediaItemPropertyTitle]];
//        } else {
//            cell.textLabel.text = [[[albumTracks objectAtIndex:(indexPath.row-1)] representativeItem] valueForProperty:MPMediaItemPropertyTitle];
//        }
//        
//        
//        if ([self sameArtists]) {
//            
//            cell.detailTextLabel.text = @"";
//            
//        } else {
//            
//            if ([[[albumTracks objectAtIndex:(indexPath.row-1)] representativeItem] valueForProperty:MPMediaItemPropertyArtist]) {
//                cell.detailTextLabel.text = [[[albumTracks objectAtIndex:(indexPath.row-1)] representativeItem] valueForProperty:MPMediaItemPropertyArtist];
//            } else {
//                cell.detailTextLabel.text = @"";
//            }
//            
//        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init]; // Populate this with your data.
    
    [data setValue:[self.album objectForKey:@"name"] forKey:@"album"];
    [data setValue:self.tracks forKey:@"tracks"];
    [data setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"currentTrack"];
    
    NSDictionary* userInfo = [[NSDictionary alloc] initWithDictionary:data];
    
    // Fire the notification along with your NSDictionary object.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"play" object:self userInfo:userInfo];
    
    [self.parentViewController.tabBarController setSelectedIndex:1];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
//    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: albumTitle forProperty: MPMediaItemPropertyAlbumTitle];
//    [albumQuery addFilterPredicate:albumPredicate];
//    NSArray *albumTracks = [albumQuery items];
//    
//    int selectedIndex = [[self.tableView indexPathForSelectedRow] row];
//    
//    NowPlayingViewController *detailViewController = [segue destinationViewController];
//    detailViewController.albumTitle = @"Album Name";
    
//    MPMediaItem *selectedItem = [[albumTracks objectAtIndex:selectedIndex-1] representativeItem];
//    
//    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
//    
//    [musicPlayer setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[albumQuery items]]];
//    [musicPlayer setNowPlayingItem:selectedItem];
//    
//    [musicPlayer play];
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
