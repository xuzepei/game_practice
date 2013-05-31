//
//  RCJoyStickScene.m
//  RCGame
//
//  Created by xuzepei on 5/31/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCJoyStickScene.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedJoystickExample.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredCircleSprite.h"


static RCJoyStickScene* sharedInstance = nil;
@implementation RCJoyStickScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCJoyStickScene* layer = [RCJoyStickScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCJoyStickScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        sharedInstance = self;
        self.isTouchEnabled = YES;
        CGSize winSize = WIN_SIZE;
        
        SneakyJoystickSkinnedBase* temp = [[SneakyJoystickSkinnedBase alloc] init];
		temp.position = ccp(64,64);
		temp.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:64];
		temp.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 200) radius:32];
		temp.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)];
		_leftJoyStick = temp.joystick;
		[self addChild:temp];
		
		SneakyButtonSkinnedBase *temp0 = [[SneakyButtonSkinnedBase alloc] init];
		temp0.position = ccp(256,32);
		temp0.defaultSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 128) radius:32];
		temp0.activatedSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 255) radius:32];
		temp0.pressSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 255) radius:32];
		temp0.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
		_rightButton = temp0.button;
		_rightButton.isToggleable = YES;
		[self addChild:temp0];
		
		//[[CCDirector sharedDirector] setAnimationInterval:1.0f/60.0f];
    }
    
    return self;
}

- (void)dealloc
{
    self.leftJoyStick = nil;
    self.rightButton = nil;
    sharedInstance = nil;
    [super dealloc];
}

@end
