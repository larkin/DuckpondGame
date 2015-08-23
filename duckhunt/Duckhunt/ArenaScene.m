//
//  TestScene.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "ArenaScene.h"
#import "ApplicationModel.h"
#import "Duck.h"

#define kBorderPad 20
#define kGroundPad 150

@implementation ArenaScene
{
    BOOL lastMiss;
    
    Duck *duckNode;
    DuckLat newLat;
    DuckLng newLng;
    
    SKSpriteNode *calib;
    SKSpriteNode *cross1;
    SKSpriteNode *cross2;
}

+(float)numberBetween:(float)lowerBound and:(float)upperBound
{
    float diff = upperBound - lowerBound;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + lowerBound;
}


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spawnDuck:) name:@"spawnDuck" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roundTimeout) name:@"roundTimeout" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserMove:) name:@"userMove" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShot:) name:@"handleShot" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHideCalibration:) name:@"hideCalibrationTarget" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowCalibration:) name:@"showCalibrationTarget" object:nil];
        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        self.contentCreated = YES;
        [self createSceneContents];
    }
}

-(void)willMoveFromView:(SKView *)view
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"spawnDuck" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"roundTimeout" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userMove" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handleShot" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideCalibrationTarget" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showCalibrationTarget" object:nil];
}

-(void)createSceneContents
{
    self.backgroundColor = [SKColor colorWithCalibratedRed:94.0/255.0 green:204.0/255.0 blue:236.0/255.0 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    cross1 = [self makeCrosshair:[ApplicationModel sharedModel].player1];
    cross1.position = CGPointMake(200, 200);
    [self addChild:cross1];
    //[self insertChild:cross1 atIndex:75];

    cross2 = [self makeCrosshair:[ApplicationModel sharedModel].player2];
    cross2.position = CGPointMake(500, 500);
    [self addChild:cross2];

    // TODO : ADD HUD
}


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

-(void)handleUserMove:(NSNotification*)notification
{
    PlayerController *player = [notification.object objectForKey:@"player"];
    
    if( player.index == 1 )
    {
        cross1.position = player.location;
    }
    else
    {
        cross2.position = player.location;
    }
}

-(void)handleShot:(NSNotification*)notification
{
    //[self miss:[[notification.userInfo objectForKey:@"point"] pointValue]];
    //NSPoint point = [[notification.userInfo objectForKey:@"point"] pointValue];
    
    PlayerController *player = [notification.object objectForKey:@"player"];
    NSPoint point = player.location;
    
    [self enumerateChildNodesWithName:@"duck" usingBlock:^(SKNode *node, BOOL *stop) {
        Duck *duck = (Duck*)node;
        
        if( !duck.isShot )
        {
            if( [duck containsPoint:[duck convertPoint:point toNode:duck]] )
            {
                [self player:player hit:duck];
                *stop = YES;
                return;
            }
        }
    }];
    
    [self miss:point];
}

-(void)roundTimeout
{
    [self enumerateChildNodesWithName:@"duck" usingBlock:^(SKNode *node, BOOL *stop) {
        Duck *duck = (Duck*)node;
        
        if( !duck.isShot )
        {
            [duck flyAway];
        }
    }];
}


-(void)spawnDuck:(NSNotification*)notification
{
    NSInteger duckType = [notification.object integerValue];
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
    
    duck.zPosition = 10;
    [self addChild:duck];
    
    [self updateFlight:duck];
    
    if( ![duck isFlying] )
    {
        [duck setLat:duck.lat lng:duck.lng];
    }
}

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

-(void)player:(PlayerController*)player hit:(Duck*)duck
{
    NSString *path = [[NSBundle mainBundle] pathForResource:player.spriteBang ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [node setPosition:duck.position];
    node.zPosition = 25;
    [self addChild:node];
    
    SKAction *wait = [SKAction waitForDuration:0.2];
    SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.1];
    
    [duck shoot];
    [node runAction:[SKAction sequence:@[wait,fade]] completion:^{
        [node removeFromParent];
    }];
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

- (SKSpriteNode *)makeCrosshair:(PlayerController*)player
{
    SKSpriteNode *crosshair = [SKSpriteNode spriteNodeWithImageNamed:[player spriteCross]];
    [crosshair setAnchorPoint:CGPointMake(0.5, 0.5)];
    [crosshair setSize:CGSizeMake(50.0, 50.0)];
    crosshair.zPosition = 75;
    return crosshair;
}

@end
