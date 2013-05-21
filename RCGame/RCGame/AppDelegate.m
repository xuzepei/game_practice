//
//  AppDelegate.m
//  RCGame
//
//  Created by xuzepei on 9/18/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "RCLoadingLayer.h"
#import "HelloWorldLayer.h"
#import "RCGameScene.h"
#import "RCMultiLayerScene.h"
#import "RCEarthLayer.h"
#import "RCEarthScene.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:YES];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
    
    //[director_ enableRetinaDisplay:NO];
    
    //[director_ enableRetinaDisplay:NO];
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:YES];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"@2x"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

//    [self initEarthViewController];
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
//	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
    
    
    //Hello World
	//[director_ runWithScene: [RCLoadingLayer goToScene:ST_HELLOWORLD]];
    
    //Shoot Game 投掷飞镖动作
    //[director_ runWithScene:[RCLoadingLayer goToScene:ST_SHOOTGAME]];
    
    //Bear Game
    //[director_ runWithScene:[RCLoadingLayer goToScene:ST_BEARGAME]];
    
    //Drag Game
    [director_ runWithScene:[RCLoadingLayer goToScene:ST_DRAGGAME]]
    
    //DoodleDrop Game
    //[director_ runWithScene:[RCLoadingLayer goToScene:ST_DOODLEDROP]];
    
    //RCMultiLayerScene
    //[director_ runWithScene:[RCLoadingLayer goToScene:ST_MULTILAYER]];
    
    //Earth
//    CC3Layer* earthLayer = [RCEarthLayer node];
//    earthLayer.cc3Scene = [RCEarthScene scene];
//    [self.earthViewController runSceneOnNode: earthLayer];
    
    //RCParallaxScene
    //[director_ runWithScene:[RCLoadingLayer goToScene:ST_PARALLAX]];
    
    //RCShipGameScene
    //[director_ runWithScene:[RCLoadingLayer goToScene:ST_SHIPGAMESCENE]];
	
	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //处理内存警告
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
    self.earthViewController = nil;
    
	[window_ release];
	[navController_ release];

	[super dealloc];
}

#pragma mark Earth View Controller

- (void)initEarthViewController
{
    if(nil == _earthViewController)
    {
        _earthViewController = CC3DeviceCameraOverlayUIViewController.sharedDirector;
        _earthViewController.supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
        _earthViewController.viewShouldUseStencilBuffer = NO;		// Set to YES if using shadow volumes
        _earthViewController.viewPixelSamples = 1;					// Set to 4 for antialiasing multisampling
        _earthViewController.animationInterval = (1.0f / 60);
        _earthViewController.displayStats = YES;
        [_earthViewController enableRetinaDisplay: YES];
    }
}

@end

