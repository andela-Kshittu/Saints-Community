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
        [self deleteEntityRecords:@"Events"];
        [self updateCoreData:events withEntity:@"Events"];
        self.isEventsNetworkError = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %ld", (long)error.code);
            self.isEventsNetworkError = YES;
    }];
}

-(void) getAllUpdates{
    
    NSMutableArray * updates = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString * url = @"http://Charmms.sensorbitgroup.info/api/entries/getAllEntry?key=mN7Q0UWY6xXGWu4C57eruGpE4qnLg1oh18TxTmpwlaQ&model=updates";
    
    [manager GET:url  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[@"success"]);
        [updates addObjectsFromArray:responseObject[@"success"]];
        
        [self deleteEntityRecords:@"Updates"];
        [self updateCoreData:updates withEntity:@"Updates"];
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
    
//     [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:destinationUrl]]];
}

-(NSArray *)fetchData:(NSString *)entityName{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName inManagedObjectContext:self.managedObjectContext];
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

-(void)updateCoreData:(NSMutableArray *) dataObjects
           withEntity:(NSString *)entityName{
    
    for (NSDictionary * dataObject in dataObjects){
        NSManagedObject *managedObject = [NSEntityDescription
                                          insertNewObjectForEntityForName:entityName
                                          inManagedObjectContext:[Utils sharedInstance].managedObjectContext];
        
        NSString * imageUrl = [NSString stringWithFormat:@"http://charmms.sensorbitgroup.info/src/images/uploads/%@",dataObject[@"imagepath"]];
        
        NSLog(@"image url is : %@", imageUrl);
        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        
        [managedObject setValue:dataObject[@"id"] forKey:@"id"];
        [managedObject setValue:imageData forKey:@"image_url"];
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
        NSLog(@"Deleting Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
@end
