//
//  PlayerController.h
//  Duckhunt
//
//  Created by Joe Andolina on 6/4/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WiiRemote/WiiRemote.h>

#pragma mark - Player Controller Delegate

@class PlayerController;

@protocol PlayerAdminDelegate <NSObject>
@optional
- (void) playerBattery:(PlayerController*)player;
- (void) playerConnect:(PlayerController*)player;
- (void) playerDisconnect:(PlayerController*)player;
- (void) playerTimeout:(PlayerController*)player;
@end

@protocol PlayerGameDelegate <NSObject>
@optional
- (void) playerMove:(PlayerController*)player;
- (void) playerTrigger:(PlayerController*)player;
@end

@interface PlayerController : NSObject

@property (readonly) double level;
@property (readonly) NSInteger index;

@property (readonly) BOOL connected;
@property (readonly) CGPoint location;

@property (strong, nonatomic) WiiRemote *wiimote;
@property (nonatomic, weak) id<PlayerAdminDelegate> adminDelegate;
@property (nonatomic, weak) id<PlayerGameDelegate> gameDelegate;

#pragma mark - Gameplay 

@property (nonatomic) NSInteger ammo;
@property (nonatomic) NSInteger kills;
@property (nonatomic) NSString *bang;

-(id)initPlayer:(NSInteger)index;

#pragma mark - WiiRemoteDiscoveryDelegate implementation

- (void) wiimoteWillSendData;
- (void) wiimoteDidSendData;

- (void) irPointMovedX:(float) px Y:(float) py;
- (void) rawIRData: (IRData[4]) irData;
- (void) buttonChanged:(WiiButtonType) type isPressed:(BOOL) isPressed;
- (void) accelerationChanged:(WiiAccelerationSensorType) type accX:(unsigned short) accX accY:(unsigned short) accY accZ:(unsigned short) accZ;
- (void) joyStickChanged:(WiiJoyStickType) type tiltX:(unsigned short) tiltX tiltY:(unsigned short) tiltY;
- (void) analogButtonChanged:(WiiButtonType) type amount:(unsigned short) press;
- (void) pressureChanged:(WiiPressureSensorType) type pressureTR:(float) bPressureTR pressureBR:(float) bPressureBR
              pressureTL:(float) bPressureTL pressureBL:(float) bPressureBL;
- (void) batteryLevelChanged:(double) level;
- (void) wiiRemoteDisconnected:(IOBluetoothDevice*) device;
- (void) gotMiiData: (Mii*) mii_data_buf at: (int) slot;
- (void) rawPressureChanged:(WiiBalanceBoardGrid) bbData;
- (void) allPressureChanged:(WiiPressureSensorType) type bbData:(WiiBalanceBoardGrid) bbData bbDataInKg:(WiiBalanceBoardGrid) bbDataInKg;

@end
