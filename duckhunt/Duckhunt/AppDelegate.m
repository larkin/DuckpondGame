//
//  AppDelegate.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "AppDelegate.h"
#import "ApplicationModel.h"

/*
 Calibrate
 Crosshair 
 Rounds optional number and length
 Shots optional per round
 Birds optional per round
 Hits and misses in color
  */

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
    ApplicationModel *model = [ApplicationModel sharedModel];
    for(targetScreen in [NSScreen screens])
    {
        //NSLog(@"%f : %f", targetScreen.frame.size.width, targetScreen.frame.size.height);
        if( targetScreen != [NSScreen mainScreen] )
        {
        //    break;
        }
    }
    
    targetScreen = [[NSScreen screens] objectAtIndex:[NSScreen screens].count-1];
    model.screenSize = targetScreen.frame.size.height;
    model.screenOffset = targetScreen.frame.origin.x + (targetScreen.frame.size.width - model.screenSize)/2;
    
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    self.gameWindow = [storyBoard instantiateControllerWithIdentifier:@"GameWindow"];
    [self.gameWindow.window setFrame:CGRectMake(model.screenOffset, 0, model.screenSize, model.screenSize) display:YES];
    [self.gameWindow showWindow:self];
   
//#ifdef RELEASE
    [self.gameWindow.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.gameWindow.window toggleFullScreen:self];
//#endif
}

@end
