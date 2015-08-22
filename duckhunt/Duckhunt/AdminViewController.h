//
//  AdminViewController.h
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlayerController.h"

@interface AdminViewController : NSViewController<PlayerControllerDelegate>


@property (weak) IBOutlet NSButton *addButton;


@property (weak) IBOutlet NSButton *goButton;
@property (weak) IBOutlet NSButton *stopButton;


@property (weak) IBOutlet NSButton *p1Connect;
@property (weak) IBOutlet NSButton *p1Calibrate;
@property (weak) IBOutlet NSProgressIndicator *p1Progress;
@property (strong) IBOutlet NSLevelIndicator *p1Battery;
@property (weak) IBOutlet NSSlider *p1SliderX;
@property (weak) IBOutlet NSSlider *p1SliderY;

@property (weak) IBOutlet NSButton *p2Connect;
@property (weak) IBOutlet NSButton *p2Calibrate;
@property (weak) IBOutlet NSProgressIndicator *p2Progress;
@property (weak) IBOutlet NSLevelIndicator *p2Battery;
@property (weak) IBOutlet NSSlider *p2SliderX;
@property (weak) IBOutlet NSSlider *P2SliderY;

@end
