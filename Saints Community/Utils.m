//
//  Utils.m
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "Utils.h"
#import <CoreData/CoreData.h>
@implementation Utils

static Utils * sharedObject = nil;

+(Utils *)sharedInstance{
    if (! sharedObject) {
         sharedObject = [[Utils alloc] init];
    }
return sharedObject;
}

- (id)init
{
    if (! sharedObject) {
        sharedObject = [super init];
        self.downloadingAlbums = [[NSMutableArray alloc] init];
        self.downloadingAlbumsProgress = [[NSMutableDictionary alloc] init];
        self.downloadedTracks = [[NSMutableArray alloc] init];
        NSError *error = nil;
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];

       [[NSFileManager defaultManager] createDirectoryAtPath:[[[documentsDirectoryURL relativeString] stringByReplacingOccurrencesOfString:@"file:///" withString:@""] stringByAppendingPathComponent:@"Downloads"]
                                                          withIntermediateDirectories:YES
                                                                           attributes:nil
                                                                                error:&error];
        
        self.downloadPath = [[documentsDirectoryURL URLByAppendingPathComponent:@"Downloads"] relativeString];
    }
    return sharedObject;
}


-(void) getAllEvents{
    
    NSMutableArray * events = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * url = @"http://Charmms.sensorbitgroup.info/api/entries/getAllEntry?key=mN7Q0UWY6xXGWu4C57eruGpE4qnLg1oh18TxTmpwlaQ&model=events";
    
    [manager GET:url  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[@"success"]);
        [events addObjectsFromArray:responseObject[@"success"]];
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self deleteEntityRecords:@"Events"];
            [self updateCoreData:events withEntity:@"Events"];
         });
        self.isEventsNetworkError = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %ld", (long)error.code);
            self.isEventsNetworkError = YES;
    }];
}

-(void) getAllTracks{

    NSMutableArray * albums = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * url = @"https://scmobileapi.herokuapp.com/messages";
    
    [manager GET:url  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.fetchedTracks = [[NSMutableArray alloc] init];
//        [self.fetchedTracks addObjectsFromArray:responseObject];
        [albums addObjectsFromArray:responseObject];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self deleteEntityRecords:@"Albums"];
            [self updateCoreDataAlbums:albums];
             [Utils sharedInstance].fetchedTracks = albums;
        });
        self.isAlbumsNetworkError = NO;
         NSLog(@"JSON: %@", self.fetchedTracks);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %ld", (long)error.code);
        self.isAlbumsNetworkError = YES;
    }];
}

-(void) getAllUpdates{
    
    NSMutableArray * updates = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * url = @"http://Charmms.sensorbitgroup.info/api/entries/getAllEntry?key=mN7Q0UWY6xXGWu4C57eruGpE4qnLg1oh18TxTmpwlaQ&model=updates";
    
    [manager GET:url  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[@"success"]);
        [updates addObjectsFromArray:responseObject[@"success"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self deleteEntityRecords:@"Updates"];
            [self updateCoreData:updates withEntity:@"Updates"];
        });
        self.isUpdatesNetworkError = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.isUpdatesNetworkError = YES;
    }];
}


+(void) initSidebar:(UIViewController *) vc
         barButton:(UIBarButtonItem *) barButton
{
    SWRevealViewController *revealViewController = vc.revealViewController;
    if ( revealViewController )
    {
        [barButton setTarget: vc.revealViewController];
        [barButton setAction: @selector( revealToggle: )];
        [vc.view addGestureRecognizer:vc.revealViewController.panGestureRecognizer];
    }
}
+(void)loadUIWebView:(UIViewController *) viewController
                  url:(NSString *) destinationUrl
{
    UIView *view = viewController.view;
    CGRect frame = CGRectMake(view.layer.frame.origin.x, view.layer.frame.origin.y + 44, view.layer.frame.size.width, view.layer.frame.size.height - 44);
    UIWebView *webView = [[UIWebView alloc] initWithFrame: frame];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    webView.delegate = viewController;
    [view addSubview:webView];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:destinationUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15.0];
    [webView loadRequest:theRequest];
}

+(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if (reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // If target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // If target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs.
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}
+(void)connectionAlert:(UIViewController *)controller{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Error!"
                                                                                 message:@"Please ensure you have a working connection."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [controller presentViewController:alertController animated:YES completion:nil];
}
+(void)offlineAlert:(UIViewController *)controller{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                             message:@"Unable to connect, switching to offline mode.Media streaming won't be available but you can still play downloaded tracks."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [controller presentViewController:alertController animated:YES completion:nil];
}

-(NSArray *)fetchData:(NSString *)entityName{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest returnsDistinctResults];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

-(void)download:(NSArray *)tracks
   progressView:(ACPDownloadView*) downloadView
        inAlbum:(NSString*) albumName{
    // create directory
      NSLog(@"is downloading array %@",self.downloadingAlbums);
    NSError *error = nil;
    NSString *albumPath = [NSString stringWithFormat:@"%@%@",self.downloadPath,[albumName stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
    
    BOOL directoryCreated = [[NSFileManager defaultManager] createDirectoryAtPath:[albumPath stringByReplacingOccurrencesOfString:@"file:///" withString:@""]
                                                      withIntermediateDirectories:YES
                                                                       attributes:nil
                                                                            error:&error];
    NSLog(@"url %@", albumPath);
    if(!error)
        NSLog(@"directoryCreated = %i with no error", directoryCreated);
    else
        NSLog(@"directoryCreated = %i with error %@", directoryCreated, error);
    
    if(directoryCreated && !error){
        NSMutableArray* downlodedTracks = [[NSMutableArray alloc] init];
        for (NSString* track in tracks) {
        
            NSLog(@"download count %@", downlodedTracks);
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSURL *URL = [NSURL URLWithString:track];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            NSProgress *progress;
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
               [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
                return [[NSURL URLWithString:albumPath] URLByAppendingPathComponent:[response suggestedFilename]];
                //        return self.downloadedSong;
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                [downlodedTracks addObject:@"downloaded"];
                NSLog(@"File downloaded to: %@", filePath);
                if (downlodedTracks.count == tracks.count) {
                    [self.downloadingAlbums removeObject:albumName];
                    [self.downloadingAlbumsProgress removeObjectForKey:albumName];
                    NSLog(@"removed name %@",albumName);
                    NSLog(@"removed name from array %@",self.downloadingAlbums);
                }
                
            }];
            [downloadTask resume];
            [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                if ([self.downloadingAlbums containsObject:albumName ]) {
                    NSNumber* oldState = (NSNumber*)[self.downloadingAlbumsProgress valueForKey:albumName];
                    NSNumber* numBytesWritten = @(bytesWritten);
                    NSNumber* numTotalBytesWritten = @(totalBytesWritten);
                    NSNumber* numTotalBytesExpectedToWrite = @(totalBytesExpectedToWrite);
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.downloadingAlbumsProgress setValue:@([oldState floatValue] + [numBytesWritten floatValue]/[numTotalBytesExpectedToWrite floatValue]/tracks.count) forKey:albumName];
                    NSLog(@"download progress object 1 %@", self.downloadingAlbumsProgress);
                });
                    NSLog(@"total Progress…calculated number %@", @([oldState floatValue] + [numBytesWritten floatValue]/[numTotalBytesExpectedToWrite floatValue]/tracks.count));
                } else{
                    [downloadTask cancel];
                }
              

            }];
            
        }
      
    }
}

-(void)updateCoreData:(NSMutableArray *) dataObjects
           withEntity:(NSString *)entityName{
    
    for (NSDictionary * dataObject in dataObjects){
        NSManagedObject *managedObject = [NSEntityDescription
                                          insertNewObjectForEntityForName:entityName
                                          inManagedObjectContext:[Utils sharedInstance].managedObjectContext];
        NSString * imageUrl = [NSString stringWithFormat:@"http://charmms.sensorbitgroup.info/src/images/uploads/%@",dataObject[@"imagepath"]];
        
        NSLog(@"image url is : %@", imageUrl);
        [managedObject setValue:dataObject[@"id"] forKey:@"id"];
        [managedObject setValue:imageUrl forKey:@"image_url"];
        [managedObject setValue:dataObject[@"title"] forKey:@"title"];
        [managedObject setValue:dataObject[@"description"] forKey:@"entity_description"];
        [managedObject setValue:dataObject[@"created_date"] forKey:@"created_date"];
        [managedObject setValue:dataObject[@"updated_date"] forKey:@"updated_date"];
        
        
        
        NSError *error;
        if (![[Utils sharedInstance].managedObjectContext save:&error]) {
            NSLog(@"Updating Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

-(void)updateCoreDataAlbums:(NSMutableArray *) dataObjects{
    
    for (NSDictionary * dataObject in dataObjects){
        NSManagedObject *managedObject = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"Albums"
                                          inManagedObjectContext:[Utils sharedInstance].managedObjectContext];
        
        [managedObject setValue:dataObject[@"id"] forKey:@"id"];
        [managedObject setValue:dataObject[@"coverImage"] forKey:@"coverImage"];
        [managedObject setValue:dataObject[@"artist"] forKey:@"artist"];
        [managedObject setValue:dataObject[@"name"] forKey:@"name"];
        [managedObject setValue:dataObject[@"tracks"] forKey:@"tracks"];
        [managedObject setValue:dataObject[@"year"] forKey:@"year"];
        
        NSError *error;
        if (![[Utils sharedInstance].managedObjectContext save:&error]) {
            NSLog(@"Updating Whoops, couldn't save Album: %@ : %@", dataObject[@"name"],  [error localizedDescription]);
        }
    }
}


-(void)deleteEntityRecords:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [[Utils sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count > 0) {
        for (NSManagedObject *object in fetchedObjects)
        {
            [[Utils sharedInstance].managedObjectContext deleteObject:object];
        }
        
        error = nil;
        if (![[Utils sharedInstance].managedObjectContext save:&error]) {
            NSLog(@"Deleting Whoops, couldn't delete: %@", [error localizedDescription]);
        }
    }
   
}
@end
