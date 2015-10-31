//
//  Utils.m
//  Saints Community
//
//  Created by Kehinde Shittu on 31/10/2015.
//  Copyright © 2015 Kehesjay. All rights reserved.
//

#import "Utils.h"


@implementation Utils

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
@end
