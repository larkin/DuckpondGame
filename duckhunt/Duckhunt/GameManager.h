//
//  GameManager.h
//  Duckhunt
//
//  Created by Joe Andolina on 8/22/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

@property (nonatomic) NSInteger gameRounds;
@property (nonatomic) NSInteger gameSkill;
@property (nonatomic) NSInteger gameAmmo;

@property (nonatomic) NSInteger currentRound;

+ (instancetype)sharedManager;

-(void)startGame;
-(void)stopGame;

-(BOOL)complete;

@end
