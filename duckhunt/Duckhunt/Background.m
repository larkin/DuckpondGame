//
//  LobbyScene.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "Background.h"
#import "PropertiesManager.h"

@implementation Background
{
    SKSpriteNode *cloud1;
    SKSpriteNode *cloud2;
    SKSpriteNode *cloud3;
    SKSpriteNode *cloud4;
    SKSpriteNode *foreground;
    
    NSInteger lastScene;
}


-(id)init
{
    self = [super init];
    
    if( self )
    {
        lastScene = -1;
        [self createSceneContents];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents
{
    cloud1 = [self createCloud:1];
    cloud2 = [self createCloud:2];
    cloud3 = [self createCloud:3];
    cloud4 = [self createCloud:4];
    [self updateScene];
}

-(void)updateScene
{
    PropertiesManager *props = [PropertiesManager sharedManager];
    
    if( lastScene == props.gameScene )
    {
        return;
    }
    
    if( foreground && foreground.parent )
    {
        [foreground removeFromParent];
        foreground = nil;
    }
    
    lastScene = props.gameScene;
    foreground = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"foreground%ld", lastScene+1]];
    [foreground setSize:CGSizeMake(props.screenSize, foreground.size.height*(props.screenSize/foreground.size.width))];
    foreground.anchorPoint = NSMakePoint(0,0);
    foreground.position = NSMakePoint(0,0);
    foreground.zPosition = 10;
    [self addChild:foreground];
}

-(void)animateCloud:(SKSpriteNode*)cloud
{
    PropertiesManager *props = [PropertiesManager sharedManager];
    
    //[cloud removeAllActions];
    
    int moveDir = (arc4random() % 30)+1;
    int cloudDir = (arc4random() % 30)+1;
    CGFloat cloudSpeed = (arc4random()%3)+2;
    
    CGFloat startY = (props.screenSize-250.0) + (arc4random() % 200) + 1.0;
    CGFloat startX = moveDir % 2 == 0 ?  props.screenSize + cloud.size.width : -cloud.size.width;
    CGFloat endX = moveDir % 2 == 0 ? -cloud.size.width : props.screenSize + cloud.size.width;
    
    CGFloat cloudScale = ((arc4random()%20)+40.0)/100.0;
    cloud.xScale = cloudDir % 2 == 0 ? cloudScale : -cloudScale;
    cloud.yScale = cloudScale;
    cloud.position = NSMakePoint(startX, startY);
    
    NSInteger actionDelay = (arc4random() % 4) * 5;
    SKAction *move = [SKAction moveToX:endX duration:15.0*cloudSpeed];
    SKAction *delay = [SKAction waitForDuration:actionDelay];
    SKAction *group = [SKAction sequence:@[delay, move]];
    
    [cloud runAction:group completion:^{
        [self animateCloud:cloud];
    }];
}

-(SKSpriteNode*)createCloud:(NSInteger)index
{
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cloud%ld",(long)index]];
    cloud.anchorPoint = NSMakePoint(0.5,0.5);
    cloud.position = NSMakePoint(0, -500);
    [cloud setScale:0.6];
    cloud.zPosition = index+5;
    [self addChild:cloud];
    [self animateCloud:cloud];
    return cloud;
}
@end
