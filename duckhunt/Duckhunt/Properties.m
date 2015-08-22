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
        
        self.duckDistance = 50;
        self.duckScale = 1.0;
        self.duckSpeed = 0.4;
    
        self.duck1Speed = 0.75;
        self.duck1Min   = 1.50;
        self.duck1Max   = 2.50;
        
        self.duck2Speed = 1.50;
        self.duck2Min   = 1.00;
        self.duck2Max   = 2.00;
        
        self.duck3Speed = 2.00;
        self.duck3Min   = 1.50;
        self.duck3Max   = 2.50;
        
        self.playerOffset1 = NSMakePoint(0.0, 0.0);
        self.playerOffset2 = NSMakePoint(0.0, 0.0);

        [self loadDefaults];
    }
    
    return self;
}

-(void)loadDefaults
{
    NSDictionary *appDefaults  = [[NSUserDefaults standardUserDefaults] dictionaryForKey:propsKey];
    
    if( !appDefaults )
    {
        [self saveDefaults];
        appDefaults  = [[NSUserDefaults standardUserDefaults] dictionaryForKey:propsKey];
    }
    
    self.duckDistance = [[appDefaults valueForKey:@"duckDistance"] floatValue];
    self.duckScale = [[appDefaults valueForKey:@"duckScale"] floatValue];
    self.duckSpeed = [[appDefaults valueForKey:@"duckSpeed"] floatValue];
    
    self.duck1Speed = [[appDefaults valueForKey:@"duck1Speed"] floatValue];
    self.duck1Min   = [[appDefaults valueForKey:@"duck1Min"] floatValue];
    self.duck1Max   = [[appDefaults valueForKey:@"duck1Max"] floatValue];
    
    self.duck2Speed = [[appDefaults valueForKey:@"duck1Speed"] floatValue];
    self.duck2Min   = [[appDefaults valueForKey:@"duck1Min"] floatValue];
    self.duck2Max   = [[appDefaults valueForKey:@"duck1Max"] floatValue];
    
    self.duck3Speed = [[appDefaults valueForKey:@"duck1Speed"] floatValue];
    self.duck3Min   = [[appDefaults valueForKey:@"duck1Min"] floatValue];
    self.duck3Max   = [[appDefaults valueForKey:@"duck1Max"] floatValue];
    
    self.playerOffset1 = NSMakePoint([[appDefaults valueForKey:@"playerOffset1x"] floatValue],
                                     [[appDefaults valueForKey:@"playerOffset1y"] floatValue]);
    
    self.playerOffset2 = NSMakePoint([[appDefaults valueForKey:@"playerOffset2x"] floatValue],
                                     [[appDefaults valueForKey:@"playerOffset2y"] floatValue]);
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveDefaults
{
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
    
    [appDefaults setValue:[NSNumber numberWithFloat:self.duckDistance] forKey:@"duckDistance"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.duckScale] forKey:@"duckScale"];
    [appDefaults setValue:[NSNumber numberWithFloat:self.duckSpeed] forKey:@"duckSpeed"];
    
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
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
