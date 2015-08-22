//
//  ViewController.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "GameViewController.h"
#import "ArenaScene.h"
#import "LobbyScene.h"
#import "ApplicationModel.h"

@implementation GameViewController
{
    SKView *spriteView;
    ArenaScene *arenaScene;
    LobbyScene *lobbyScene;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    spriteView = (SKView *)self.view;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showArea) name:@"showArena" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLobby) name:@"showLobby" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleFPS) name:@"toggleFPS" object:nil];
}

-(void)viewWillAppear
{
    [self showLobby];
}

-(void)toggleFPS
{
    spriteView.showsDrawCount = !spriteView.showsFPS;
    spriteView.showsNodeCount = !spriteView.showsFPS;
    spriteView.showsFPS = !spriteView.showsFPS;
}

-(void)showArea
{
    [ApplicationModel sharedModel].appState = ArenaState;
    arenaScene = [[ArenaScene alloc] initWithSize:self.view.frame.size];
    arenaScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    [spriteView presentScene:arenaScene transition:transition];
}

-(void)showLobby
{
    [ApplicationModel sharedModel].appState = LobbyState;
    lobbyScene = [[LobbyScene alloc] initWithSize:self.view.frame.size];
    lobbyScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1.0];
    [spriteView presentScene:lobbyScene transition:transition];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

@end
