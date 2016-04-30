//
//  Utils.h
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWRevealViewController.h"
#import "SCAudioPlayerViewController.h"


@interface Utils : NSObject
@property (nonatomic, strong) NSManagedObjectContext  *managedObjectContext;
@property (nonatomic, assign) BOOL isEventsNetworkError;
@property (nonatomic, assign)  BOOL isUpdatesNetworkError;
@property (nonatomic, assign) BOOL isAlbumsNetworkError;
@property (nonatomic, strong) NSArray* fetchedUpdates;
@property (nonatomic, strong) NSMutableArray* downloadingAlbums;
@property (nonatomic, strong) NSMutableArray* downloadedTracks;
@property (nonatomic, strong) NSArray* fetchedEvents;
@property (nonatomic, strong) NSMutableArray* fetchedTracks;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) SCAudioPlayerViewController *audioPlayer;
@property BOOL isPaused;
@property BOOL isResume;
@property BOOL scrubbing;
@property int currentTrack;
@property NSArray* albumTracks;

@property NSString *albumTitle;
@property NSString *albumImageUrl;
@property NSString *downloadPath;
@property NSTimer *timer;



+(Utils *)sharedInstance;
+(void)initSidebar:(UIViewController *) vc
         barButton:(UIBarButtonItem *) barButton;
+(void)loadUIWebView:(UIView *) view
                 url:(NSString *) destinationUrl;
-(NSArray *)fetchData:(NSString *)entityName;
-(void) getAllUpdates;
-(void) getAllEvents;
-(void) getAllTracks;
-(void)download:(NSArray *)tracks inAlbum:(NSString*) albumName;
@end
