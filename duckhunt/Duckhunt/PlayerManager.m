//
//  PlayerManager.m
//  Duckhunt
//
//  Created by Joe Andolina on 6/4/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "PlayerManager.h"
#import "PlayerController.h"

#import <WiiRemote/WiiRemoteDiscovery.h>
#import "ApplicationModel.h"

@implementation PlayerManager
{
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDiconnect:) name:@"playerDisconnected" object:nil];
    }
    return self;
}

-(void)findPlayers
{
    NSLog(@"Finding Players");
    [discovery start];
}

#pragma mark - Event handling

-(void)handleDiconnect:(NSNotification*)notification
{
    if( [notification.object player] == 1 )
    {
        [ApplicationModel sharedModel].player1 = nil;
    }

    if( [notification.object player] == 2 )
    {
        [ApplicationModel sharedModel].player2 = nil;
    }
    
    [discovery start];
}

#pragma mark - WiiRemoteDiscoveryDelegate implementation

- (void) willStartWiimoteConnections
{
    NSLog(@"Starting Player Search");
}

- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote
{
    ApplicationModel *model = [ApplicationModel sharedModel];
    
    if( !model.player1 )
    {
        model.player1 = [[PlayerController alloc] initPlayer:1 withWii:wiimote];
        NSLog(@"Connected player 1");
    }
    else
    {
        model.player2 = [[PlayerController alloc] initPlayer:2 withWii:wiimote];
         NSLog(@"Connected player 2");
    }
    
    if( model.player1 && model.player2 )
    {
        [discovery stop];
    }
    else
    {
        [discovery start];
    }
}

- (void) WiiRemoteDiscoveryError:(int)code
{
    NSLog(@"Player error - %d", code);
}

@end
