//
//  AdminViewController.h
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlayerController.h"

@interface AdminViewController : NSViewController<NSTabViewDelegate,PlayerAdminDelegate>

@property (weak) IBOutlet NSButton *addButton;
@property (weak) IBOutlet NSButton *goButton;
@property (weak) IBOutlet NSButton *stopButton;

// Player 1
@property (weak) IBOutlet NSButton *p1Connect;
@property (weak) IBOutlet NSButton *p1Calibrate;
@property (weak) IBOutlet NSProgressIndicator *p1Progress;
@property (weak) IBOutlet NSLevelIndicator *p1Battery;
@property (weak) IBOutlet NSSlider *p1SliderX;
@property (weak) IBOutlet NSSlider *p1SliderY;
@property (weak) IBOutlet NSButton *p1Reset;
@property (weak) IBOutlet NSSegmentedControl *p1Sensitivity;

// PLayer 2
@property (weak) IBOutlet NSButton *p2Connect;
@property (weak) IBOutlet NSButton *p2Calibrate;
@property (weak) IBOutlet NSProgressIndicator *p2Progress;
@property (weak) IBOutlet NSLevelIndicator *p2Battery;
@property (weak) IBOutlet NSSlider *p2SliderX;
@property (weak) IBOutlet NSSlider *p2SliderY;
@property (weak) IBOutlet NSButton *p2Reset;
@property (weak) IBOutlet NSSegmentedControl *p2Sensitivity;

// Gmeplay
@property (weak) IBOutlet NSSlider *gameScale;
@property (weak) IBOutlet NSSlider *gameSpeed;
@property (weak) IBOutlet NSSlider *gameGlitch;

@property (weak) IBOutlet NSSegmentedControl *gameSkill;
@property (weak) IBOutlet NSSegmentedControl *gameRounds;
@property (weak) IBOutlet NSSegmentedControl *gameAmmo;


// Ducks
@property (weak) IBOutlet NSSlider *duck1Speed;
@property (weak) IBOutlet NSSlider *duck1Min;
@property (weak) IBOutlet NSSlider *duck1Max;

@property (weak) IBOutlet NSSlider *duck2Speed;
@property (weak) IBOutlet NSSlider *duck2Min;
@property (weak) IBOutlet NSSlider *duck2Max;

@property (weak) IBOutlet NSSlider *duck3Speed;
@property (weak) IBOutlet NSSlider *duck3Min;
@property (weak) IBOutlet NSSlider *duck3Max;

@end
