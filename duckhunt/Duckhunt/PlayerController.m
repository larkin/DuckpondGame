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

#pragma mark - WiiRemote delegate

- (void) wiimoteWillSendData{}
- (void) wiimoteDidSendData{}

- (void) irPointMovedX:(float) px Y:(float) py
{
    float screenSize = [ApplicationModel sharedModel].screenSize;
    _location = NSMakePoint(px*screenSize, py*screenSize);
    
    if( px == -100 && py == -100 )
    {
        return;
    }
    
    //NSPoint point = NSMakePoint(px, py);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userMove" object:@{@"player":self}];
    NSLog(@"%f : %f", _location.x, _location.y);
    return;
    /*
    if (mouseEventMode != 2)
        return;
    
    BOOL haveMouse = (px > -2)?YES:NO;
    
    if (!haveMouse) {
        [graphView setIRPointX:-2 Y:-2];
        return;
    } else {
        [graphView setIRPointX:px Y:py];
    }
    */
    int dispWidth = 0;//CGDisplayPixelsWide();
    int dispHeight = 0;//CGDisplayPixelsHigh(kCGDirectMainDisplay);
    
    //id config = [mappingController selection];
    float sens2 = 1.0;//[[config valueForKey:@"sensitivity2"] floatValue] * [[config valueForKey:@"sensitivity2"] floatValue];
    // TODO : Set up sensativity
    
    float newx = (px*1*sens2)*dispWidth + dispWidth/2;
    float newy = -(py*1*sens2)*dispWidth + dispHeight/2;
    //float scaledX = ((irData[0].x / 1024.0) * 2.0) - 1.0;
    
    if (newx < 0) newx = 0;
    if (newy < 0) newy = 0;
    if (newx >= dispWidth) newx = dispWidth-1;
    if (newy >= dispHeight) newy = dispHeight-1;
    /*
    float dx = newx - point.x;
    float dy = newy - point.y;
    
    float d = sqrt(dx*dx+dy*dy);
    
    
    
    // mouse filtering
    if (d < 20) {
        point.x = point.x * 0.9 + newx*0.1;
        point.y = point.y * 0.9 + newy*0.1;
    } else if (d < 50) {
        point.x = point.x * 0.7 + newx*0.3;
        point.y = point.y * 0.7 + newy*0.3;
    } else {
        point.x = newx;
        point.y = newy;
    }
    
    if (point.x > dispWidth)
        point.x = dispWidth - 1;
    
    if (point.y > dispHeight)
        point.y = dispHeight - 1;
    
    if (point.x < 0)
        point.x = 0;
    if (point.y < 0)
        point.y = 0;
    */
    
    /*
    if (!isLeftButtonDown && !isRightButtonDown){
        CFRelease(CGEventCreate(NULL));
        // this is Tiger's bug.
        // see also: http://www.cocoabuilder.com/archive/message/cocoa/2006/10/4/172206
        
        
        CGEventRef event = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, point, kCGMouseButtonLeft);
        
        CGEventSetType(event, kCGEventMouseMoved);
        // this is Tiger's bug.
        // see also: http://lists.apple.com/archives/Quartz-dev/2005/Oct/msg00048.html
        
        
        CGEventPost(kCGHIDEventTap, event);
        CFRelease(event);
    }else{
        
        CFRelease(CGEventCreate(NULL));
        // this is Tiger's bug.
        //see also: http://www.cocoabuilder.com/archive/message/cocoa/2006/10/4/172206
        
        
        CGEventRef event = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDragged, point, kCGMouseButtonLeft);
        
        CGEventSetType(event, kCGEventLeftMouseDragged);
        // this is Tiger's bug.
        // see also: http://lists.apple.com/archives/Quartz-dev/2005/Oct/msg00048.html
        
        CGEventPost(kCGHIDEventTap, event);
        CFRelease(event);	
    }
    */
}

- (void) rawIRData: (IRData[4]) irData{}

- (void) buttonChanged:(WiiButtonType) type isPressed:(BOOL) isPressed
{
    if( type == WiiRemoteBButton && isPressed )
    {
        NSLog(@"Bang");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"handleArenaShot" object:@{@"player":self}];
        if( self.delegate )
        {
            //[self.delegate playerShot:self];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"handleArenaShot" object:nil];
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
    //NSLog(@"Battery %f", level);
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
