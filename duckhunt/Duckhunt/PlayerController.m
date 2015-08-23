//
//  PlayerController.m
//  Duckhunt
//
//  Created by Joe Andolina on 6/4/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "PlayerController.h"
#import "ApplicationModel.h"

@implementation PlayerController

-(id)initPlayer:(NSInteger)player
{
    self = [super init];
    
    if( self)
    {
        _index = player;
    }
    return self;
}

-(BOOL)connected
{
    return _wiimote != nil;
}

-(void)setWiimote:(WiiRemote *)wiimote
{
    _wiimote = wiimote;
    [_wiimote setDelegate:self];
    [_wiimote setInitialConfiguration];
    [_wiimote setIRSensorEnabled:YES];
    [_wiimote setMotionSensorEnabled:NO];
    [_wiimote setLEDEnabled1:_index==1 enabled2:_index==1 enabled3:_index==2 enabled4:_index==2];

    if( self.delegate)
    {
        [self.delegate playerConnect:self];
    }
}

#pragma mark - Sprite Handling
-(NSString*)spriteBang
{
    return self.index == 1 ? @"hit1" : @"hit4";
}

-(NSString*)spriteCross
{
    return self.index == 1 ? @"cross1" : @"cross4";
}


#pragma mark - WiiRemote delegate

- (void) wiimoteWillSendData{}
- (void) wiimoteDidSendData{}

- (void) irPointMovedX:(float) px Y:(float) py
{
    ApplicationModel *model = [ApplicationModel sharedModel];
    
    CGFloat sensitivity = self.index == 1 ? model.props.playerSensitivity1 : model.props.playerSensitivity2;
    sensitivity = (sensitivity+1) / 5;
    _location = NSMakePoint(((px+1)*sensitivity*model.screenSize), ((py+1)*sensitivity*model.screenSize));
    
    if( px == -100 && py == -100 )
    {
        return;
    }
    
    NSPoint offset = self.index == 1 ? model.props.playerOffset1 : model.props.playerOffset2;
    _location = NSMakePoint(_location.x + offset.x, _location.y + offset.y);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userMove" object:@{@"player":self}];
    //NSLog(@"%f : %f", _location.x, _location.y);
}

- (void) rawIRData: (IRData[4]) irData{}

- (void) buttonChanged:(WiiButtonType) type isPressed:(BOOL) isPressed
{
    if( type == WiiRemoteBButton && isPressed )
    {
        if( self.ammo > 0 )
        {
            self.ammo--;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"handleShot" object:@{@"player":self}];
            if( self.delegate )
            {
                //[self.delegate playerShot:self];
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"handleArenaShot" object:nil];
            }
        }
    }
}
- (void) accelerationChanged:(WiiAccelerationSensorType) type accX:(unsigned short) accX accY:(unsigned short) accY accZ:(unsigned short) accZ{}
- (void) joyStickChanged:(WiiJoyStickType) type tiltX:(unsigned short) tiltX tiltY:(unsigned short) tiltY{}
- (void) analogButtonChanged:(WiiButtonType) type amount:(unsigned short) press{}
- (void) pressureChanged:(WiiPressureSensorType) type pressureTR:(float) bPressureTR pressureBR:(float) bPressureBR
              pressureTL:(float) bPressureTL pressureBL:(float) bPressureBL{}
- (void) batteryLevelChanged:(double) level
{
    _level = level;
    if( self.delegate )
    {
        [self.delegate playerBattery:self];
    }
}
- (void) wiiRemoteDisconnected:(IOBluetoothDevice*) device
{
    _wiimote = nil;
    if( self.delegate )
    {
        [self.delegate playerDisconnect:self];
    }
}

- (void) gotMiiData: (Mii*) mii_data_buf at: (int) slot{}
- (void) rawPressureChanged:(WiiBalanceBoardGrid) bbData{}
- (void) allPressureChanged:(WiiPressureSensorType) type bbData:(WiiBalanceBoardGrid) bbData bbDataInKg:(WiiBalanceBoardGrid) bbDataInKg{}

@end
