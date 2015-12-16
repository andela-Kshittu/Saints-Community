//
//  ViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "HomeViewController.h"
#import "Utils.h"


@interface HomeViewController ()
@end

@implementation HomeViewController
static NSString * HOME_URl = @"http://livingwordmedia.org";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [Utils initSidebar:self barButton:self.sidebarButton];
    [Utils loadUIWebView:self.view url:HOME_URl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
