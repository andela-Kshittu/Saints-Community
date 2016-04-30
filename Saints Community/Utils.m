//
//  Utils.m
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "Utils.h"
#import <CoreData/CoreData.h>
#import <AFNetworking.h>

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
        self.downloadedTracks = [[NSMutableArray alloc] init];
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
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
+(void)loadUIWebView:(UIView *) view
                  url:(NSString *) destinationUrl
{
    CGRect frame = CGRectMake(view.layer.frame.origin.x, view.layer.frame.origin.y, view.layer.frame.size.width, view.layer.frame.size.height);
    UIWebView *webView = [[UIWebView alloc] initWithFrame: frame];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    [view addSubview:webView];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:destinationUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15.0];
    [webView loadRequest:theRequest];
}

-(NSArray *)fetchData:(NSString *)entityName{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest returnsDistinctResults];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
//    for (NSManagedObject *info in fetchedObjects) {
//        NSLog(@"Name: %@", [info valueForKey:@"name"]);
//        NSManagedObject *details = [info valueForKey:@"details"];
//        NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
//    }
    return fetchedObjects;
}

-(void)download:(NSArray *)tracks inAlbum:(NSString*) albumName{
    
    // create directory
    
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
//    
//    // delete directory
//    BOOL directoryRemoved =[[NSFileManager defaultManager] removeItemAtPath:albumPath
//                                                                      error:&error];
//    if(!error)
//        NSLog(@"directoryRemoved = %i with no error", directoryRemoved);
//    else
//        NSLog(@"directoryRemoved = %i with error %@", directoryRemoved, error);
    
    if(directoryCreated && !error){
    
        for (NSString* track in tracks) {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSURL *URL = [NSURL URLWithString:track];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                
                return [[NSURL URLWithString:albumPath] URLByAppendingPathComponent:[response suggestedFilename]];
                //        return self.downloadedSong;
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"File downloaded to: %@", filePath);
            }];
            [downloadTask resume];
        }
      
    }
    [[Utils sharedInstance].downloadingAlbums removeObject:albumName];
}


-(void)updateCoreData:(NSMutableArray *) dataObjects
           withEntity:(NSString *)entityName{
    
    for (NSDictionary * dataObject in dataObjects){
        NSManagedObject *managedObject = [NSEntityDescription
                                          insertNewObjectForEntityForName:entityName
                                          inManagedObjectContext:[Utils sharedInstance].managedObjectContext];
        NSString * imageUrl = [NSString stringWithFormat:@"http://charmms.sensorbitgroup.info/src/images/uploads/%@",dataObject[@"imagepath"]];
        
        NSLog(@"image url is : %@", imageUrl);
        
//        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        
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
    for (NSManagedObject *object in fetchedObjects)
    {
        [[Utils sharedInstance].managedObjectContext deleteObject:object];
    }
    
    error = nil;
    if (![[Utils sharedInstance].managedObjectContext save:&error]) {
        NSLog(@"Deleting Whoops, couldn't delete: %@", [error localizedDescription]);
    }
}
@end
