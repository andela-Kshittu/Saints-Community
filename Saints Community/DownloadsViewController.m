//
//  DownloadsViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 29/04/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import "DownloadsViewController.h"
#import "Utils.h"


@interface DownloadsViewController ()

@end

@implementation DownloadsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [Utils initSidebar:self barButton:self.sideBarButton];
    
    NSArray   *docpaths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSArray   *musicpaths               = NSSearchPathForDirectoriesInDomains(NSMusicDirectory,NSUserDomainMask, YES);
    NSArray   *picturepaths               = NSSearchPathForDirectoriesInDomains(NSPicturesDirectory,NSUserDomainMask, YES);
    NSLog(@"paths in doc %@", docpaths);
     NSLog(@"paths in doc 1 %@", [docpaths lastObject]);
     NSLog(@"paths in doc %lu", (unsigned long)docpaths.count);
     NSLog(@"paths in doc %lu", (unsigned long)picturepaths.count);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *musicDirectory = [docpaths lastObject];
    
    NSError *error = nil;
    NSArray *listOfFiles = [fileManager contentsOfDirectoryAtPath:musicDirectory error:&error];
    
    NSArray *listOfSubPaths = [fileManager subpathsOfDirectoryAtPath:musicDirectory
                                                               error:&error];
    
    NSLog(@"paths in list 1 %@", listOfFiles);
    [fileManager removeItemAtPath:@"Documents/OJURI.mp3"  error:nil];
    NSLog(@"paths in sub list 1 %@", listOfSubPaths);
    
    
//    NSString  *documentsDirectory  = [paths objectAtIndex:0];
//    NSString* imageName            = [documentsDirectory stringByAppendingPathComponent:@"index.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
