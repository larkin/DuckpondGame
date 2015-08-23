//
//  ApplicationModel.h
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import "PlayerController.h"
#import "Properties.h"

@interface ApplicationModel : NSObject

typedef NS_ENUM(NSInteger, AppState) {
    LobbyState,
    ArenaState,
    CalibrationState
};

@property (nonatomic) NSInteger screenOffset;
@property (nonatomic) NSInteger screenSize;

@property (nonatomic) AppState appState;
@property (nonatomic) CGSize captureSize;
@property (nonatomic) NSArray *duckTextures;
@property (nonatomic) NSArray *calibrationPoints;

@property (nonatomic) Properties *props;

@property (nonatomic) PlayerController* player1;
@property (nonatomic) PlayerController* player2;


@property (nonatomic) NSInteger currentRound;

+ (instancetype)sharedModel;

-(SKTexture*)texture:(NSInteger)duckIndex action:(NSString*)actionName;
-(NSArray*)textures:(NSInteger)duckIndex action:(NSString*)actionName;

-(PlayerController*)playerWith:(NSInteger)playerNumber;

@end
