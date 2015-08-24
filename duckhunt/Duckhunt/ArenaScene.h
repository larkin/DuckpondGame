//
//  TestScene.h
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameManager.h"
#import "PlayerController.h"

@interface ArenaScene : SKScene<GameDelegate, PlayerGameDelegate>

@property BOOL contentCreated;

-(void)startGame:(NSDictionary*)gameData;
-(void)stopGame;

@end
