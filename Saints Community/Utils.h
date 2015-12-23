//
//  Utils.h
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWRevealViewController.h"


@interface Utils : NSObject
@property (nonatomic, strong) NSManagedObjectContext  *managedObjectContext;
@property (nonatomic, assign) BOOL isEventsNetworkError;
@property (nonatomic, assign) BOOL isUpdatesNetworkError;
@property (nonatomic, strong) NSArray* fetchedUpdates;
@property (nonatomic, strong) NSArray* fetchedEvents;
@property (nonatomic, assign) NSInteger selectedIndex;
+(Utils *)sharedInstance;
+(void)initSidebar:(UIViewController *) vc
         barButton:(UIBarButtonItem *) barButton;
+(void)loadUIWebView:(UIView *) view
                 url:(NSString *) destinationUrl;
-(NSArray *)fetchData:(NSString *)entityName;
-(void) getAllUpdates;
-(void) getAllEvents;
@end
