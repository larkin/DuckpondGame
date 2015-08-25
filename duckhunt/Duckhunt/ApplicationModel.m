//
//  ApplicationModel.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "ApplicationModel.h"

@implementation ApplicationModel
{
    NSArray *textureNames;
}

+ (id)sharedModel {
    static ApplicationModel *sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

- (id)init
{
    if (self = [super init])
    {
        self.props = [[Properties alloc] init];
        [self loadTextures];
        self.player1 = [[PlayerController alloc] initPlayer:1];
        self.player2 = [[PlayerController alloc] initPlayer:2];
        
        self.midiManager = [MidiManager sharedManager];
    }
    return self;
}

-(void)loadTextures
{
    SKTextureAtlas *atlas;
    textureNames = @[@"Horiz1",@"Horiz2",@"Horiz3",@"Horiz2",@"Diag1",@"Diag2",@"Diag3",@"Diag2",@"Fall1",@"Fall2",@"Fall3",@"Fall4",@"Shot"];
    NSMutableArray *duckTextures = [[NSMutableArray alloc] initWithCapacity:textureNames.count];
    
    for( int i = 1; i < 4; i++ )
    {
        atlas = [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"Duck%d",i]];
        for ( NSString *name in textureNames )
        {
            [duckTextures addObject:[atlas textureNamed:[NSString stringWithFormat:@"Duck%d_%@",i,name]]];
        }
    }
    
    [SKTexture preloadTextures:duckTextures withCompletionHandler:^{
        self.duckTextures = [self parseDuckTextures:duckTextures];
        NSLog(@"Textures Loaded");
    }];
}


-(NSArray*)parseDuckTextures:(NSArray*)duckTextures
{
    NSUInteger duckLen = textureNames.count;
    NSMutableArray *response = [[NSMutableArray alloc] initWithCapacity:3];
    
    for ( int i = 0; i < 3; i++ )
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
        NSArray *tex = [duckTextures subarrayWithRange:NSMakeRange(duckLen*i, duckLen)];
        
        [dict setValue:[tex subarrayWithRange:NSMakeRange(0, 4)] forKey:@"fly"];
        [dict setValue:[tex subarrayWithRange:NSMakeRange(4, 4)] forKey:@"climb"];
        [dict setValue:[tex subarrayWithRange:NSMakeRange(8, 4)] forKey:@"fall"];
        [dict setValue:tex[duckLen-1] forKey:@"shot"];
        [response addObject:dict];
    }
    return response;
}

-(SKTexture*)texture:(NSInteger)duckIndex action:(NSString*)actionName
{
    return [self.duckTextures[duckIndex] valueForKey:actionName];
}

-(NSArray*)textures:(NSInteger)duckIndex action:(NSString*)actionName
{
    return [self.duckTextures[duckIndex] valueForKey:actionName];
}

-(PlayerController*)playerWith:(NSInteger)playerNumber
{
    return playerNumber == 1 ? self.player1 : self.player2;
}

@end
