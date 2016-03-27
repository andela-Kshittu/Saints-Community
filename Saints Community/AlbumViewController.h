//
//  AlbumViewController.h
//  Saints Community
//
//  Created by Kehinde Shittu on 23/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AlbumViewController : UITableViewController
@property (nonatomic, assign) int selectedAlbum;
@property (nonatomic, strong) NSDictionary* album;
@property (nonatomic, strong) NSArray* tracks;
@end
