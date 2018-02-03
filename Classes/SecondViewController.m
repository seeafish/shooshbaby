//
//  SecondViewController.m
//  Shoosh
//
//  Created by Sia Gholami on 05/03/2011.
//  Copyright 2011 MyEran. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

@synthesize audioPlayer;
@synthesize soundSelected;
@synthesize theTimer;
@synthesize buttonCount;
@synthesize timerCounter;
@synthesize fadeDelay;
@synthesize fadeDecrease;

- (void)viewDidLoad {
    [super viewDidLoad];

    //Set up chimeSounds array
	chimeSounds = [[NSMutableArray alloc] init];
    [chimeSounds addObject:@"Hush Little Baby"];
    [chimeSounds addObject:@"Twinkle Twinkle"];
    
	//Initialize button counter
	buttonCount = 0;
	
	//Initialize audioPlayer with default sound
	self.soundSelected = [chimeSounds objectAtIndex:0];
    [self initializeAudioPlayer:self.soundSelected];
}

- (void)initializeUserPreferences {
	//Instantiate userPrefs
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	
	//Check for default volume
	if (![userPrefs floatForKey:@"defaultVolume"]) {
		volumeSlider.value = 0.4;
	}
	else {
		volumeSlider.value = [userPrefs floatForKey:@"defaultVolume"];
	}
	
	//Check for fade decrease amount
	if (![userPrefs floatForKey:@"fadeDecreaseBy"]) {
		fadeDecrease = 0.01;
	}
	else {
		fadeDecrease = [userPrefs floatForKey:@"fadeDecreaseBy"];
	}
	
	//Check for fade delay amount
	if (![userPrefs floatForKey:@"fadeDecreaseDelay"]) {
		fadeDelay = 2.0;
	}
	else {
		fadeDelay = [userPrefs floatForKey:@"fadeDecreaseDelay"];
	}
    
    //Check for timer counter
    if (![userPrefs integerForKey:@"timerDefaultCounter"]) {
        timerCounter = 0;
    }
    else {
        timerCounter = [userPrefs integerForKey:@"timerDefaultCounter"];
    }
}

- (void)initializeAudioPlayer:(NSString *)withSound {
    //Create sound ref URL
	NSString *filePath = [[NSBundle mainBundle] pathForResource:withSound ofType:@"m4a"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
	
	//Prepare audioPlayer (first stop any players, if playing)
	self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil] autorelease];
	[self.audioPlayer stop];
	[self.audioPlayer prepareToPlay];
	self.audioPlayer.numberOfLoops = -1;
    
	[fileURL release];
}

- (IBAction)play:(id)sender {
    if(buttonCount != 0)
        [self initializeAudioPlayer:self.soundSelected];
    
    if (((int)buttonCount % 2) == 0) {
		self.audioPlayer.currentTime = 0;
		self.audioPlayer.volume = volumeSlider.value;
		[self.audioPlayer play];
		[playButton setTitle:@"Stop..." forState:UIControlStateNormal];
		buttonCount++;
		[self fadePickerAnimation:NO];
        
        //Timer stuff
        if (timerCounter != 0) {
            theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        }
	}
	else {
		[self initializeSoundAfterStop:YES];
	}
}

- (IBAction)fadeOut:(id)sender {
	[self doVolumeFade];
}

- (void)doVolumeFade {  
	NSString *i;
    
    //Continuously fade the sound until volume is 0
	if (self.audioPlayer.playing == YES) {
		if (self.audioPlayer.volume > 0.01) {
			i = [[NSString alloc] initWithFormat:@"%.0f", (volumeSlider.value * 100)];
            countdown.text = i;
            [i release];
            
            [self fadeButtonAnimation:NO];
			
			volumeSlider.value = volumeSlider.value - fadeDecrease;
			[self changeVolume];
			[self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:fadeDelay];           
		}
		else {
			[self initializeSoundAfterStop:YES];
		}
	}
}

- (IBAction)sliderControl:(id)sender {
	[self changeVolume];
}

- (void)changeVolume {
	//Set the volume to slider value
	self.audioPlayer.volume = volumeSlider.value;
}

- (void)timerFire:(NSTimer *)theTimer {
    [self invokeTimerCountdown:timerCounter];
    timerCounter--;
}

- (void)invokeTimerCountdown:(NSInteger)counter {
    if (counter < 1) {
        [self doVolumeFade];
        [theTimer invalidate];
        self.theTimer = nil;
    }
}

- (void)initializeSoundAfterStop:(BOOL)addToButtonCount {
    //Instantiate userPrefs
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    
	//Initialize audioPlayer once completely stopped
	[self.audioPlayer stop];
	[self.audioPlayer prepareToPlay];
	[playButton setTitle:@"Chime!" forState:UIControlStateNormal];
	if (addToButtonCount == YES) {
		buttonCount++;
	}
	
	//Bring back fade button
	[self fadeButtonAnimation:YES];
	
	//Bring back picker
	[self fadePickerAnimation:YES];
    
    //Stop the timer
    [theTimer invalidate];
    self.theTimer = nil;
    timerCounter = [userPrefs integerForKey:@"timerDefaultCounter"];
}

//PICKER VIEW FUNCTIONS BEGIN
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [chimeSounds count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [chimeSounds objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.soundSelected = [chimeSounds objectAtIndex:row];
	if (self.audioPlayer.playing == YES) {
		[self initializeSoundAfterStop:YES];
	}
	[self initializeAudioPlayer:self.soundSelected];
}
//PICKER VIEW FUNCTIONS END

- (void)fadePickerAnimation:(BOOL)showPicker {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.7];
	
	if (showPicker == NO) {
		soundPicker.alpha = 0.0;
	}
	else if (showPicker == YES) {
		soundPicker.alpha = 1.0;
	}	
	
	[UIView commitAnimations];
}

- (void)fadeButtonAnimation:(BOOL)showButton {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.7];
	
	if (showButton == NO) {
		fadeButton.center = CGPointMake(-160, 100);
		fadeButton.alpha = 0.0;
        countdown.alpha = 1.0;
	}
	else if (showButton == YES) {
		fadeButton.center = CGPointMake(160, 100);
		fadeButton.alpha = 1.0;
        countdown.alpha = 0.0;
	}
	
	[UIView commitAnimations];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	[self initializeUserPreferences];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	//Stop sound and initialize player
	if (self.audioPlayer.playing == YES) {
		[self initializeSoundAfterStop:YES];
	}
	else {
		[self initializeSoundAfterStop:NO];
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [audioPlayer release];
	[chimeSounds release];
	[soundSelected release];
    [theTimer release];
    [super dealloc];
}

@end
