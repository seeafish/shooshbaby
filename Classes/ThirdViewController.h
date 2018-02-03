//
//  ThirdViewController.h
//  Shoosh
//
//  Created by Sia Gholami on 05/03/2011.
//  Copyright 2011 MyEran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ThirdViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate> {
	IBOutlet UIButton *reportBugButton;
	IBOutlet UISlider *defaultVolumeSlider;
	IBOutlet UILabel *defaultVolumeLabel;
	IBOutlet UISwitch *fadeFasterSwitch;
    IBOutlet UISwitch *timerSwitch;
	IBOutlet UILabel *fadeFasterLabel;
   	IBOutlet UILabel *timerLabel;
    IBOutlet UILabel *logoAccreditLabel;
    IBOutlet UILabel *secondsLabel;
    IBOutlet UITextField *secondsField;
    NSInteger timerCounter;
}

@property (readwrite, assign) NSInteger timerCounter;

- (void)initializeUserPrefs;
- (IBAction)reportBug:(id)sender;
- (void)showEmailModalView;
- (IBAction)setDefaultVolume:(id)sender;
- (IBAction)changeFadeDefault:(id)sender;
- (IBAction)changeTimerDefault:(id)sender;
- (void)hideSecondsFields;

@end
