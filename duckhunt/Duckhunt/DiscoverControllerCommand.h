//
//  DiscoverControllerCommand.h
//  Duckhunt
//
//  Created by Joe Andolina on 6/3/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WiiRemote/WiiRemote.h>

@interface DiscoverControllerCommand : NSObject

-(void)execute;

#pragma mark - WiiRemoteDiscoveryDelegate implementation

- (void) willStartWiimoteConnections;
- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote;
- (void) WiiRemoteDiscoveryError:(int)code;

@end
