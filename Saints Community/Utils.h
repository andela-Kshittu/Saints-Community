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

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)

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
+(void)loadUIWebView:(UIViewController *) viewController
                 url:(NSString *) destinationUrl;
-(NSArray *)fetchData:(NSString *)entityName;
-(void) getAllUpdates;
-(void) getAllEvents;
-(void) getAllTracks;
-(void)download:(NSArray *)tracks inAlbum:(NSString*) albumName;
@end
