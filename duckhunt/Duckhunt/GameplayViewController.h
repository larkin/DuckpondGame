//
//  GameplayViewController.h
//  Duckhunt
//
//  Created by Joe Andolina on 8/23/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GameplayViewController : NSViewController

@property (nonatomic) NSInteger gameRounds;
@property (nonatomic) NSInteger gameSkill;
@property (nonatomic) NSInteger gameAmmo;

@property (nonatomic) NSInteger currentRound;

-(void)startGame;
-(void)stopGame;

-(BOOL)complete;

@end
