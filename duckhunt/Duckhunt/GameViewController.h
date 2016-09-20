//
//  ViewController.h
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface GameViewController : NSViewController

@property (weak) IBOutlet NSImageView *lobbyImage;
@property (weak) IBOutlet SKView *spriteView;

@end

