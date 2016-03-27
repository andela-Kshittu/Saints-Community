//
//  NowPlayingViewController.h
//  Saints Community
//
//  Created by Kehinde Shittu on 23/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAudioPlayerViewController.h"

@interface NowPlayingViewController : UIViewController
@property (nonatomic, strong) SCAudioPlayerViewController *audioPlayer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
@property (strong, nonatomic) IBOutlet UILabel *albumName;
@property (strong, nonatomic) IBOutlet UILabel *trackName;
- (IBAction)previousButtonAction:(id)sender;


@property BOOL isPaused;
@property BOOL isResume;
@property BOOL scrubbing;
@property int currentTrack;
@property NSArray* albumTracks;

@property NSString *albumTitle;

@property NSTimer *timer;
@end
