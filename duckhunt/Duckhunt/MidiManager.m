//
//  MidiManager.m
//  Duckhunt
//
//  Created by Joe Andolina on 8/24/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <CoreMIDI/CoreMIDI.h>

#import "MidiManager.h"
#import "PGMidi.h"
#import "ConnectionManager.h"

@implementation MidiManager
{
    PGMidi *midi;
}

+ (id)sharedManager {
    static MidiManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    if (self = [super init])
    {
        midi = [[PGMidi alloc] init];
        midi.networkEnabled             = NO;
        midi.virtualDestinationEnabled  = NO;
        midi.virtualSourceEnabled       = NO;
        
        midi.delegate = self;
        [self attachToAllExistingSources];
    }
    return self;
}

#pragma  mark - PGMidi

- (void) attachToAllExistingSources
{
    for (PGMidiSource *source in midi.sources)
    {
        [source addDelegate:self];
    }
}

- (void) setMidi:(PGMidi*)m
{
    midi.delegate = nil;
    midi = m;
    midi.delegate = self;
    
    [self attachToAllExistingSources];
}

#pragma  mark - PGMidi

- (void) midi:(PGMidi*)midi sourceAdded:(PGMidiSource *)source
{
    [source addDelegate:self];
    NSLog(@"Source added: %@", source.name);
}

- (void) midi:(PGMidi*)midi sourceRemoved:(PGMidiSource *)source
{
    NSLog(@"Source removed: %@", source.name);
}

- (void) midi:(PGMidi*)midi destinationAdded:(PGMidiDestination *)destination
{
    NSLog(@"Destination added: %@", destination.name);
}

- (void) midi:(PGMidi*)midi destinationRemoved:(PGMidiDestination *)destination
{
    NSLog(@"Destination removed: %@", destination.name);
}

-(NSString*)stringFromPacket:(const MIDIPacket *)packet
{
    int i = packet->data[2];
    NSLog( @"int %d", i);
    
    //[[PlayerManager sharedManager] connectPlayer:model.player1];
    
    // Note - this is not an example of MIDI parsing. I'm just dumping
    // some bytes for diagnostics.
    // See comments in PGMidiSourceDelegate for an example of how to
    // interpret the MIDIPacket structure.
    return [NSString stringWithFormat:@"  %u bytes: [%02x,%02x,%02x]",
            packet->length,
            (packet->length > 0) ? packet->data[0] : 0,
            (packet->length > 1) ? packet->data[1] : 0,
            (packet->length > 2) ? packet->data[2] : 0
            ];
}

- (void)midiSource:(PGMidiSource*)midi midiReceived:(const MIDIPacketList *)packetList
{
    NSLog(@"MIDI received");
    
    const MIDIPacket *packet = &packetList->packet[0];
    for (int i = 0; i < packetList->numPackets; ++i)
    {
        // NOTE : BE SURE TO UPDATE ON THE MAIN THREAD
        NSLog(@"Packet: %@", [self stringFromPacket:packet]);
        packet = MIDIPacketNext(packet);
    }
    
    [self sendMidiDataInBackground];
}

-(void)sendMidiDataInBackground
{
    const UInt8 note      = 0x29;
    const UInt8 noteOn[]  = { 0xbf, note, 0x7f };
    const UInt8 noteOff[] = { 0x80, note, 0 };
    
    [midi sendBytes:noteOn size:sizeof(noteOn)];
    //[NSThread sleepForTimeInterval:0.5];
    //[midi sendBytes:noteOff size:sizeof(noteOff)];
}


@end

