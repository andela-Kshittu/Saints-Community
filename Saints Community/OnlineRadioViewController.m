//
//  OnlineRadioViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "OnlineRadioViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"

@interface OnlineRadioViewController ()
@end

@implementation OnlineRadioViewController
static NSString * RADIO_URL = @"http://lwm.radiojar.com/";
- (void)viewDidLoad {
    [Utils initSidebar:self barButton:self.sidebarButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated{
    if ([Utils hasConnectivity]) {
        [Utils loadUIWebView:self url:RADIO_URL];
    } else {
        [Utils connectionAlert:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    //SHOW HUD
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //KILL HUD
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if(!webView.loading){
        //KILL HUD
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
