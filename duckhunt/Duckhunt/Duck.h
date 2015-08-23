//
//  Duck.h
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Cocoa/Cocoa.h>


typedef NS_ENUM(NSInteger, DuckLat) {
    DuckLatNorth,
    DuckLatEven,
    DuckLatSouth
};

typedef NS_ENUM(NSInteger, DuckLng) {
    DuckLngWest,
    DuckLngEast
};

typedef NS_ENUM(NSInteger, DuckType) {
    DuckTypeEasy,
    DuckTypeNormal,
    DuckTypeHard
};

@interface Duck : SKSpriteNode

@property (nonatomic) DuckLat lat;
@property (nonatomic) DuckLng lng;
@property (nonatomic) DuckType duckType;

@property (nonatomic) BOOL isShot;

-(id)initWithType:(DuckType)duckType;

-(void)setLat:(DuckLat)latDir lng:(DuckLng)lngDir;
-(void)shoot;
-(BOOL)isFlying;
-(void)flyAway;

@end
