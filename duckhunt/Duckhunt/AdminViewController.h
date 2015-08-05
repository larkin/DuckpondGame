//
//  AdminViewController.h
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GPUImage/GPUImage.h>


@interface AdminViewController : NSViewController


@property (weak) IBOutlet NSButton *addButton;
@property (weak) IBOutlet NSButton *killButton;

@property (weak) IBOutlet NSSegmentedControl *difficulty;
@property (weak) IBOutlet NSSlider *slider1;
@property (weak) IBOutlet NSSlider *slider2;

@property (weak) IBOutlet NSButton *calibrateButton;
@property (weak) IBOutlet NSButton *goButton;

@property (strong)  GPUImageView *cameraView;

@end
