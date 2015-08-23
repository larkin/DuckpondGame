//
//  GameplayViewController.m
//  Duckhunt
//
//  Created by Joe Andolina on 8/23/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "GameplayViewController.h"
#import "ApplicationModel.h"

@implementation GameplayViewController
{
    CGFloat roundTime;
    ApplicationModel *model;
    
    NSTimer *roundTimer;
}

- (id)init
{
    if (self = [super init])
    {
        model = [ApplicationModel sharedModel];
    }
    return self;
}

-(void)viewWillAppear
{
    [super viewWillAppear];
}

-(void)viewWillDisappear
{
    [super viewWillDisappear];
}

-(BOOL)complete
{
    return self.currentRound == self.gameRounds;
}

-(void)startGame
{
    self.currentRound = 0;
    [self startRound];
}

-(void)stopGame
{
    
}

-(void)startRound
{
    self.currentRound++;
    model.player1.ammo = self.gameAmmo;
    model.player2.ammo = self.gameAmmo;
    
    
    // Play Music
    [self spawn];
    [self startTimer];
}

-(void)endRound
{
    [self stopTimer];
    
    if( [self complete] )
    {
        // Show Winner
        [self stopGame];
    }
    else
    {
        [self startRound];
    }
}

-(void)spawn
{
    NSInteger randMax = MIN(self.gameSkill,2);
    NSInteger duckCount = self.gameSkill+1;
    
    if( self.currentRound / self.gameRounds > .3 && self.gameSkill > 2)
    {
        duckCount++;
    }
    
    if( self.currentRound / self.gameRounds > .5)
    {
        randMax = MIN(randMax+1,2);
        duckCount++;
    }
    
    if( self.currentRound / self.gameRounds > .75)
    {
        duckCount++;
    }
    
    for( int i = 1; i < duckCount; i++ )
    {
        NSNumber *duckType = [NSNumber numberWithInteger:(arc4random() % randMax)+1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"spawnDuck" object:duckType];
    }
}

-(void)startTimer
{
    roundTime = 30 / (self.gameSkill+1);
    
    if( self.currentRound / self.gameRounds > .5 )
    {
        roundTime--;
    }
    
    if( self.currentRound / self.gameRounds > .75 )
    {
        roundTime--;
    }
    
    roundTimer = [NSTimer timerWithTimeInterval:roundTime target:self selector:@selector(handleTimer) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:roundTimer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer
{
    [roundTimer invalidate];
    roundTimer = nil;
}

-(void)handleTimer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"roundTimeout" object:nil];
}

@end
