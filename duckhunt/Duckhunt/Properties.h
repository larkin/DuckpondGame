//
//  Properties.h
//  Duckhunt
//
//  Created by Joe Andolina on 8/21/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Properties : NSObject

@property (nonatomic) CGFloat duckDistance;
@property (nonatomic) CGFloat duckScale;
@property (nonatomic) CGFloat duckSpeed;

@property (nonatomic) CGFloat duck1Speed;
@property (nonatomic) CGFloat duck1Min;
@property (nonatomic) CGFloat duck1Max;

@property (nonatomic) CGFloat duck2Speed;
@property (nonatomic) CGFloat duck2Min;
@property (nonatomic) CGFloat duck2Max;

@property (nonatomic) CGFloat duck3Speed;
@property (nonatomic) CGFloat duck3Min;
@property (nonatomic) CGFloat duck3Max;

@property (nonatomic) NSPoint playerOffset1;
@property (nonatomic) NSPoint playerOffset2;

-(void)saveDefaults;

@end
