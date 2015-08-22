//
//  Properties.m
//  Duckhunt
//
//  Created by Joe Andolina on 8/21/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "Properties.h"

@implementation Properties
{
    NSString *propsKey;
}

-(id)init
{
    self = [super init];
    
    if( self )
    {
        propsKey = @"duckProperties";
        [self loadDefaults];
    }
    
    return self;
}

-(void)resetDefaults
{
    self.gameGlitch = 50;
    self.gameScale = 1.0;
    self.gameSpeed = 0.4;
    
    self.duck1Speed = 0.75;
    self.duck1Min   = 1.50;
    self.duck1Max   = 2.50;
    
    self.duck2Speed = 1.50;
    self.duck2Min   = 1.00;
    self.duck2Max   = 2.00;
    
    self.duck3Speed = 2.00;
    self.duck3Min   = 1.50;
    self.duck3Max   = 2.50;
    
    // Do not reset the calibration
    NSDictionary *appDefaults  = [[NSUserDefaults standardUserDefaults] dictionaryForKey:propsKey];
    if( !appDefaults )
    {
        self.playerOffset1 = NSMakePoint(0.0, 0.0);
        self.playerOffset2 = NSMakePoint(0.0, 0.0);
    }
    
    [self saveDefaults];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"defaultsLoaded" object:nil];
}

-(void)loadDefaults
{
    NSDictionary *appDefaults  = [[NSUserDefaults standardUserDefaults] dictionaryForKey:propsKey];
    
    if( !appDefaults )
    {
        [self resetDefaults];
        appDefaults  = [[NSUserDefaults standardUserDefaults] dictionaryForKey:propsKey];
    }
    
    self.gameGlitch = [[appDefaults valueForKey:@"gameGlitch"] floatValue];
    self.gameScale = [[appDefaults valueForKey:@"gameScale"] floatValue];
    self.gameSpeed = [[appDefaults valueForKey:@"gameSpeed"] floatValue];
    
    self.duck1Speed = [[appDefaults valueForKey:@"duck1Speed"] floatValue];
    self.duck1Min   = [[appDefaults valueForKey:@"duck1Min"] floatValue];
    self.duck1Max   = [[appDefaults valueForKey:@"duck1Max"] floatValue];
    
    self.duck2Speed = [[appDefaults valueForKey:@"duck2Speed"] floatValue];
    self.duck2Min   = [[appDefaults valueForKey:@"duck2Min"] floatValue];
    self.duck2Max   = [[appDefaults valueForKey:@"duck2Max"] floatValue];
    
    self.duck3Speed = [[appDefaults valueForKey:@"duck3Speed"] floatValue];
    self.duck3Min   = [[appDefaults valueForKey:@"duck3Min"] floatValue];
    self.duck3Max   = [[appDefaults valueForKey:@"duck3Max"] floatValue];
    
    self.playerOffset1 = NSMakePoint([[appDefaults valueForKey:@"playerOffset1x"] floatValue],
                                     [[appDefaults valueForKey:@"playerOffset1y"] floatValue]);
    
    self.playerOffset2 = NSMakePoint([[appDefaults valueForKey:@"playerOffset2x"] floatValue],
                                     [[appDefaults valueForKey:@"playerOffset2y"] floatValue]);
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"defaultsLoaded" object:nil];
}

-(void)saveDefaults
{
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
    
    [appDefaults setValue:[NSNumber numberWithFloat:self.gameGlitch] forKey:@"gameGlitch"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.gameScale] forKey:@"gameScale"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.gameSpeed] forKey:@"gameSpeed"];
    
    [appDefaults setValue:[NSNumber numberWithFloat:self.duck1Speed] forKey:@"duck1Speed"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.duck1Min] forKey:@"duck1Min"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.duck1Max] forKey:@"duck1Max"];
    
    [appDefaults setValue:[NSNumber numberWithFloat:self.duck2Speed] forKey:@"duck2Speed"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.duck2Min] forKey:@"duck2Min"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.duck2Max] forKey:@"duck2Max"];
    
    [appDefaults setValue:[NSNumber numberWithFloat:self.duck3Speed] forKey:@"duck3Speed"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.duck3Min] forKey:@"duck3Min"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.duck3Max] forKey:@"duck3Max"];
    
    [appDefaults setValue:[NSNumber numberWithFloat:self.playerOffset1.x] forKey:@"playerOffset1x"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.playerOffset1.y] forKey:@"playerOffset1y"];

    [appDefaults setValue:[NSNumber numberWithFloat:self.playerOffset2.x] forKey:@"playerOffset2x"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.playerOffset2.y] forKey:@"playerOffset2y"];

    [[NSUserDefaults standardUserDefaults] setObject:appDefaults forKey:propsKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)duckDistance:(CGFloat)distance
{
    _gameGlitch = distance;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"gameGlitchChanged" object:nil];
}

-(void)setGameScale:(CGFloat)duckScale
{
    _gameScale = duckScale;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameScaleChanged" object:nil];
}


-(void)duckSpeed:(CGFloat)speed
{
    _gameSpeed = speed;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameSpeedChanged" object:nil];
}

-(void)setDuck1Max:(CGFloat)max
{
    _duck1Max = max;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duckMaxChanged" object:[NSNumber numberWithInt:1]];
}


-(void)setDuck1Min:(CGFloat)min
{
    _duck1Min = min;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duckMinChanged" object:[NSNumber numberWithInt:1]];
}

-(void)setDuck1Speed:(CGFloat)speed
{
    _duck1Speed = speed;
   [[NSNotificationCenter defaultCenter] postNotificationName:@"duckSpeedChanged" object:[NSNumber numberWithInt:1]];
}


-(void)setDuck2Max:(CGFloat)max
{
    _duck2Max = max;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duckMaxChanged" object:[NSNumber numberWithInt:3]];
}

-(void)setDuck2Min:(CGFloat)min
{
    _duck2Min = min;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duckMinChanged" object:[NSNumber numberWithInt:2]];
}

-(void)setDuck2Speed:(CGFloat)speed
{
    _duck2Speed = speed;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duckSpeedChanged" object:[NSNumber numberWithInt:2]];
}


-(void)setDuck3Max:(CGFloat)max
{
    _duck3Max = max;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duckMaxChanged" object:[NSNumber numberWithInt:3]];
}

-(void)setDuck3Min:(CGFloat)min
{
    _duck3Min = min;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duckMinChanged" object:[NSNumber numberWithInt:3]];
}


-(void)setDuck3Speed:(CGFloat)speed
{
    _duck3Speed = speed;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duckSpeedChanged" object:[NSNumber numberWithInt:3]];
}

-(void)playerOffset1:(NSPoint)point
{
    _playerOffset1 = point;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"playerOffset1Changed" object:nil];

}

-(void)playerOffset2:(NSPoint)point
{
    _playerOffset2 = point;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"playerOffset2Changed" object:nil];
}

@end
