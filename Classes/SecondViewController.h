//
//  SecondViewController.h
//  Shoosh
//
//  Created by Sia Gholami on 05/03/2011.
//  Copyright 2011 MyEran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import <AudioToolbox/AudioToolbox.h>

@class AVAudioPlayer;

@interface SecondViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UIButton *playButton;
	IBOutlet UIButton *fadeButton;
	IBOutlet UISlider *volumeSlider;
    IBOutlet UIPickerView *soundPicker;
    IBOutlet UILabel *countdown;
	AVAudioPlayer *audioPlayer;
	NSInteger buttonCount;
    NSInteger timerCounter;
	NSMutableArray *chimeSounds;
	NSString *soundSelected;
    NSTimer *theTimer;
	float fadeDecrease;
	float fadDelay;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (readwrite, assign) NSInteger buttonCount;
@property (readwrite, assign) NSInteger timerCounter;
@property (nonatomic, retain) NSString *soundSelected;
@property (nonatomic, assign) NSTimer *theTimer;
@property (readwrite, assign) float fadeDecrease;
@property (readwrite, assign) float fadeDelay;

- (IBAction)play:(id)sender;
- (IBAction)fadeOut:(id)sender;
- (IBAction)sliderControl:(id)sender;
- (void)initializeAudioPlayer:(NSString *)withSound;
- (void)initializeSoundAfterStop:(BOOL)addToButtonCount;
- (void)doVolumeFade;
- (void)changeVolume;
- (void)fadePickerAnimation:(BOOL)showPicker;
- (void)fadeButtonAnimation:(BOOL)showButton;
- (void)timerFire:(NSTimer *)theTimer;
- (void)invokeTimerCountdown:(NSInteger)counter;

@end
