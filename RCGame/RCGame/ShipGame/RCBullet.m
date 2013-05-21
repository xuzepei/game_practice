//
//  RCBullet.m
//  RCGame
//
//  Created by xuzepei on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCBullet.h"
#import "RCShip.h"

@implementation RCBullet

@synthesize velocity;

+(id) bullet
{
	return [[[self alloc] initWithBulletImage] autorelease];
}

-(id) initWithBulletImage
{
	// Uses the Texture Atlas now.
	if ((self = [super initWithSpriteFrameName:@"bullet.png"]))
	{
	}
	
	return self;
}

// Re-Uses the bullet
-(void) shootBulletFromShip:(RCShip*)ship
{
    // create a random angle and calculate and use
    // it so that not all bullets float in one line
    // the velocity is in pixels / second
    float spread = (CCRANDOM_0_1() - 0.5f) * 0.5f;
    velocity = CGPointMake(100, spread*100);
	
    // remember the right border of the screen
    // we use this to remove the bullet from the scene
    outsideScreen = [[CCDirector sharedDirector] winSize].width;
    
    // set the start position of the bullet
    // which is in the lower part of the ship
    self.position = CGPointMake(ship.position.x + 45, ship.position.y - 19);
    self.visible = YES;
	
    // stop "update" in case we reuse the bullet
    [self unscheduleUpdate];
    
    // run "update" with every frame redraw
    [self scheduleUpdate];
}

-(void) update:(ccTime)delta
{
    // update position of the bullet
    // multiply the velocity by the time since the last update was called
    // this ensures same bullet velocity even if frame rate drops
	self.position = ccpAdd(self.position, ccpMult(velocity, delta));
	
    // delete the bullet if it leaves the screen
	if (self.position.x > outsideScreen)
	{
		self.visible = NO;
		[self unscheduleUpdate];
	}
}

@end
