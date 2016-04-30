//
//  DownloadingViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 29/04/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import "DownloadingViewController.h"
#import "Utils.h"


@interface DownloadingViewController ()

@end

@implementation DownloadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [Utils initSidebar:self barButton:self.sideBarButton];
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

- (IBAction)sideBarButton:(id)sender {
}
@end
