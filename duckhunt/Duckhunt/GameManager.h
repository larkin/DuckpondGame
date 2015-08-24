//
//  GameManager.h
//  Duckhunt
//
//  Created by Joe Andolina on 8/22/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Duck.h"

@protocol GameDelegate <NSObject>
@optional
- (void) gameTimeout;
- (void) gameRoundStart;
- (void) gameSpawn:(DuckType)duckType;
@end

@interface GameManager : NSObject<AVAudioPlayerDelegate>

@property (nonatomic) NSInteger gameRounds;
@property (nonatomic) NSInteger gameSkill;
@property (nonatomic) NSInteger gameAmmo;

@property (nonatomic) NSInteger currentRound;
@property (nonatomic, weak) id<GameDelegate> gameDelegate;

+ (instancetype)sharedManager;

-(void)startGame;
-(void)stopGame;

-(BOOL)active;
-(BOOL)complete;

-(void)finishRound;
-(void)playFile:(NSString*)fileName withCompletion:(void (^)(void))completion;

@end
