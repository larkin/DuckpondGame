//
//  GameManager.m
//  Duckhunt
//
//  Created by Joe Andolina on 8/22/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "GameManager.h"
#import "ApplicationModel.h"
#import "PropertiesManager.h"
#import "PlayerController.h"

@implementation GameManager
{
    BOOL stopped;
    CGFloat roundTime;
    ApplicationModel *model;
    
    NSTimer *roundTimer;
    
    void (^comp)(void);
    AVAudioPlayer *audioPlayer;
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
    }
    return self;
}

-(BOOL)active
{
    return [roundTimer isValid];
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
        _gameAmmo = 99;
    }
}

-(void)setGameRounds:(NSInteger)gameRounds
{
    _gameRounds = (gameRounds+1) * 5;
}

-(void)startGame
{
    stopped = NO;
    self.currentRound = 0;
    model.player1.kills = 0;
    model.player2.kills = 0;

    [self playFile:@"musicStartGame.mp3" withCompletion:^{
        [self startRound];
    }];
}

// stopGame is called when the admin stops gameplay prior to all the rounds being played.
-(void)stopGame
{
    [self stopTimer];
    stopped = YES;
}

-(void)startRound
{
    if( stopped )
    {
        return;
    }
    
    self.currentRound++;
    model.player1.ammo = self.gameAmmo;
    model.player2.ammo = self.gameAmmo;
    
    if( self.gameDelegate )
    {
        [self.gameDelegate gameRoundStart];
    }
    
    if( self.currentRound > 1 )
    {
        [self playFile:@"musicNextRound.mp3" withCompletion:^{
            [self spawn];
            [self startTimer];
        }];
    }
    else
    {
        [self spawn];
        [self startTimer];
    }
}

-(void)endRound
{
    [self stopTimer];
    
    if( [self complete] )
    {
        [self playFile:@"musicGameOver.mp3" withCompletion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"endGame" object:nil];
        }];
    }
    else
    {
        [self startRound];
    }
}

-(void)spawn
{
    if( stopped )
    {
        return;
    }
    
    NSInteger randMax = MIN(self.gameSkill+1,2);
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
        if( self.gameDelegate )
        {
            [self.gameDelegate gameSpawn:(arc4random() % randMax)+1];
        }
    }
}

-(void)startTimer
{
    roundTime = [PropertiesManager sharedManager].gameTime / (self.gameSkill+1.0);
    
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

-(void)finishRound
{
    [self stopTimer];
    [self performSelector:@selector(endRound) withObject:nil afterDelay:4.0];
}

-(void)handleTimer
{
    [self stopTimer];
    [self performSelector:@selector(endRound) withObject:nil afterDelay:4.0];
    
    if( self.gameDelegate )
    {
        [self.gameDelegate gameTimeout];
    }
}

#pragma mark - Audio handling

-(void)playFile:(NSString*)fileName withCompletion:(void (^)(void))completion
{
    comp = completion;
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileName];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [audioPlayer setDelegate:self];
    [audioPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if( comp )
    {
        comp();
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if( comp )
    {
        comp();
    }
}

@end
