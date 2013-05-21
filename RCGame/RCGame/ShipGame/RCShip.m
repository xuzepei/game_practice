//
//  RCShip.m
//  RCGame
//
//  Created by xuzepei on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCShip.h"
#import "RCBullet.h"
#import "RCShipGameScene.h"
#import "CCAnimation+Helper.h"

@implementation RCShip

+ (id)ship
{
	return [[[self alloc] initWithShipImage] autorelease];
}

- (id)initWithShipImage
{
    // Loading the Ship's sprite using a sprite frame name (eg the filename)
	if ((self = [super initWithSpriteFrameName:@"ship.png"]))
	{
		// create an animation object from all the sprite animation frames
		CCAnimation* anim = [CCAnimation animationWithFrame:@"ship-anim" frameCount:5 delay:0.08f];
		
		// run the animation by using the CCAnimate action
		CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
		CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
		[self runAction:repeat];
		
        // call "update" for every frame
		[self scheduleUpdate];
	}
	return self;
}

- (void)update:(ccTime)delta
{
	// Shooting is relayed to the game scene
	[[RCShipGameScene sharedInstance] shootBulletFromShip:self];
}

@end
