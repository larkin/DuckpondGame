//
//  ViewController.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "GameViewController.h"
#import "ArenaScene.h"
#import "PropertiesManager.h"

@implementation GameViewController
{
    SKView *spriteView;
    ArenaScene *arenaScene;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    spriteView = (SKView *)self.view;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStartGame) name:@"startGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStopGame) name:@"stopGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndGame) name:@"endGame" object:nil];
}

-(void)viewWillAppear
{
    arenaScene = [[ArenaScene alloc] initWithSize:self.view.frame.size];
    arenaScene.scaleMode = SKSceneScaleModeAspectFill;
    [spriteView presentScene:arenaScene];
    
    //[self.lobbyImage setFrame:NSMakeRect(0, 0, [PropertiesManager sharedManager].screenSize, [PropertiesManager sharedManager].screenSize)];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

-(void)handleStartGame
{
    CGRect newFrame = self.lobbyImage.frame;
    newFrame.origin.y = -newFrame.size.height;
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:2.0];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[self.lobbyImage animator] setFrame:newFrame];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [arenaScene startGame];
    }];
    [NSAnimationContext endGrouping];
}

-(void)handleEndGame
{
    [self showLobby];
}

-(void)handleStopGame
{
    [self showLobby];
    [arenaScene stopGame];
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
