//
//  AdminViewController.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "AdminViewController.h"
#import "PlayerManager.h"

#import "AppDelegate.h"
#import "ApplicationModel.h"


@implementation AdminViewController
{
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    CGPoint p4;
    
    CGPoint lastClick;
    NSClickGestureRecognizer *shot;
    
    NSMutableArray *points;
    
    ApplicationModel *model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    model = [ApplicationModel sharedModel];
    model.player1.delegate = self;
    model.player2.delegate = self;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConnect:) name:@"playerConnected" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDisconnect:) name:@"playerDisconnected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTimeout:) name:@"playerTimout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDefaults:) name:@"defaultsLoaded" object:nil];
}

-(void)viewDidAppear
{
    [super viewDidAppear];

    [self handleDefaults:nil];
}


-(void)handleShot:(NSGestureRecognizer*)recognizer
{
    NSPoint location;// = [recognizer locationInView:self.cameraView];
    
    if( lastClick.x == location.x && lastClick.y == location.y )
    {
        return;
    }
    
    lastClick = location;
    
    if( [ApplicationModel sharedModel].appState == ArenaState )
    {
        [self handleArenaShot:location];
    }
    
    if( [ApplicationModel sharedModel].appState == CalibrationState )
    {
        [self handleCalibrationShot:location];
    }
    
    if( [ApplicationModel sharedModel].appState == LobbyState )
    {
    //   [[NSNotificationCenter defaultCenter] postNotificationName:@"handleLobbyShot" object:nil userInfo:@{@"point":point}];
    }
}

-(void)handleArenaShot:(NSPoint)location
{
    location = [self getCalibratedPoint:location];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleArenaShot"
                                                        object:nil userInfo:@{@"point":[NSValue valueWithPoint:location],
                                                                              @"player":[NSNumber numberWithInt:1]}
     ];
}


-(void)handleCalibrationShot:(NSPoint)location
{
    [points addObject:[NSValue valueWithPoint:location]];
    NSView *tmpView = [[NSView alloc] initWithFrame:NSMakeRect(location.x-2.5, location.y-2.5, 5, 5)];
    [tmpView setWantsLayer:YES];
    tmpView.layer.backgroundColor = [NSColor greenColor].CGColor;
    
    if(points.count < 4)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"handleCalibrationShot" object:nil];
    }
    else
    {
        [ApplicationModel sharedModel].calibrationPoints = points;
        p1 = [points[0] pointValue];
        p2 = [points[1] pointValue];
        p3 = [points[2] pointValue];
        p4 = [points[3] pointValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLobby" object:nil];
    }
    
}

- (IBAction)handleAdd:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"spawnDuck" object:nil];
}

     /*
- (IBAction)handleBluetooth:(id)sender
{
    NSViewController *viewController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"BluetoothController"];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
}
      */



/*
-(NSPoint)getCalibratedPoint:(NSPoint)point
{
    NSLog(@"%f : %f", point.x, point.y);
    double C = (double)(p1.y - point.y) * (p4.x - point.x) - (double)(p1.x - point.x) * (p4.y - point.y);
    double B = (double)(p1.y - point.y) * (p3.x - p4.x) + (double)(p2.y - p1.y) * (p4.x - point.x) - (double)(p1.x - point.x) * (p3.y - p4.y) - (double)(p2.x - p1.x) * (p4.y - point.y);
    double A = (double)(p2.y - p1.y) * (p3.x - p4.x) - (double)(p2.x - p1.x) * (p3.y - p4.y);
    
    double D = B * B - 4 * A * C;
    
    //double u = (-B - sqrt(D)) / (2 * A);
    point.x = (-B - sqrt(D)) / (2 * A);
    
    double p1x = p1.x + (p2.x - p1.x) * point.x;
    double p2x = p4.x + (p3.x - p4.x) * point.x;
    double px = point.x;
    
    //double v = (px - p1x) / (p2x - p1x);
    point.y = (px - p1x) / (p2x - p1x);
    NSLog(@"%f : %f", point.x, point.y);
    return point;
}
 */

/*
int main(int argc, const char * argv[])
{
    
    using namespace cv;
    Mat im;
    
    // Read image
    im = imread( "media/blobs.png", IMREAD_GRAYSCALE );
    if(im.empty())
    {
        fprintf(stderr,"Failed to load input file");
        return -2;
    }

    // Set up the detector with default parameters.
    SimpleBlobDetector::Params params;
    params.blobColor = 255;
    params.filterByColor		= true;
    params.filterByArea			= false;
    params.minArea				= 10;
    params.maxArea				= 1000;
    params.filterByConvexity	= false;
    params.filterByInertia		= false;
    
    SimpleBlobDetector detector(params);
    
    // Detect blobs.
    std::vector<KeyPoint> keypoints;
    bool success = cap.read(im);
    int frame_num = 0;
    Mat im_with_keypoints;
    while(success)
    {
        threshold(im, im, 40, 255.0, CV_THRESH_BINARY);
        detector.detect( im, keypoints);
        
        // Draw detected blobs as red circles.
        // DrawMatchesFlags::DRAW_RICH_KEYPOINTS flag ensures the size of the circle corresponds to the size of blob
        drawKeypoints( im, keypoints, im_with_keypoints, Scalar(0,0,255), DrawMatchesFlags::DRAW_RICH_KEYPOINTS );
        putText(im_with_keypoints, strprintf("Frame: %04i", frame_num), Point(0,20), FONT_HERSHEY_SIMPLEX, 0.5, Scalar(0,255,0));
        putText(im_with_keypoints, strprintf("#points: %i", keypoints.size()), Point(150,20), FONT_HERSHEY_SIMPLEX, 0.5, Scalar(255,255,0));
        printf("\nNumber of keypoints: %zu\n", keypoints.size());
        for(int i=0; i<keypoints.size(); ++i)
        {
            string str = strprintf("(%.1f,%.1f)",keypoints[i].pt.x, keypoints[i].pt.y);
            printf("\tkp_%i: %s\n",i, str.c_str());
            Size size = getTextSize(str, FONT_HERSHEY_SIMPLEX, 0.3,1, NULL);
            putText(im_with_keypoints, str, keypoints[i].pt-Point2f(size.width/2,10), FONT_HERSHEY_SIMPLEX, 0.3, Scalar(0,255,255));
        }
        
        // Show blobs
        imshow("keypoints", im_with_keypoints );
        
        // write to video
        //writer.write(im_with_keypoints);
        
        frame_num++;
        success = cap.read(im); // read next frame
        int key = waitKey(10); // allows time for UI thread
        success = success && key != 27;
    } // while
    
    //	writer.release();
    //	cap.release();
    // wait for keypress to end program
    //	waitKey(0);
    
    printf("Done processing %i frames\n", frame_num);
    
    return 0;
}
*/

-(CGPoint)getCalibratedPoint:(CGPoint)point
{
    double C = (p1.y - point.y) * (p4.x - point.x) - (p1.x - point.x) * (p4.y - point.y);
    double B = (p1.y - point.y) * (p3.x - p4.x) + (p2.y - p1.y) * (p4.x - point.x) - (p1.x - point.x) * (p3.y - p4.y) - (p2.x - p1.x) * (p4.y - point.y);
    double A = (p2.y - p1.y) * (p3.x - p4.x) - (p2.x - p1.x) * (p3.y - p4.y);
    
    double D = B * B - 4 * A * C;
    
    // u is what you'd normally call x, normalized between 0 and 1. See: http://en.wikipedia.org/wiki/UV_mapping
    double u = (-B + sqrt(D)) / (2 * A);
    if (u < 0 || u > 1) {
        // use the other quadratic root
        u = (-B - sqrt(D)) / (2 * A);
    }
    
    double p1x = p1.x + (p2.x - p1.x) * u;
    double p2x = p4.x + (p3.x - p4.x) * u;
    double px = point.x;
    
    // v is what you'd normally call y, normalized between 0 and 1. See: http://en.wikipedia.org/wiki/UV_mapping
    double v = (px - p1x) / (p2x - p1x);
    
    int screenX = 0;//(int) round(u * kScreenWidth);
    int screenY = 0;//(int) round((1-v) * kScreenHeight);
    
    NSLog(@"Output %d : %d", screenX, screenY);
    return CGPointMake(screenX, screenY);
}






#pragma mark - Gameplay Options
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    if( [tabViewItem.identifier isEqualToString:@"1"] )
    {
        [model.props saveDefaults];
    }
}

- (IBAction)handleFPS:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleFPS" object:nil];
}

- (IBAction)handleGameScale:(id)sender
{
    [model.props setGameScale:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleGameSpeed:(id)sender
{
    CGFloat value = 1.1 - [(NSSlider*)sender floatValue];
    NSLog(@"Value %f", value);
    [model.props setGameSpeed:value];
}

- (IBAction)handleGameGlitch:(id)sender
{
    [model.props setGameGlitch:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDifficulty:(id)sender
{
}

- (IBAction)handleRounds:(id)sender
{
}

- (IBAction)handleAmmo:(id)sender
{
}

- (IBAction)handleStop:(id)sender
{
    self.goButton.enabled = YES;
    self.stopButton.enabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLobby" object:nil];
}

- (IBAction)handleGo:(id)sender
{
    self.goButton.enabled = NO;
    self.stopButton.enabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showArena" object:nil];
}

#pragma mark - Player Options

- (IBAction)resetOptions:(id)sender
{
    [model.props resetDefaults];
}

- (IBAction)resetP1Offset:(id)sender
{
    self.p1SliderX.floatValue = 0;
    self.p1SliderY.floatValue = 0;
    self.p1Sensitivity.selectedSegment = 2;
    
    model.props.playerSensitivity1 = 2;
    model.props.playerOffset1 = NSMakePoint(0,0);
}

- (IBAction)resetP2Offset:(id)sender
{
    self.p2SliderX.floatValue = 0;
    self.p2SliderY.floatValue = 0;
    self.p2Sensitivity.selectedSegment = 2;
    
    model.props.playerSensitivity2 = 2;
    model.props.playerOffset2 = NSMakePoint(0,0);
}

- (IBAction)handleP1Sensitivity:(id)sender
{
    model.props.playerSensitivity1 = [(NSSegmentedControl*)sender selectedSegment];
}

- (IBAction)handleP2Sensitivity:(id)sender
{
    model.props.playerSensitivity2 = [(NSSegmentedControl*)sender selectedSegment];
}


- (IBAction)handleP1Calibrate:(id)sender
{
    self.p1SliderX.enabled = !self.p1SliderX.enabled;
    self.p1SliderY.enabled = !self.p1SliderY.enabled;
    
    if( self.p1SliderX.enabled )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCalibrationTarget" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideCalibrationTarget" object:nil];
    }
}

- (IBAction)handleP1OffestX:(id)sender
{
    model.props.playerOffset1 = NSMakePoint([(NSSlider*)sender floatValue],model.props.playerOffset1.y);
}


- (IBAction)handleP1OffestY:(id)sender
{
    model.props.playerOffset1 = NSMakePoint(model.props.playerOffset1.x, [(NSSlider*)sender floatValue]);
}

- (IBAction)handleP2Calibrate:(id)sender
{
    self.p2SliderX.enabled = !self.p2SliderX.enabled;
    self.p2SliderY.enabled = !self.p2SliderY.enabled;
    
    if( self.p2SliderX.enabled )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCalibrationTarget" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideCalibrationTarget" object:nil];
    }
}

- (IBAction)handleP2OffestX:(id)sender
{
    model.props.playerOffset2 = NSMakePoint([(NSSlider*)sender floatValue],model.props.playerOffset2.y);
}


- (IBAction)handleP2OffestY:(id)sender
{
    model.props.playerOffset2 = NSMakePoint(model.props.playerOffset2.x, [(NSSlider*)sender floatValue]);
}


- (IBAction)handleP1Search:(id)sender
{
    self.p1Connect.enabled = NO;
    self.p2Connect.enabled = NO;
    
    [self.p1Progress startAnimation:self];
    [[PlayerManager sharedManager] connectPlayer:model.player1];
}

- (IBAction)handleP2Search:(id)sender
{
    self.p1Connect.enabled = NO;
    self.p2Connect.enabled = NO;
    
    [self.p2Progress startAnimation:self];
    [[PlayerManager sharedManager] connectPlayer:model.player2];
}

#pragma mark - Duck Options

- (IBAction)handleDuck1Speed:(id)sender
{
    [model.props setDuck1Speed:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck1Min:(id)sender
{
    [model.props setDuck1Min:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck1Max:(id)sender
{
    [model.props setDuck1Max:[(NSSlider*)sender floatValue]];
}


- (IBAction)handleDuck2Speed:(id)sender
{
    [model.props setDuck2Speed:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck2Min:(id)sender
{
    [model.props setDuck2Min:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck2Max:(id)sender
{
    [model.props setDuck2Max:[(NSSlider*)sender floatValue]];
}


- (IBAction)handleDuck3Speed:(id)sender
{
    [model.props setDuck3Speed:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck3Min:(id)sender
{
    [model.props setDuck3Min:[(NSSlider*)sender floatValue]];
}

- (IBAction)handleDuck3Max:(id)sender
{
    [model.props setDuck3Max:[(NSSlider*)sender floatValue]];
}

#pragma mark - Update ui to reflect defaults

-(void)handleDefaults:(NSNotification*)notification
{
    // Player 1
    [self.p1Sensitivity setSelected:YES forSegment:model.props.playerSensitivity1];
    [self.p1SliderX setFloatValue:model.props.playerOffset1.x];
    [self.p1SliderY setFloatValue:model.props.playerOffset1.y];

    // Player 2
    [self.p2Sensitivity setSelected:YES forSegment:model.props.playerSensitivity2];
    [self.p2SliderX setFloatValue:model.props.playerOffset2.x];
    [self.p2SliderY setFloatValue:model.props.playerOffset2.y];

    // Gmeplay
    [self.gameScale setFloatValue:model.props.gameScale];
    [self.gameSpeed setFloatValue:model.props.gameSpeed];
    [self.gameGlitch setFloatValue:model.props.gameGlitch];
    
    // Ducks
    [self.duck1Speed setFloatValue:model.props.duck1Speed];
    [self.duck1Min setFloatValue:model.props.duck1Min];
    [self.duck1Max setFloatValue:model.props.duck1Max];
    
    [self.duck2Speed setFloatValue:model.props.duck2Speed];
    [self.duck2Min setFloatValue:model.props.duck2Min];
    [self.duck2Max setFloatValue:model.props.duck2Max];
    
    [self.duck3Speed setFloatValue:model.props.duck3Speed];
    [self.duck3Min setFloatValue:model.props.duck3Min];
    [self.duck3Max setFloatValue:model.props.duck3Max];
}

#pragma mark - wiimote connection

-(void)playerConnect:(PlayerController*)player
{
    if( player == model.player1 )
    {
        self.p1Connect.title = @"Connected";
        self.p2Connect.enabled = !model.player2.connected;;
        
        self.p1Reset.enabled = YES;
        self.p1Calibrate.enabled = YES;
        self.p1Sensitivity.enabled = YES;
        [self.p1Progress stopAnimation:self];
    }
    else
    {
        self.p1Connect.enabled = !model.player1.connected;
        self.p2Connect.title = @"Connected";
        
        self.p2Reset.enabled = YES;
        self.p2Calibrate.enabled = YES;
        self.p2Sensitivity.enabled = YES;
        [self.p2Progress stopAnimation:self];
    }
}

-(void)playerDisconnect:(PlayerController*)player
{
    if( player == model.player1 )
    {
        self.p1Connect.title = @"Connect";
        self.p1Connect.enabled = YES;
        self.p1Calibrate.enabled = NO;
        self.p1SliderX.enabled = NO;
        self.p1SliderY.enabled = NO;
        self.p1Reset.enabled = NO;
        self.p1Sensitivity.enabled = NO;
        [self.p1Battery setDoubleValue:0.0];
    }
    else
    {
        self.p2Connect.title = @"Connect";
        self.p2Connect.enabled = YES;
        self.p2Calibrate.enabled = NO;
        self.p2SliderX.enabled = NO;
        self.p2SliderY.enabled = NO;
        self.p2Reset.enabled = NO;
        self.p2Sensitivity.enabled = NO;
        [self.p2Battery setDoubleValue:0.0];
    }
}

-(void)handleTimeout:(NSNotification*)notification
{
    self.p1Connect.enabled = !model.player1.connected;
    self.p2Connect.enabled = !model.player2.connected;
    
    [self.p1Progress stopAnimation:self];
    [self.p2Progress stopAnimation:self];
}

-(void)playerBattery:(PlayerController*)player
{
    if( player == model.player1 )
    {
        [self.p1Battery setDoubleValue:model.player1.level * 10.0];
    }
    
    else
    {
        [self.p2Battery setDoubleValue:model.player2.level * 10.0];
    }
}


@end
