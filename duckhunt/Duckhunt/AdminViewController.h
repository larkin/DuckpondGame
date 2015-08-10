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
@property (weak) IBOutlet NSButton *killButton;

@property (weak) IBOutlet NSSegmentedControl *difficulty;
@property (weak) IBOutlet NSSlider *slider1;
@property (weak) IBOutlet NSSlider *slider2;

@property (weak) IBOutlet NSButton *calibrateButton;
@property (weak) IBOutlet NSButton *goButton;


@property (weak) IBOutlet NSButton *p1Connect;
@property (weak) IBOutlet NSProgressIndicator *p1Progress;
@property (weak) IBOutlet NSLevelIndicator *p1Battery;

@property (weak) IBOutlet NSButton *p2Connect;
@property (weak) IBOutlet NSProgressIndicator *p2Progress;
@property (weak) IBOutlet NSLevelIndicator *p2Battery;

@end
