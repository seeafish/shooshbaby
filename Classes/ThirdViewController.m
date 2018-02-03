//
//  ThirdViewController.m
//  Shoosh
//
//  Created by Sia Gholami on 05/03/2011.
//  Copyright 2011 MyEran. All rights reserved.
//

#import "ThirdViewController.h"

@implementation ThirdViewController

@synthesize timerCounter;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self initializeUserPrefs];
}

- (void)initializeUserPrefs {
	//Instantiate userPrefs
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	
	//Default volume setting
	if (![userPrefs floatForKey:@"defaultVolume"]) {
		[userPrefs setFloat:0.4 forKey:@"defaultVolume"];
	}
	else {
		defaultVolumeSlider.value = [userPrefs floatForKey:@"defaultVolume"];
	}
	
	//Fade faster state setting
	if (![userPrefs boolForKey:@"fadeFasterSwitchState"]) {
		[userPrefs setBool:fadeFasterSwitch.on = NO forKey:@"fadeFasterSwitchState"];
	}
	else {
		fadeFasterSwitch.on = [userPrefs boolForKey:@"fadeFasterSwitchState"];
	}
    
    //Time switch state setting
    if (![userPrefs boolForKey:@"timerSwitchState"]) {
        [userPrefs setBool:timerSwitch.on = NO forKey:@"timerSwitchState"];
        [userPrefs setInteger:0 forKey:@"timerDefaultCounter"];
    }
    else {
        timerSwitch.on = [userPrefs boolForKey:@"timerSwitchState"];
    }
}

- (IBAction)reportBug:(id)sender {
	[self showEmailModalView];
}

- (void)showEmailModalView {
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	NSArray *toList = [NSArray arrayWithObject:@"siagholami@gmail.com"];
	
	[picker setSubject:@"Some feedback for Shoosh baby"];
	[picker setToRecipients:toList];
    [picker setMessageBody:@"Hi Sia!<br /><br />" isHTML:YES];
	picker.navigationBar.barStyle = UIBarStyleBlack;
	[self presentModalViewController:picker animated:YES];
	
	[picker release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)setDefaultVolume:(id)sender {
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	[userPrefs setFloat:defaultVolumeSlider.value forKey:@"defaultVolume"];
}

- (IBAction)changeFadeDefault:(id)sender {
	//Instantiate userPrefs
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	
	if (fadeFasterSwitch.on == YES) {
		[userPrefs setBool:fadeFasterSwitch.on = YES forKey:@"fadeFasterSwitchState"];
		[userPrefs setFloat:0.01 forKey:@"fadeDecreaseBy"];
		[userPrefs setFloat:1.0 forKey:@"fadeDecreaseDelay"];
	}
	else if (fadeFasterSwitch.on == NO) {
		[userPrefs setBool:fadeFasterSwitch.on = NO forKey:@"fadeFasterSwitchState"];
		[userPrefs setFloat:0.01 forKey:@"fadeDecreaseBy"];
		[userPrefs setFloat:2.0 forKey:@"fadeDecreaseDelay"];
	}
}

- (IBAction)changeTimerDefault:(id)sender {
	//Instantiate userPrefs
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	
	if (timerSwitch.on == YES) {
		[userPrefs setBool:timerSwitch.on = YES forKey:@"timerSwitchState"];
	}
	else if (timerSwitch.on == NO) {
		[userPrefs setBool:timerSwitch.on = NO forKey:@"timerSwitchState"];
        [userPrefs setInteger:0 forKey:@"timerDefaultCounter"];
	}
    
    [self hideSecondsFields];
}

- (void)hideSecondsFields {
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    
    //Set text field value to userPref
    self->secondsField.text = [NSString stringWithFormat:@"%i", [userPrefs integerForKey:@"timerDefaultCounter"]];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
    
    if ([userPrefs boolForKey:@"timerSwitchState"] == NO) {
        secondsField.alpha = 0.0;
        secondsLabel.alpha = 0.0;
    }
    else if ([userPrefs boolForKey:@"timerSwitchState"] == YES) {
        secondsField.alpha = 1.0;
        secondsLabel.alpha = 1.0;
    }
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    //Instantiate userPrefs
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    
    NSString* string;
    
    if (theTextField == self->secondsField) {
        string = theTextField.text;
        timerCounter = [string intValue];
        [userPrefs setInteger:timerCounter forKey:@"timerDefaultCounter"];
        [theTextField resignFirstResponder];
    }
    return YES;
    
    [string release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self hideSecondsFields]; 
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

@end
