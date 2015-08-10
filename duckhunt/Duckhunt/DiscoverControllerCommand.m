//
//  DiscoverControllerCommand.m
//  Duckhunt
//
//  Created by Joe Andolina on 6/3/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//


#import "DiscoverControllerCommand.h"
#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>

#import "ApplicationModel.h"
#import "PlayerController.h"

@implementation DiscoverControllerCommand
{
    WiiRemoteDiscovery *discovery;
}

-(void)execute
{
    discovery = [[WiiRemoteDiscovery alloc] init];
    [discovery setDelegate:self];
    [discovery start];
}

#pragma mark - WiiRemoteDiscovery delegates

- (void) WiiRemoteDiscoveryError:(int)code
{
    //[discoverySpinner stopAnimation:self];
    //[_textField setString:[NSString stringWithFormat:@"%@\n===== WiiRemoteDiscovery error.  If clicking Find Wiimote gives this error, try System Preferences > Bluetooth > Devices, delete Nintendo. (%d) =====", [_textField string], code]];
}

- (void) willStartWiimoteConnections
{
    //[textView setString:[NSString stringWithFormat:@"%@\n===== WiiRemote discovered.  Opening connection. =====", [textView string]]];
}

- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
    
    //	[discovery stop];
    
    // the wiimote must be retained because the discovery provides us with an autoreleased object
    //WiiRemote *wii = [wiimote retain];
    ApplicationModel *model = [ApplicationModel sharedModel];
    
    if( !model.player1 )
    {
    //    model.player1 = [[PlayerController alloc] initPlayer:1 withWii:wiimote];
    }
    else
    {
    //    model.player2 = [[PlayerController alloc] initPlayer:2 withWii:wiimote];
    }
    
    if( model.player1 && model.player2 )
    {
        [discovery stop];
    }
    
    //[wiimote setDelegate:self];
    
    //[textView setString:[NSString stringWithFormat:@"%@\n===== Connected to WiiRemote =====", [textView string]]];
    //[discoverySpinner stopAnimation:self];
    
    //[wiimote setLEDEnabled1:YES enabled2:NO enabled3:NO enabled4:NO];
    //[wiimoteQCView setValue:[NSNumber numberWithBool:[led1 state] ] forInputKey:[NSString stringWithString:@"LED_1"]];
    
    //[wiimote setMotionSensorEnabled:YES];
    //	[wiimote setIRSensorEnabled:YES];
    
    //[graphView startTimer];
    //[graphView2 startTimer];
    
    //NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //[mappingController setSelectionIndex:[[defaults objectForKey:@"selection"] intValue]];
}


@end
