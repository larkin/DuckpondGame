//
//  PlayerManager.h
//  Duckhunt
//
//  Created by Joe Andolina on 6/4/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WiiRemote/WiiRemote.h>

@interface PlayerManager : NSObject

+ (instancetype)sharedManager;

-(void)findPlayers;

#pragma mark - WiiRemoteDiscoveryDelegate implementation

- (void) willStartWiimoteConnections;
- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote;
- (void) WiiRemoteDiscoveryError:(int)code;

@end
