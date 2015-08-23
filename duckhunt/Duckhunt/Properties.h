//
//  Properties.h
//  Duckhunt
//
//  Created by Joe Andolina on 8/21/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Properties : NSObject

@property (nonatomic) CGFloat gameGlitch;
@property (nonatomic) CGFloat gameScale;
@property (nonatomic) CGFloat gameSpeed;

@property (nonatomic) CGFloat duck1Speed;
@property (nonatomic) CGFloat duck1Min;
@property (nonatomic) CGFloat duck1Max;

@property (nonatomic) CGFloat duck2Speed;
@property (nonatomic) CGFloat duck2Min;
@property (nonatomic) CGFloat duck2Max;

@property (nonatomic) CGFloat duck3Speed;
@property (nonatomic) CGFloat duck3Min;
@property (nonatomic) CGFloat duck3Max;

@property (nonatomic) CGFloat playerSensitivity1;
@property (nonatomic) NSPoint playerOffset1;

@property (nonatomic) CGFloat playerSensitivity2;
@property (nonatomic) NSPoint playerOffset2;

-(void)resetDefaults;
-(void)saveDefaults;

@end
