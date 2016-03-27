//
//  SCAudioPlayerViewController.h
//  Saints Community
//
//  Created by Kehinde Shittu on 23/03/2016.
//  Copyright © 2016 Kehesjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <STKAudioPlayer.h>

@interface SCAudioPlayerViewController : UIViewController

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) STKAudioPlayer *customAudioPlayer;
@property (nonatomic, retain) NSURL *musicUrl;

// Public methods
- (void)initPlayer:(NSString*) url;
- (void)playAudio;
- (void)pauseAudio;
- (void)stopAudio;
- (void)resumeAudio;
- (void)setCurrentAudioTime:(double)value;
- (double)getAudioDuration;
- (NSString*)timeFormat:(double)value;
- (NSTimeInterval)getCurrentAudioTime;
@end
