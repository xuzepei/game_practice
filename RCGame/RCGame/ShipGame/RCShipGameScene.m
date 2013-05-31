//
//  RCShipGameScene.m
//  RCGame
//
//  Created by xuzepei on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCShipGameScene.h"
#import "RCShip.h"
#import "RCBullet.h"
#import "RCParallaxBackground.h"

static RCShipGameScene* sharedInstance = nil;
@implementation RCShipGameScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCShipGameScene* layer = [RCShipGameScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCShipGameScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        sharedInstance = self;
        CGSize screenSize = WIN_SIZE;
        
        // Load all of the game's artwork up front.
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"game-art.plist"];

        //添加背景
        RCParallaxBackground* parallaxbg = [RCParallaxBackground node];
		[self addChild:parallaxbg z:-1];
        
        RCShip* ship = [RCShip ship];
		ship.position = CGPointMake(80, screenSize.height / 2);
		[self addChild:ship z:10];
        
        // Now uses the image from the Texture Atlas.
		CCSpriteFrame* bulletFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bullet.png"];
		CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithTexture:bulletFrame.texture];
		[self addChild:batch z:1 tag:GameSceneNodeTagBulletSpriteBatch];
        
		// Create a number of bullets up front and re-use them whenever necessary.
		for (int i = 0; i < 400; i++)
		{
			RCBullet* bullet = [RCBullet bullet];
			bullet.visible = NO;
			[batch addChild:bullet];
		}
		
		// call bullet countrer from time to time
		[self schedule:@selector(countBullets:) interval:3];
        
    }
    
    return self;
}

- (void)dealloc
{
    sharedInstance = nil;
    
    [super dealloc];
}


-(void) countBullets:(ccTime)delta
{
	CCLOG(@"Number of active Bullets: %i", [self.bulletSpriteBatch.children count]);
}

- (CCSpriteBatchNode*)bulletSpriteBatch
{
	CCNode* node = [self getChildByTag:GameSceneNodeTagBulletSpriteBatch];
	NSAssert([node isKindOfClass:[CCSpriteBatchNode class]], @"not a CCSpriteBatchNode");
	return (CCSpriteBatchNode*)node;
}

- (void)shootBulletFromShip:(RCShip*)ship
{
	CCArray* bullets = [self.bulletSpriteBatch children];
	
	CCNode* node = [bullets objectAtIndex:self.nextInactiveBullet];
	NSAssert([node isKindOfClass:[RCBullet class]], @"not a bullet!");
	
	RCBullet* bullet = (RCBullet*)node;
	[bullet shootBulletFromShip:ship];
	
	self.nextInactiveBullet++;
	if (self.nextInactiveBullet >= [bullets count])
	{
		self.nextInactiveBullet = 0;
	}
}

@end
