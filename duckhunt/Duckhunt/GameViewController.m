//
//  ViewController.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "GameViewController.h"
#import "ArenaScene.h"
#import "ApplicationModel.h"

@implementation GameViewController
{
    SKView *spriteView;
    ArenaScene *arenaScene;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    spriteView = (SKView *)self.view;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStartGame:) name:@"startGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStopGame) name:@"stopGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleFPS) name:@"toggleFPS" object:nil];
}

-(void)viewWillAppear
{
    arenaScene = [[ArenaScene alloc] initWithSize:self.view.frame.size];
    arenaScene.scaleMode = SKSceneScaleModeAspectFill;
    [spriteView presentScene:arenaScene];
    //SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    //[spriteView presentScene:arenaScene transition:transition];
    
    [self.lobbyImage setFrame:NSMakeRect(0, 0, [ApplicationModel sharedModel].screenSize, [ApplicationModel sharedModel].screenSize)];
    //self.lobbyImage.alphaValue = 0.0;
}




- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

-(void)handleStartGame:(NSNotification*)notification
{
    [self showArena];
    [arenaScene startGame:notification.object];
}

-(void)handleStopGame
{
    [self showLobby];
    [arenaScene stopGame];
}

-(void)toggleFPS
{
    spriteView.showsDrawCount = !spriteView.showsFPS;
    spriteView.showsNodeCount = !spriteView.showsFPS;
    spriteView.showsFPS = !spriteView.showsFPS;
}

-(void)showArena
{
    CGRect newFrame = self.lobbyImage.frame;
    newFrame.origin.y = -newFrame.size.height;
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:2.0];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[self.lobbyImage animator] setFrame:newFrame];
    [NSAnimationContext endGrouping];
}

-(void)showLobby
{
    CGRect newFrame = self.lobbyImage.frame;
    newFrame.origin.y = 0;
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1.0];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[self.lobbyImage animator] setFrame:newFrame];
    [NSAnimationContext endGrouping];
}

@end
