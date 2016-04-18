//
//  AlbumViewController.h
//  Saints Community
//
//  Created by Kehinde Shittu on 23/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreData/CoreData.h>

@interface AlbumViewController : UITableViewController
@property (nonatomic, strong) NSManagedObject* album;
@property (nonatomic, strong) NSArray* tracks;
@end
