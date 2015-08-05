//
//  CalibrationScene.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "CalibrationScene.h"
#import "ApplicationModel.h"

#define kCalibBorderSize 10
#define kCalibCircleSize 50

@implementation CalibrationScene

{
    int dotIndex;
    SKSpriteNode *arrow;
    SKSpriteNode *target;
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
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spawnDuck) name:@"spawnDuck" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCalibrationShot:) name:@"handleCalibrationShot" object:nil];
    }
    return self;
}

-(void)willMoveFromView:(SKView *)view
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handleCalibrationShot" object:nil];
}

- (void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        self.contentCreated = YES;
    }
    self.backgroundColor = [SKColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    arrow = [[SKSpriteNode alloc] initWithImageNamed:@"Arrow"];
    arrow.size = CGSizeMake(100, 100);
    arrow.xScale = -1;
    arrow.yScale = 1;
    arrow.position = CGPointMake(kCalibCircleSize*3, self.size.height - (kCalibCircleSize*3));
    
    target = [[SKSpriteNode alloc] initWithImageNamed:@"Target"];
    target.size = CGSizeMake(kCalibCircleSize, kCalibCircleSize);
    target.position = CGPointMake(kCalibCircleSize/2, self.size.height - kCalibCircleSize/2);
    
    [self addChild:arrow];
    [self addChild:target];
   
    SKAction *spin = [SKAction rotateByAngle:2.0 duration:0.75];
    [target runAction:[SKAction repeatActionForever:spin]];

    dotIndex = 0;
    [self showPoint:dotIndex];
}


-(void)showPoint:(NSInteger)index
{
    CGPoint aPoint;
    CGPoint aScale;
    CGPoint tPoint;
    
    SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.3];
    SKAction *show = [SKAction fadeAlphaTo:1.0 duration:0.4];
    
    switch (index)
    {
        case 0: // Top Left
            aScale = CGPointMake(-1, 1);
            aPoint = CGPointMake(kCalibCircleSize*3, self.size.height - (kCalibCircleSize*3));
            tPoint = CGPointMake(kCalibCircleSize/2, self.size.height - kCalibCircleSize/2);
            break;
        case 1: // Top Right
            aScale = CGPointMake(1, 1);
            aPoint = CGPointMake(self.size.width - (kCalibCircleSize*3), self.size.height - (kCalibCircleSize*3));
            tPoint = CGPointMake(self.size.width - kCalibCircleSize/2, self.size.height - kCalibCircleSize/2);
            break;
        case 2: // Bottom Right
            aScale = CGPointMake(1, -1);
            aPoint = CGPointMake(self.size.width - (kCalibCircleSize*3), kCalibCircleSize*3);
            tPoint = CGPointMake(self.size.width - kCalibCircleSize/2, kCalibCircleSize/2);
            break;
        case 3: // Bottom Left
            aScale = CGPointMake(-1, -1);
            aPoint = CGPointMake(kCalibCircleSize*3, kCalibCircleSize*3);
            tPoint = CGPointMake(kCalibCircleSize/2, kCalibCircleSize/2);
            break;
    }
    
    if( target.position.x == tPoint.x && target.position.y == tPoint.y)
    {
        return;
    }
    
    [arrow runAction:fade completion:^{
        [target runAction:[SKAction moveTo:tPoint duration:0.75] completion:^{
            arrow.xScale = aScale.x;
            arrow.yScale = aScale.y;
            arrow.position = aPoint;
            [arrow runAction:show];
        }];
    }];
    
    
}

-(void)handleCalibrationShot:(NSNotification*)notification
{
    dotIndex++;
    [self showPoint:dotIndex];
}

@end
