//
//  LobbyScene.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "LobbyScene.h"

@implementation LobbyScene

-(id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if(self)
    {
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
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    [bgImage setSize:self.size];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:bgImage];

    self.backgroundColor = [SKColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
}


@end
