//
//  NowPlayingViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 23/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import "NowPlayingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"
#import "Tracks.h"
#import "MBProgressHUD.h"

@interface NowPlayingViewController (){
bool hasLoader;
}
@end

@implementation NowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View loaded");
    
    [Utils initSidebar:self barButton:self.sidebarButton];
     if (![Utils sharedInstance].isResume) {
    self.albumName.text = [Utils sharedInstance].albumTitle;
    self.trackName.text = [NSString stringWithFormat:@"Track %d", [Utils sharedInstance].currentTrack];
    [self.albumImageView sd_setImageWithURL:[NSURL URLWithString: [Utils sharedInstance].albumImageUrl]
                                             placeholderImage:[UIImage imageNamed:@"ic_logo.png"]];
         
    [Utils sharedInstance].audioPlayer = [[SCAudioPlayerViewController alloc] init];
    [self setupAudioPlayer];
    [self play];
    
     } else {
         self.albumName.text = [Utils sharedInstance].albumTitle;
         self.trackName.text = [NSString stringWithFormat:@"Track %d", [Utils sharedInstance].currentTrack];
         [self.albumImageView sd_setImageWithURL:[NSURL URLWithString: [Utils sharedInstance].albumImageUrl]
                                placeholderImage:[UIImage imageNamed:@"ic_logo.png"]];
         [self resume];
     }
    [Utils sharedInstance].isResume = TRUE;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:@"play"
                                               object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
      NSLog(@"View appeared");
}

/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer
{
    NSString * urlString = [[Utils sharedInstance].albumTracks objectAtIndex:[Utils sharedInstance].currentTrack - 1];
    
    for(NSString* track in [Utils sharedInstance].downloadedTracks){
        NSString *currentTrack = [NSString stringWithFormat:@"Track+%d", [Utils sharedInstance].currentTrack];
        if ([track containsString:currentTrack]) {
            urlString = track;
            NSLog(@"Playing downloaded track : %@", urlString);
        } else {
            NSLog(@"streaming track : %@", urlString);
        }
    }
    
    //init the Player to get file properties to set the time labels
        [[Utils sharedInstance].audioPlayer initPlayer:urlString];
        self.currentTimeSlider.maximumValue = [[Utils sharedInstance].audioPlayer getAudioDuration];
        
        //init the current timedisplay and the labels. if a current time was stored
        //for this player then take it and update the time display
        self.timeElapsed.text = @"0:00";
        self.duration.text = [NSString stringWithFormat:@"-%@",
                              [[Utils sharedInstance].audioPlayer timeFormat:[[Utils sharedInstance].audioPlayer getAudioDuration]]];

   
}

/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playAudioPressed:(id)playButton
{
    if (![Utils sharedInstance].isPaused) {
       [self resume];
    } else {
        [self play];
    }
    
}

-(void)stop{
    [[Utils sharedInstance].audioPlayer stopAudio];
}

-(void)resume{
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                               forState:UIControlStateNormal];
    
    //start a timer to update the time label display
    [Utils sharedInstance].timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateTime:)
                                                userInfo:nil
                                                 repeats:YES];
    
   [[Utils sharedInstance].audioPlayer resumeAudio];
    [Utils sharedInstance].isPaused = TRUE;
}

-(void)play{
    [[Utils sharedInstance].timer invalidate];
    //play audio for the first time or if pause was pressed
    if (![Utils sharedInstance].isPaused) {
        
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        [Utils sharedInstance].timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [[Utils sharedInstance].audioPlayer playAudio];
       
        [Utils sharedInstance].isPaused = TRUE;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.png"]
                                   forState:UIControlStateNormal];
        
        [[Utils sharedInstance].audioPlayer pauseAudio];
        [Utils sharedInstance].isPaused = FALSE;
    }
}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    
    [self.currentTimeSlider setMaximumValue:[[Utils sharedInstance].audioPlayer getAudioDuration]];
    [self.currentTimeSlider setMinimumValue:0.0];
    if (![Utils sharedInstance].scrubbing) {
        [self.currentTimeSlider setValue:[[Utils sharedInstance].audioPlayer getCurrentAudioTime] animated:YES];
    }
     NSLog(@"time update");
    NSString *elapsedText = [NSString stringWithFormat:@"%@",
                            [[Utils sharedInstance].audioPlayer timeFormat:[[Utils sharedInstance].audioPlayer getCurrentAudioTime]]];
    if ([self.timeElapsed.text isEqualToString:elapsedText] && !hasLoader) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hasLoader = true;
    }
    
    if (![self.timeElapsed.text isEqualToString:elapsedText] && hasLoader) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            hasLoader = false;
        });
    }
    self.timeElapsed.text = elapsedText;
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [[Utils sharedInstance].audioPlayer timeFormat:[[Utils sharedInstance].audioPlayer getAudioDuration] - [[Utils sharedInstance].audioPlayer getCurrentAudioTime]]];
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [[Utils sharedInstance].audioPlayer setCurrentAudioTime:(double)self.currentTimeSlider.value];
    [Utils sharedInstance].scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    [Utils sharedInstance].scrubbing = TRUE;
}

- (void)handleNotification:(NSNotification *)object {
    // Use your NSDictionary object here.
//    self.title = [object userInfo][@"album"];
    
    NSLog(@"this is object data %@", object.userInfo);
//    [Utils sharedInstance].albumTitle = [[object userInfo] objectForKey:@"album"];
//    [Utils sharedInstance].currentTrack = [[[object userInfo] objectForKey:@"currentTrack"] intValue];
//    [Utils sharedInstance].albumTracks = [[object userInfo] objectForKey:@"tracks"];
//    [Utils sharedInstance].albumImageUrl = [[object userInfo] objectForKey:@"coverImage"];
    
    
    
    self.albumName.text = [Utils sharedInstance].albumTitle;
    self.trackName.text = [NSString stringWithFormat:@"Track %d", [Utils sharedInstance].currentTrack];
    [self.albumImageView sd_setImageWithURL:[NSURL URLWithString: [Utils sharedInstance].albumImageUrl]
                           placeholderImage:[UIImage imageNamed:@"ic_logo.png"]];
    
    [self stop];
    [Utils sharedInstance].isPaused = FALSE;
    [self setupAudioPlayer];
    [self play];
    
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

- (IBAction)nextButtonAction:(id)sender {
    NSLog(@"total tracks %@", [NSNumber numberWithInteger:[Utils sharedInstance].albumTracks.count]);
    
    NSLog(@"current tracks %d", [Utils sharedInstance].currentTrack);
    
    if ([Utils sharedInstance].currentTrack < [Utils sharedInstance].albumTracks.count) {
        NSLog(@"is less");
        [Utils sharedInstance].currentTrack++;
    } else {
        NSLog(@"is equal or more");
        
        [Utils sharedInstance].currentTrack = 1;
    }
    self.trackName.text = [NSString stringWithFormat:@"Track %d", [Utils sharedInstance].currentTrack];
    
    [self stop];
    [Utils sharedInstance].isPaused = FALSE;
    [self setupAudioPlayer];
    [self play];
}


- (IBAction)previousButtonAction:(id)sender {
    
    if ([Utils sharedInstance].currentTrack > 1) {
        NSLog(@"is less");
        [Utils sharedInstance].currentTrack--;
    } else {
        NSLog(@"is equal or more");
        
        [Utils sharedInstance].currentTrack = [NSNumber numberWithInteger:[Utils sharedInstance].albumTracks.count].intValue;
    }
    self.trackName.text = [NSString stringWithFormat:@"Track %d", [Utils sharedInstance].currentTrack];
    
    [self stop];
    [Utils sharedInstance].isPaused = FALSE;
    [self setupAudioPlayer];
    [self play];
}
@end
