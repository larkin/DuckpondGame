//
//  PlayerManager.m
//  Duckhunt
//
//  Created by Joe Andolina on 6/4/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "PlayerManager.h"
//#import "PlayerController.h"

#import <WiiRemote/WiiRemoteDiscovery.h>
#import "ApplicationModel.h"

@implementation PlayerManager
{
    NSTimer *timeout;
    PlayerController *currentPlayer;
    WiiRemoteDiscovery *discovery;
}

+ (id)sharedManager {
    static PlayerManager *sharedManager = nil;
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
        discovery = [[WiiRemoteDiscovery alloc] init];
        [discovery setDelegate:self];
    }
    return self;
}

-(void)connectPlayer:(PlayerController*)player
{
    NSLog(@"Finding Player - %ld", (long)player.player);
    currentPlayer = player;
    
    timeout = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(handleTimeout:) userInfo:nil repeats:NO];
    [discovery start];
}
               
-(void)handleTimeout:(NSTimer*)timer
{
    [discovery stop];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playerTimout" object:currentPlayer];
}

#pragma mark - WiiRemoteDiscoveryDelegate implementation

- (void) willStartWiimoteConnections
{
    NSLog(@"Starting Search");
}

- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote
{
    [timeout invalidate];
    timeout = nil;
    [discovery stop];
    currentPlayer.wiimote = wiimote;
}

- (void) WiiRemoteDiscoveryError:(int)code
{
    NSLog(@"Connect Player Error - %d", code);
}

@end
