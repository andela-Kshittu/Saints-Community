//
//  LiveStreamingViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "LiveStreamingViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"

@interface LiveStreamingViewController ()
@end

@implementation LiveStreamingViewController
static NSString * LIVE_STREAMING_URl = @"http://live.livingwordmedia.org";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Utils initSidebar:self barButton:self.sidebarButton];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [Utils loadUIWebView:self url:LIVE_STREAMING_URl];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    //SHOW HUD
    NSLog(@"show hud");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //KILL HUD
    NSLog(@"kill hud");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if(!webView.loading){
        //KILL HUD
        NSLog(@"kill hud");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
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
