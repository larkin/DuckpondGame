//
//  AdminViewController.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "AdminViewController.h"
#import "PlayerManager.h"

#import "AppDelegate.h"
#import "ApplicationModel.h"


@implementation AdminViewController
{
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    CGPoint p4;
    
    CGPoint lastClick;
    NSClickGestureRecognizer *shot;
    
    NSMutableArray *points;
    
    ApplicationModel *model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    model = [ApplicationModel sharedModel];
    model.player1.delegate = self;
    model.player2.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTimeout:) name:@"playerTimout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDefaults:) name:@"defaultsLoaded" object:nil];
}

-(void)viewDidAppear
{
    [super viewDidAppear];

    [self handleDefaults:nil];
}

- (IBAction)handleAdd:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"spawnDuck" object:nil];
}

#pragma mark - Gameplay Options
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    if( [tabViewItem.identifier isEqualToString:@"1"] )
    {
        [model.props saveDefaults];
    }
}

- (IBAction)handleFPS:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleFPS" object:nil];
}

- (IBAction)handleGameScale:(id)sender
{
    [model.props setGameScale:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleGameSpeed:(id)sender
{
    CGFloat value = 1.1 - [(NSSlider*)sender floatValue];
    NSLog(@"Value %f", value);
    [model.props setGameSpeed:value];
}

- (IBAction)handleGameGlitch:(id)sender
{
    [model.props setGameGlitch:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleStop:(id)sender
{
    self.goButton.enabled = YES;
    self.stopButton.enabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopGame" object:nil];
}

- (IBAction)handleGo:(id)sender
{
    self.goButton.enabled = NO;
    self.stopButton.enabled = YES;
    
    NSDictionary *gameData = @{@"difficulty":[NSNumber numberWithInteger:self.gameSkill.selectedSegment],
                               @"roundCount":[NSNumber numberWithInteger:self.gameRounds.selectedSegment],
                               @"roundAmmo":[NSNumber numberWithInteger:self.gameAmmo.selectedSegment]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startGame" object:gameData];
}

#pragma mark - Player Options

- (IBAction)resetOptions:(id)sender
{
    [model.props resetDefaults];
}

- (IBAction)resetP1Offset:(id)sender
{
    self.p1SliderX.floatValue = 0;
    self.p1SliderY.floatValue = 0;
    self.p1Sensitivity.selectedSegment = 2;
    
    model.props.playerSensitivity1 = 2;
    model.props.playerOffset1 = NSMakePoint(0,0);
}

- (IBAction)resetP2Offset:(id)sender
{
    self.p2SliderX.floatValue = 0;
    self.p2SliderY.floatValue = 0;
    self.p2Sensitivity.selectedSegment = 2;
    
    model.props.playerSensitivity2 = 2;
    model.props.playerOffset2 = NSMakePoint(0,0);
}

- (IBAction)handleP1Sensitivity:(id)sender
{
    model.props.playerSensitivity1 = [(NSSegmentedControl*)sender selectedSegment];
}

- (IBAction)handleP2Sensitivity:(id)sender
{
    model.props.playerSensitivity2 = [(NSSegmentedControl*)sender selectedSegment];
}


- (IBAction)handleP1Calibrate:(id)sender
{
    self.p1SliderX.enabled = !self.p1SliderX.enabled;
    self.p1SliderY.enabled = !self.p1SliderY.enabled;
    
    if( self.p1SliderX.enabled )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCalibrationTarget" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideCalibrationTarget" object:nil];
    }
}

- (IBAction)handleP1OffestX:(id)sender
{
    model.props.playerOffset1 = NSMakePoint([(NSSlider*)sender floatValue],model.props.playerOffset1.y);
}


- (IBAction)handleP1OffestY:(id)sender
{
    model.props.playerOffset1 = NSMakePoint(model.props.playerOffset1.x, [(NSSlider*)sender floatValue]);
}

- (IBAction)handleP2Calibrate:(id)sender
{
    self.p2SliderX.enabled = !self.p2SliderX.enabled;
    self.p2SliderY.enabled = !self.p2SliderY.enabled;
    
    if( self.p2SliderX.enabled )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCalibrationTarget" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideCalibrationTarget" object:nil];
    }
}

- (IBAction)handleP2OffestX:(id)sender
{
    model.props.playerOffset2 = NSMakePoint([(NSSlider*)sender floatValue],model.props.playerOffset2.y);
}


- (IBAction)handleP2OffestY:(id)sender
{
    model.props.playerOffset2 = NSMakePoint(model.props.playerOffset2.x, [(NSSlider*)sender floatValue]);
}


- (IBAction)handleP1Search:(id)sender
{
    self.p1Connect.enabled = NO;
    self.p2Connect.enabled = NO;
    
    [self.p1Progress startAnimation:self];
    [[PlayerManager sharedManager] connectPlayer:model.player1];
}

- (IBAction)handleP2Search:(id)sender
{
    self.p1Connect.enabled = NO;
    self.p2Connect.enabled = NO;
    
    [self.p2Progress startAnimation:self];
    [[PlayerManager sharedManager] connectPlayer:model.player2];
}

#pragma mark - Duck Options

- (IBAction)handleDuck1Speed:(id)sender
{
    [model.props setDuck1Speed:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck1Min:(id)sender
{
    [model.props setDuck1Min:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck1Max:(id)sender
{
    [model.props setDuck1Max:[(NSSlider*)sender floatValue]];
}


- (IBAction)handleDuck2Speed:(id)sender
{
    [model.props setDuck2Speed:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck2Min:(id)sender
{
    [model.props setDuck2Min:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck2Max:(id)sender
{
    [model.props setDuck2Max:[(NSSlider*)sender floatValue]];
}


- (IBAction)handleDuck3Speed:(id)sender
{
    [model.props setDuck3Speed:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck3Min:(id)sender
{
    [model.props setDuck3Min:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck3Max:(id)sender
{
    [model.props setDuck3Max:[(NSSlider*)sender floatValue]];
}

#pragma mark - Update ui to reflect defaults

-(void)handleDefaults:(NSNotification*)notification
{
    // Player 1
    [self.p1Sensitivity setSelected:YES forSegment:model.props.playerSensitivity1];
    [self.p1SliderX setFloatValue:model.props.playerOffset1.x];
    [self.p1SliderY setFloatValue:model.props.playerOffset1.y];

    // Player 2
    [self.p2Sensitivity setSelected:YES forSegment:model.props.playerSensitivity2];
    [self.p2SliderX setFloatValue:model.props.playerOffset2.x];
    [self.p2SliderY setFloatValue:model.props.playerOffset2.y];

    // Gmeplay
    [self.gameScale setFloatValue:model.props.gameScale];
    [self.gameSpeed setFloatValue:model.props.gameSpeed];
    [self.gameGlitch setFloatValue:model.props.gameGlitch];
    
    // Ducks
    [self.duck1Speed setFloatValue:model.props.duck1Speed];
    [self.duck1Min setFloatValue:model.props.duck1Min];
    [self.duck1Max setFloatValue:model.props.duck1Max];
    
    [self.duck2Speed setFloatValue:model.props.duck2Speed];
    [self.duck2Min setFloatValue:model.props.duck2Min];
    [self.duck2Max setFloatValue:model.props.duck2Max];
    
    [self.duck3Speed setFloatValue:model.props.duck3Speed];
    [self.duck3Min setFloatValue:model.props.duck3Min];
    [self.duck3Max setFloatValue:model.props.duck3Max];
}

#pragma mark - wiimote connection

-(void)playerConnect:(PlayerController*)player
{
    if( player == model.player1 )
    {
        self.p1Connect.title = @"Connected";
        self.p2Connect.enabled = !model.player2.connected;;
        
        self.p1Reset.enabled = YES;
        self.p1Calibrate.enabled = YES;
        self.p1Sensitivity.enabled = YES;
        [self.p1Progress stopAnimation:self];
    }
    else
    {
        self.p1Connect.enabled = !model.player1.connected;
        self.p2Connect.title = @"Connected";
        
        self.p2Reset.enabled = YES;
        self.p2Calibrate.enabled = YES;
        self.p2Sensitivity.enabled = YES;
        [self.p2Progress stopAnimation:self];
    }
}

-(void)playerDisconnect:(PlayerController*)player
{
    if( player == model.player1 )
    {
        self.p1Connect.title = @"Connect";
        self.p1Connect.enabled = YES;
        self.p1Calibrate.enabled = NO;
        self.p1SliderX.enabled = NO;
        self.p1SliderY.enabled = NO;
        self.p1Reset.enabled = NO;
        self.p1Sensitivity.enabled = NO;
        [self.p1Battery setDoubleValue:0.0];
    }
    else
    {
        self.p2Connect.title = @"Connect";
        self.p2Connect.enabled = YES;
        self.p2Calibrate.enabled = NO;
        self.p2SliderX.enabled = NO;
        self.p2SliderY.enabled = NO;
        self.p2Reset.enabled = NO;
        self.p2Sensitivity.enabled = NO;
        [self.p2Battery setDoubleValue:0.0];
    }
}

-(void)handleTimeout:(NSNotification*)notification
{
    self.p1Connect.enabled = !model.player1.connected;
    self.p2Connect.enabled = !model.player2.connected;
    
    [self.p1Progress stopAnimation:self];
    [self.p2Progress stopAnimation:self];
}

-(void)playerBattery:(PlayerController*)player
{
    if( player == model.player1 )
    {
        [self.p1Battery setDoubleValue:model.player1.level * 10.0];
    }
    
    else
    {
        [self.p2Battery setDoubleValue:model.player2.level * 10.0];
    }
}


@end
