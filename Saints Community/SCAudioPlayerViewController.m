//
//  SCAudioPlayerViewController.m
//  Saints Community
//
//  Created by Kehinde Shittu on 23/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import "SCAudioPlayerViewController.h"

@interface SCAudioPlayerViewController ()

@end

@implementation SCAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initPlayer:(NSString*) url
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.musicUrl = [NSURL URLWithString:url];
    self.customAudioPlayer = [[STKAudioPlayer alloc] init];
}

/*
 * Simply fire the play Event
 */
- (void)playAudio {
//    [self.audioPlayer play];
    [self.customAudioPlayer playURL:self.musicUrl];
}

- (void)stopAudio {
    [self.customAudioPlayer stop];
    self.customAudioPlayer = nil;
}

- (void)resumeAudio {
    [self.customAudioPlayer resume];
}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
     [self.customAudioPlayer pause];
}


/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
-(NSString*)timeFormat:(double)value{
    
    double minutes = floor(lroundf(value)/60);
    double seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lround(seconds);
    int roundedMinutes = lround(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

/*
 * To set the current Position of the
 * playing audio File
 */
- (void)setCurrentAudioTime:(double)value {
     [self.customAudioPlayer seekToTime:value];
}

/*
 * Get the time where audio is playing right now
 */
- (NSTimeInterval)getCurrentAudioTime {
    return [self.customAudioPlayer progress];
}

/*
 * Get the whole length of the audio file
 */
- (double)getAudioDuration {
    return  [self.customAudioPlayer duration];
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
