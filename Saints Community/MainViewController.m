//
//  MainViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 27/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import "MainViewController.h"
#import "Utils.h"
#import "UpdatesViewController.h"
#import "MBProgressHUD.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[Utils sharedInstance] getAllEvents];
        [[Utils sharedInstance] getAllUpdates];
        [[Utils sharedInstance] getAllTracks];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews{
    self.proceedButton.layer.cornerRadius = self.proceedButton.layer.frame.size.height/2;
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
