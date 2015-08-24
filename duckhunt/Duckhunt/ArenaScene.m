//
//  TestScene.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "ArenaScene.h"
#import "ApplicationModel.h"
#import "Background.h"
#import "Duck.h"

#define kBorderPad 20
#define kGroundPad 125

@implementation ArenaScene
{
    BOOL lastMiss;
    
    Background *background;
    
    Duck *duckNode;
    DuckLat newLat;
    DuckLng newLng;
    
    NSInteger duckCount;
    GameManager *gameManager;
    
    SKSpriteNode *calib;
    SKSpriteNode *cross1;
    SKSpriteNode *cross2;
    
    SKSpriteNode *shell1;
    SKSpriteNode *shell2;
    
    SKLabelNode *shellLabel1;
    SKLabelNode *shellLabel2;
    
    SKSpriteNode *egg1;
    SKSpriteNode *egg2;
    
    SKLabelNode *eggLabel1;
    SKLabelNode *eggLabel2;
    
    AVAudioPlayer *audioPlayer;
}

+(float)numberBetween:(float)lowerBound and:(float)upperBound
{
    float diff = upperBound - lowerBound;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + lowerBound;
}


- (void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        self.contentCreated = YES;
        [self createContents];
    }
    
    [ApplicationModel sharedModel].player1.gameDelegate = self;
    [ApplicationModel sharedModel].player2.gameDelegate = self;
    
    gameManager = [[GameManager alloc] init];
    gameManager.gameDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHideCalibration:) name:@"hideCalibrationTarget" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowCalibration:) name:@"showCalibrationTarget" object:nil];
}

-(void)willMoveFromView:(SKView *)view
{
    [ApplicationModel sharedModel].player1.gameDelegate = nil;
    [ApplicationModel sharedModel].player2.gameDelegate = nil;

    gameManager.gameDelegate = nil;
    gameManager = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideCalibrationTarget" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showCalibrationTarget" object:nil];
}

-(void)createContents
{
    ApplicationModel *model = [ApplicationModel sharedModel];
    self.backgroundColor = [SKColor colorWithCalibratedRed:94.0/255.0 green:204.0/255.0 blue:236.0/255.0 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    cross1 = [self makeCrosshair:1];
    [self addChild:cross1];
    
    cross2 = [self makeCrosshair:2];
    [self addChild:cross2];
    
    egg1 = [self makeHudSprite:@"egg1"];
    egg1.position = NSMakePoint((model.screenSize/2) - egg1.size.width, model.screenSize - egg1.size.height + 40);
    [egg1 setScale:0.5];
    [self addChild:egg1];
    
    egg2 = [self makeHudSprite:@"egg2"];
    egg2.position = NSMakePoint((model.screenSize/2) + 15, model.screenSize - egg2.size.height + 40);
    [egg2 setScale:0.5];
    [self addChild:egg2];

    shell1 = [self makeHudSprite:@"shell1"];
    shell1.position = NSMakePoint(20, model.screenSize - 80);
    [shell1 setScale:0.8];
    [self addChild:shell1];
    
    shell2 = [self makeHudSprite:@"shell2"];
    shell2.position = NSMakePoint(model.screenSize - shell2.size.width, model.screenSize - 80);
    [shell2 setScale:0.8];
    [self addChild:shell2];

    eggLabel1 = [SKLabelNode labelNodeWithFontNamed:@"Arial Black"];
    eggLabel1.position = NSMakePoint(egg1.position.x + 25, egg1.position.y + 15);
    eggLabel1.zPosition = 12;
    [self addChild:eggLabel1];
    
    eggLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Arial Black"];
    eggLabel2.position = NSMakePoint(egg2.position.x + 25, egg2.position.y + 15);
    eggLabel2.zPosition = 12;
    [self addChild:eggLabel2];
    
    shellLabel1 = [SKLabelNode labelNodeWithFontNamed:@"Arial Black"];
    shellLabel1.position = NSMakePoint(shell1.position.x + 45, shell1.position.y + 8);
    shellLabel1.zPosition = 12;
    [self addChild:shellLabel1];

    shellLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Arial Black"];
    shellLabel2.position = NSMakePoint(shell2.position.x + 40, shell2.position.y + 8);
    shellLabel2.zPosition = 12;
    [self addChild:shellLabel2];
    
    background = [[Background alloc] init];
    [background setSize:self.size];
    background.position = CGPointMake(0, 0);
    background.zPosition = 0;
    [self addChild:background];
}

-(void)startGame:(NSDictionary *)gameData
{
    [self setPaused:NO];
    gameManager.gameSkill  = [[gameData valueForKey:@"difficulty"] integerValue];
    gameManager.gameRounds = [[gameData valueForKey:@"roundCount"] integerValue];
    gameManager.gameAmmo   = [[gameData valueForKey:@"roundAmmo"] integerValue];
    
    [eggLabel1 setText:@"0"];
    [eggLabel2 setText:@"0"];
    
    [shellLabel1 setText:@""];
    [shellLabel2 setText:@""];
    
    [gameManager startGame];
}

-(void)stopGame
{
    [self setPaused:YES];
    
    [self enumerateChildNodesWithName:@"duck" usingBlock:^(SKNode *node, BOOL *stop) {
        duckNode = (Duck*)node;
        [duckNode removeAllActions];
        [duckNode removeFromParent];
    }];
}

#pragma mark - Event Handlers


-(void)handleHideCalibration:(NSNotification*)notification
{
    [calib removeFromParent];
    calib = nil;
}

-(void)handleShowCalibration:(NSNotification*)notification
{
    if( calib != nil && calib.parent )
    {
        return;
    }
    
    calib = [SKSpriteNode spriteNodeWithImageNamed:@"target"];
    [calib setAnchorPoint:CGPointMake(0.5, 0.5)];
    [calib setSize:CGSizeMake(100, 100)];
    calib.position = CGPointMake([ApplicationModel sharedModel].screenSize/2, [ApplicationModel sharedModel].screenSize/2);
    calib.zPosition = 49;
    
    [self addChild:calib];
}

#pragma mark - PlayerGameDelegate Implementation

-(void)playerMove:(PlayerController*)player
{
    if( player.index == 1 )
    {
        cross1.position = player.location;
    }
    else
    {
        cross2.position = player.location;
    }
}

-(void)playerTrigger:(PlayerController*)player
{
    if( !gameManager.active || player.ammo <= 0 )
    {
        return;
    }
        
    player.ammo--;
    [shellLabel1 setText:[NSString stringWithFormat:@"%ld", (long)[ApplicationModel sharedModel].player1.ammo]];
    [shellLabel2 setText:[NSString stringWithFormat:@"%ld", (long)[ApplicationModel sharedModel].player2.ammo]];
    
    NSString *path = [NSString stringWithFormat:@"%@/shotRifle.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [audioPlayer play];

    NSPoint point = player.location;
    
    [self enumerateChildNodesWithName:@"duck" usingBlock:^(SKNode *node, BOOL *stop) {
        Duck *duck = (Duck*)node;
        
        if( !duck.isShot )
        {
            if( [duck containsPoint:[duck convertPoint:point toNode:duck]] )
            {
                [self hit:duck byPlayer:player];
                *stop = YES;
            }
        }
    }];
    
    [self miss:point];
    
    if( [ApplicationModel sharedModel].player1.ammo <= 0 && [ApplicationModel sharedModel].player2.ammo <= 0)
    {
        [self gameTimeout];
        [gameManager finishRound];
    }
}

#pragma mark - GameDelegate Implementation

-(void)gameTimeout
{
    __block BOOL audio = YES;
    
    [self enumerateChildNodesWithName:@"duck" usingBlock:^(SKNode *node, BOOL *stop) {
        Duck *duck = (Duck*)node;
        
        if( !duck.isShot )
        {
            if(audio)
            {
                [gameManager playFile:@"dogLaugh.wav" withCompletion:nil];
            }
            audio = NO;
            [duck flyAway];
        }
    }];
}

- (void) gameRoundStart
{
    duckCount = 0;
    [shellLabel1 setText:[NSString stringWithFormat:@"%ld", (long)[ApplicationModel sharedModel].player1.ammo]];
    [shellLabel2 setText:[NSString stringWithFormat:@"%ld", (long)[ApplicationModel sharedModel].player2.ammo]];
}

-(void)gameSpawn:(DuckType)duckType
{
    duckCount++;
    Duck *duck = [[Duck alloc] initWithType:duckType];
    duck.anchorPoint = CGPointMake(0.5,0.5);
    
    CGFloat horiz = [ArenaScene numberBetween:kBorderPad and:self.size.width-kBorderPad];
    CGFloat vert = [ArenaScene numberBetween:kBorderPad and:self.size.height-kBorderPad];
    
    switch (arc4random()%4) {
        case 0:
            duck.position = CGPointMake(horiz, kBorderPad + kGroundPad);
            //duck.lat = DuckLatNorth;
            break;
            
        case 1:
            duck.position = CGPointMake(horiz, self.size.height-kBorderPad);
            //duck.lat = DuckLatSouth;
            break;
            
        case 2:
            duck.position = CGPointMake(kBorderPad, vert);
            //duck.lng = DuckLngWest;
            break;
            
        case 3:
            duck.position = CGPointMake(self.size.width-kBorderPad, vert);
            // duck.lng = DuckLngEast;
            break;
    }
    
    duck.zPosition = 15;
    [self addChild:duck];
    
    [self updateFlight:duck];
    
    if( ![duck isFlying] )
    {
        [duck setLat:duck.lat lng:duck.lng];
    }
}

#pragma mark - Class Methods

-(void)miss:(CGPoint)position
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Miss" ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [node setPosition:position];
    
    node.zPosition = 25;
    [self addChild:node];
    
    SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.3];
    
    [node runAction:fade completion:^{
        [node removeFromParent];
    }];
}

-(void)hit:(Duck*)duck byPlayer:(PlayerController*)player
{
    duckCount--;
    player.kills++;
    
    [eggLabel1 setText:[NSString stringWithFormat:@"%ld", (long)[ApplicationModel sharedModel].player1.kills]];
    [eggLabel2 setText:[NSString stringWithFormat:@"%ld", (long)[ApplicationModel sharedModel].player2.kills]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"hit%ld",(long)player.index] ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [node setPosition:duck.position];
    node.zPosition = 25;
    [self addChild:node];
    
    SKAction *wait = [SKAction waitForDuration:0.2];
    SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.1];
    
    [duck shoot];
    [node runAction:[SKAction sequence:@[wait,fade]] completion:^{
        [node removeAllActions];
        [node removeFromParent];
    }];
    
    if( duckCount == 0 )
    {
        [gameManager finishRound];
    }
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"duck" usingBlock:^(SKNode *node, BOOL *stop) {
        duckNode = (Duck*)node;
        if( duckNode.isShot )
        {
            if (duckNode.position.y < 0)
            {
                [duckNode removeFromParent];
            }
        }
        else
        {
            [self updateFlight:duckNode];
        }
    }];
}

-(void)updateFlight:(Duck*)duck
{
    newLat = duck.lat;
    newLng = duck.lng;
    
    if( duck.position.x < kBorderPad)
        newLng = DuckLngEast;
    
    if( duck.position.x > self.view.bounds.size.width - kBorderPad)
        newLng = DuckLngWest;
    
    if( duck.position.y < kGroundPad )
        newLat = DuckLatNorth;
    
    if( duck.position.y > self.view.bounds.size.height - kBorderPad )
        newLat = DuckLatSouth;
    
    if( duck.lat != newLat || duck.lng != newLng )
        [duck setLat:newLat lng:newLng];
}

- (SKSpriteNode *)makeCrosshair:(NSInteger)index
{
    SKSpriteNode *crosshair = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cross%ld", (long)index]];
    [crosshair setAnchorPoint:CGPointMake(0.5, 0.5)];
    [crosshair setSize:CGSizeMake(50.0, 50.0)];
    crosshair.zPosition = 75;
    return crosshair;
}

- (SKSpriteNode *)makeHudSprite:(NSString*)spriteName
{
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
    [spriteNode setAnchorPoint:CGPointMake(0.0, 0.0)];
    spriteNode.zPosition = 11;
    return spriteNode;
}


@end
