//
//  AppDelegate.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "AppDelegate.h"
#import "PropertiesManager.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self openGameWindow];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)openGameWindow
{
    NSScreen *targetScreen;
    PropertiesManager *props = [PropertiesManager sharedManager];
    
    for(targetScreen in [NSScreen screens])
    {
        if( targetScreen != [NSScreen mainScreen] )
        {
            break;
        }
    }
    
    targetScreen = [[NSScreen screens] objectAtIndex:[NSScreen screens].count-1];
    props.screenSize = targetScreen.frame.size.height;
    props.screenOffset = targetScreen.frame.origin.x + (targetScreen.frame.size.width - props.screenSize)/2;
    
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    self.gameWindow = [storyBoard instantiateControllerWithIdentifier:@"GameWindow"];
    [self.gameWindow.window setFrame:CGRectMake(props.screenOffset, 0, props.screenSize, props.screenSize) display:YES];
    [self.gameWindow showWindow:self];
   
    [self.gameWindow.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.gameWindow.window toggleFullScreen:self];
}

@end
