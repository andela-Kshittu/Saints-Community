//
//  NowPlayingViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 23/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "Utils.h"
#import "Tracks.h"

@interface NowPlayingViewController ()

@end

@implementation NowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View loaded");
    // Do any additional setup after loading the view.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    });
    [Utils initSidebar:self barButton:self.sidebarButton];
    self.currentTrack = 1;
    self.albumTracks = [[[Tracks albums] objectAtIndex:0] objectForKey:@"tracks"];
    self.albumTitle = [[[Tracks albums] objectAtIndex:0] objectForKey:@"name"];
    
    self.albumName.text = self.albumTitle;
    self.trackName.text = [NSString stringWithFormat:@"Track %d", self.currentTrack];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:@"play"
                                               object:nil];
    self.audioPlayer = [[SCAudioPlayerViewController alloc] init];
    [self setupAudioPlayer];
    [self play];

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
    //insert Filename & FileExtension
//    NSString *fileExtension = @"mp3";
    
    //init the Player to get file properties to set the time labels
//    [self.audioPlayer initPlayer:fileName fileExtension:fileExtension];
    [self.audioPlayer initPlayer:[self.albumTracks objectAtIndex:self.currentTrack - 1]];
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
    self.timeElapsed.text = @"0:00";
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
}

/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playAudioPressed:(id)playButton
{
    if (!self.isPaused) {
       [self resume];
    } else {
        [self play];
    }
    
}

-(void)stop{
    [self.audioPlayer stopAudio];
}

-(void)resume{
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                               forState:UIControlStateNormal];
    
    //start a timer to update the time label display
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateTime:)
                                                userInfo:nil
                                                 repeats:YES];
    
   [self.audioPlayer resumeAudio];
    self.isPaused = TRUE;
}

-(void)play{
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer playAudio];
       
        self.isPaused = TRUE;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.png"]
                                   forState:UIControlStateNormal];
        
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
//    NSNumber *time = [NSNumber numberWithDouble:([online_time doubleValue] - 3600)];
//    NSTimeInterval interval = [time doubleValue];
    if (!self.scrubbing) {
        NSLog(@"scrub update %f", [self.audioPlayer getCurrentAudioTime]);
        self.currentTimeSlider.value = 3.0;
    }
     NSLog(@"time update");
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]]];
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
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
    
    [self.audioPlayer setCurrentAudioTime:(double)self.currentTimeSlider.value];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}

- (void)handleNotification:(NSNotification *)object {
    // Use your NSDictionary object here.
//    self.title = [object userInfo][@"album"];
    
    NSLog(@"this is object data %@", object.userInfo);
    self.albumTitle = [[object userInfo] objectForKey:@"album"];
    self.currentTrack = [[[object userInfo] objectForKey:@"currentTrack"] intValue];
    self.albumTracks = [[object userInfo] objectForKey:@"tracks"];
    
    
    
    self.albumName.text = self.albumTitle;
    self.trackName.text = [NSString stringWithFormat:@"Track %d", self.currentTrack];
    
    [self stop];
    self.isPaused = FALSE;
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
    NSLog(@"total tracks %@", [NSNumber numberWithInteger:self.albumTracks.count]);
    
    NSLog(@"current tracks %d", self.currentTrack);
    
    if (self.currentTrack < self.albumTracks.count) {
        NSLog(@"is less");
        self.currentTrack++;
    } else {
        NSLog(@"is equal or more");
        
        self.currentTrack = 1;
    }
    self.trackName.text = [NSString stringWithFormat:@"Track %d", self.currentTrack];
    
    [self stop];
    self.isPaused = FALSE;
    [self setupAudioPlayer];
    [self play];
}
- (IBAction)previousButtonAction:(id)sender {
    
    if (self.currentTrack > 1) {
        NSLog(@"is less");
        self.currentTrack--;
    } else {
        NSLog(@"is equal or more");
        
        self.currentTrack = [NSNumber numberWithInteger:self.albumTracks.count].intValue;
    }
    self.trackName.text = [NSString stringWithFormat:@"Track %d", self.currentTrack];
    
    [self stop];
    self.isPaused = FALSE;
    [self setupAudioPlayer];
    [self play];
}
@end
