//
//  GameManager.m
//  Duckhunt
//
//  Created by Joe Andolina on 8/22/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "GameManager.h"
#import "ApplicationModel.h"
#import "PlayerController.h"

@implementation GameManager
{
    CGFloat roundTime;
    ApplicationModel *model;
    
    NSTimer *roundTimer;
}

+ (id)sharedManager {
    static GameManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    if (self = [super init])
    {
        model = [ApplicationModel sharedModel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShot:) name:@"handleShot" object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handleShot" object:nil];
}

-(BOOL)complete
{
    return self.currentRound == self.gameRounds;
}

-(void)setGameAmmo:(NSInteger)gameAmmo
{
    _gameAmmo = gameAmmo+2;
    if( gameAmmo == 4 )
    {
        _gameAmmo = 200;
    }
}

-(void)setGameRounds:(NSInteger)gameRounds
{
    _gameRounds = (gameRounds+1) * 5;
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
    NSInteger duckCount = self.gameSkill+2;
    
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
    roundTime = 20 / (self.gameSkill+1);
    
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
    if( roundTimer )
    {
        [roundTimer invalidate];
        roundTimer = nil;
    }
}

-(void)handleShot:(NSNotification*)notification
{
    if( model.player1.ammo == 0 && model.player2.ammo == 0)
    {
        [self handleTimer];
    }
}

-(void)handleTimer
{
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"roundTimeout" object:nil];
    [self performSelector:@selector(endRound) withObject:nil afterDelay:4.0];
}

@end
