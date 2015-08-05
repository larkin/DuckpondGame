//
//  AppDelegate.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "AppDelegate.h"

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
    for(targetScreen in [NSScreen screens])
    {
        if( targetScreen != [NSScreen mainScreen] )
        {
            break;
        }
    }
    
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    self.gameWindow = [storyBoard instantiateControllerWithIdentifier:@"GameWindow"];
    [self.gameWindow.window setFrame:CGRectMake(100,100,1280,720) display:YES];
    [self.gameWindow showWindow:self];
   
//#ifdef RELEASE
    //[self.gameWindow.window setFrame:targetScreen.frame display:YES];
    //[self.gameWindow.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    //[self.gameWindow.window toggleFullScreen:self];
//#endif
}

@end
