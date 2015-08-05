//
//  CalibrationScene.h
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CalibrationScene : SKScene

@property BOOL contentCreated;

-(void)handleShot:(NSValue*)point;

@end
