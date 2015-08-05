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

#define kBorderPad 25
#define kGroundPad 150

@implementation ArenaScene
{
    BOOL lastMiss;
    
    Duck *duckNode;
    DuckLat newLat;
    DuckLng newLng;
}

+(float)numberBetween:(float)lowerBound and:(float)upperBound
{
    float diff = upperBound - lowerBound;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + lowerBound;
}


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
        //bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        //[self addChild:bgImage];

        //Duck *walkAnimation = [SKAction animateWithTextures:[ApplicationModel sharedModel].duckTextures timePerFrame:0.1 ];
        //[spaceship runAction:walkAnimation completion:^{
        //    [spaceship runAction:walkAnimation]
        //}];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spawnDuck) name:@"spawnDuck" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(missDuck) name:@"missDuck" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(killDuck) name:@"killDuck" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleArenaShot:) name:@"handleArenaShot" object:nil];
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

-(void)createSceneContents
{
    self.backgroundColor = [SKColor colorWithCalibratedRed:94.0/255.0 green:204.0/255.0 blue:236.0/255.0 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    //[self spawnDuck];
    //[self addChild: [self newHelloNode]];
}

-(void)handleArenaShot:(NSNotification*)notification
{
    NSLog(@"Shot");
    //[self miss:[[notification.userInfo objectForKey:@"point"] pointValue]];
    NSPoint point = [[notification.userInfo objectForKey:@"point"] pointValue];
    
    [self enumerateChildNodesWithName:@"duck" usingBlock:^(SKNode *node, BOOL *stop) {
        Duck *duck = (Duck*)node;
        
        if( !duck.isShot )
        {
            if( [duck containsPoint:[duck convertPoint:point toNode:duck]] )
            {
                [self hit:duck];
                *stop = YES;
                return;
            }
        }
    }];
    [self miss:point];

}

-(void)spawnDuck
{
    Duck *duck = [[Duck alloc] initWithType:arc4random()%3];
    
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
    
    [self addChild:duck];
    [self updateFlight:duck];
    
    if( ![duck isFlying] )
    {
        [duck setLat:duck.lat lng:duck.lng];
    }
}

-(void)missDuck
{
    lastMiss = !lastMiss;
    [self miss:CGPointMake((arc4random()%(int)self.view.bounds.size.width-50)+25, (arc4random()%(int)self.view.bounds.size.height-50)+25)];
}

-(void)miss:(CGPoint)position
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Miss" ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [node setPosition:position];
    [self addChild:node];
    
    SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.3];
    
    [node runAction:fade completion:^{
        [node removeFromParent];
    }];
}

-(void)hit:(Duck*)duck
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Spark" ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [node setPosition:duck.position];
    [self addChild:node];
    
    SKAction *wait = [SKAction waitForDuration:0.2];
    SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.1];
    
    [duck shoot];
    [node runAction:[SKAction sequence:@[wait,fade]] completion:^{
        [node removeFromParent];
    }];

}

-(void)killDuck
{
    [self enumerateChildNodesWithName:@"duck" usingBlock:^(SKNode *node, BOOL *stop) {
        Duck *duck = (Duck*)node;
        if( !duck.isShot )
        {
            [self hit:duck];
            *stop = YES;
            return;
        }
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

@end
