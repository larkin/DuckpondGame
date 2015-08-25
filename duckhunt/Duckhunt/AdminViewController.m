//
//  AdminViewController.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "AdminViewController.h"
#import "ConnectionManager.h"

#import "ApplicationModel.h"
#import "PropertiesManager.h"

@implementation AdminViewController
{
    BOOL gameOn;
    
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    CGPoint p4;
    
    CGPoint lastClick;
    NSClickGestureRecognizer *shot;
    
    NSMutableArray *points;
    
    ApplicationModel *model;
    PropertiesManager *props;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    model = [ApplicationModel sharedModel];
    props = [PropertiesManager sharedManager];
    model.player1.adminDelegate = self;
    model.player2.adminDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndGame) name:@"endGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDefaults) name:@"defaultsLoaded" object:nil];
}

-(void)viewDidAppear
{
    [super viewDidAppear];
    [self handleDefaults];
}

#pragma mark - Gameplay Options

- (IBAction)handleGameScale:(id)sender
{
    [props setGameScale:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleGameSpeed:(id)sender
{
    CGFloat value = 1.1 - [(NSSlider*)sender floatValue];
    [props setGameSpeed:value];
}

- (IBAction)handleGameGlitch:(id)sender
{
    [props setGameGlitch:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleGameTime:(id)sender
{
    [props setGameTime:[(NSSlider*)sender floatValue]];
}

-(void)handleEndGame
{
    gameOn = NO;
    [self.goButton setTitle:@"GO"];
}

- (IBAction)handleGo:(id)sender
{
    if( gameOn )
    {
        gameOn = NO;
        [self.goButton setTitle:@"START"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopGame" object:nil];
    }
    else
    {
        gameOn = YES;
        [self.goButton setTitle:@"STOP"];
        
        NSDictionary *gameData = @{@"difficulty":[NSNumber numberWithInteger:self.gameSkill.selectedSegment],
                                   @"roundCount":[NSNumber numberWithInteger:self.gameRounds.selectedSegment],
                                   @"roundAmmo":[NSNumber numberWithInteger:self.gameAmmo.selectedSegment]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startGame" object:gameData];
    }
}

#pragma mark - Player Options

- (IBAction)resetOptions:(id)sender
{
    [props resetDefaults];
}

- (IBAction)saveOptions:(id)sender
{
    [props saveDefaults];
}

- (IBAction)resetP1Offset:(id)sender
{
    self.p1SliderX.floatValue = 0;
    self.p1SliderY.floatValue = 0;
    self.p1Sensitivity.selectedSegment = 2;
    
    props.playerSensitivity1 = 2;
    props.playerOffset1 = NSMakePoint(0,0);
}

- (IBAction)resetP2Offset:(id)sender
{
    self.p2SliderX.floatValue = 0;
    self.p2SliderY.floatValue = 0;
    self.p2Sensitivity.selectedSegment = 2;
    
    props.playerSensitivity2 = 2;
    props.playerOffset2 = NSMakePoint(0,0);
}

- (IBAction)handleP1Sensitivity:(id)sender
{
    props.playerSensitivity1 = [(NSSegmentedControl*)sender selectedSegment];
}

- (IBAction)handleP2Sensitivity:(id)sender
{
    props.playerSensitivity2 = [(NSSegmentedControl*)sender selectedSegment];
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
    props.playerOffset1 = NSMakePoint([(NSSlider*)sender floatValue],props.playerOffset1.y);
}


- (IBAction)handleP1OffestY:(id)sender
{
    props.playerOffset1 = NSMakePoint(props.playerOffset1.x, [(NSSlider*)sender floatValue]);
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
    props.playerOffset2 = NSMakePoint([(NSSlider*)sender floatValue],props.playerOffset2.y);
}


- (IBAction)handleP2OffestY:(id)sender
{
    props.playerOffset2 = NSMakePoint(props.playerOffset2.x, [(NSSlider*)sender floatValue]);
}


- (IBAction)handleP1Search:(id)sender
{
    self.p1Connect.enabled = NO;
    self.p2Connect.enabled = NO;
    
    [self.p1Progress startAnimation:self];
    [[ConnectionManager sharedManager] connectPlayer:model.player1];
}

- (IBAction)handleP2Search:(id)sender
{
    self.p1Connect.enabled = NO;
    self.p2Connect.enabled = NO;
    
    [self.p2Progress startAnimation:self];
    [[ConnectionManager sharedManager] connectPlayer:model.player2];
}

#pragma mark - Duck Options

- (IBAction)handleDuck1Speed:(id)sender
{
    [props setDuck1Speed:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck1Min:(id)sender
{
    [props setDuck1Min:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck1Max:(id)sender
{
    [props setDuck1Max:[(NSSlider*)sender floatValue]];
}


- (IBAction)handleDuck2Speed:(id)sender
{
    [props setDuck2Speed:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck2Min:(id)sender
{
    [props setDuck2Min:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck2Max:(id)sender
{
    [props setDuck2Max:[(NSSlider*)sender floatValue]];
}


- (IBAction)handleDuck3Speed:(id)sender
{
    [props setDuck3Speed:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck3Min:(id)sender
{
    [props setDuck3Min:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck3Max:(id)sender
{
    [props setDuck3Max:[(NSSlider*)sender floatValue]];
}

#pragma mark - Update ui to reflect defaults

-(void)handleDefaults
{
    // Player 1
    [self.p1Sensitivity setSelected:YES forSegment:props.playerSensitivity1];
    [self.p1SliderX setFloatValue:props.playerOffset1.x];
    [self.p1SliderY setFloatValue:props.playerOffset1.y];

    // Player 2
    [self.p2Sensitivity setSelected:YES forSegment:props.playerSensitivity2];
    [self.p2SliderX setFloatValue:props.playerOffset2.x];
    [self.p2SliderY setFloatValue:props.playerOffset2.y];

    // Gmeplay
    [self.gameScale setFloatValue:props.gameScale];
    [self.gameSpeed setFloatValue:props.gameSpeed];
    [self.gameGlitch setFloatValue:props.gameGlitch];
    [self.gameTime setFloatValue:props.gameTime];
    
    // Ducks
    [self.duck1Speed setFloatValue:props.duck1Speed];
    [self.duck1Min setFloatValue:props.duck1Min];
    [self.duck1Max setFloatValue:props.duck1Max];
    
    [self.duck2Speed setFloatValue:props.duck2Speed];
    [self.duck2Min setFloatValue:props.duck2Min];
    [self.duck2Max setFloatValue:props.duck2Max];
    
    [self.duck3Speed setFloatValue:props.duck3Speed];
    [self.duck3Min setFloatValue:props.duck3Min];
    [self.duck3Max setFloatValue:props.duck3Max];
}

#pragma mark - wiimote connection

-(void)playerConnect:(PlayerController*)player
{
    if( player.index == 1 )
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
    if( player.index == 1 )
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

-(void)playerTimeout:(PlayerController *)player
{
    self.p1Connect.enabled = !model.player1.connected;
    self.p2Connect.enabled = !model.player2.connected;
    
    [self.p1Progress stopAnimation:self];
    [self.p2Progress stopAnimation:self];
}

-(void)playerBattery:(PlayerController*)player
{
    if( player.index == 1 )
    {
        [self.p1Battery setDoubleValue:model.player1.level * 10.0];
    }
    else
    {
        [self.p2Battery setDoubleValue:model.player2.level * 10.0];
    }
}

@end
