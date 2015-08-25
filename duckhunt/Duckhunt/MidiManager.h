//
//  MidiManager.h
//  Duckhunt
//
//  Created by Joe Andolina on 8/24/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>
#import "PGMidi.h"

@interface MidiManager : NSObject<PGMidiDelegate, PGMidiSourceDelegate>

@property MIDIEndpointRef destination;
@property MIDIEndpointRef source;

+ (instancetype)sharedManager;


@end
