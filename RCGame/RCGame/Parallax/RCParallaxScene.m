//
//  RCParallaxScene.m
//  RCGame
//
//  Created by xuzepei on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCParallaxScene.h"
#import "RCMultiLayerScene.h"


@implementation RCParallaxScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCParallaxScene* layer = [RCParallaxScene node];
    [scene addChild:layer];
    return scene;
}

- (id)init
{
    if(self = [super init])
    {
        CCLayerColor* bgLayer = [CCLayerColor layerWithColor:ccc4(255, 0, 255, 255)];
        [self addChild:bgLayer z:0];
        
        CGSize screenSize = WIN_SIZE;
        
        CCSprite* sprite1 = [CCSprite spriteWithFile:@"parallax1.png"];
        
        CCSprite* sprite2 = [CCSprite spriteWithFile:@"parallax2.png"];

        CCSprite* sprite3 = [CCSprite spriteWithFile:@"parallax3.png"];

        CCSprite* sprite4 = [CCSprite spriteWithFile:@"parallax4.png"];
        
        
        // Set the correct offsets depending on the screen and image sizes.
		sprite1.anchorPoint = CGPointMake(0, 1);
		sprite2.anchorPoint = CGPointMake(0, 1);
		sprite3.anchorPoint = CGPointMake(0, 0.6f);
		sprite4.anchorPoint = CGPointMake(0, 0);
		CGPoint topOffset = CGPointMake(0, screenSize.height);
		CGPoint midOffset = CGPointMake(0, screenSize.height / 2);
		CGPoint downOffset = CGPointZero;
        
		// Create a parallax node and add the sprites to it.
		CCParallaxNode* paraNode = [CCParallaxNode node];
		[paraNode addChild:sprite1 z:1 parallaxRatio:CGPointMake(0.5f, 0) positionOffset:topOffset];
		[paraNode addChild:sprite2 z:2 parallaxRatio:CGPointMake(1, 0) positionOffset:topOffset];
		[paraNode addChild:sprite3 z:4 parallaxRatio:CGPointMake(2, 0) positionOffset:midOffset];
		[paraNode addChild:sprite4 z:3 parallaxRatio:CGPointMake(3, 0) positionOffset:downOffset];
		[self addChild:paraNode z:0 tag:PNT_TAG1];
        
		// Move the parallax node to show the parallaxing effect.
		CCMoveBy* move1 = [CCMoveBy actionWithDuration:5 position:CGPointMake(-160, 0)];
		CCMoveBy* move2 = [CCMoveBy actionWithDuration:15 position:CGPointMake(160, 0)];
		CCSequence* sequence = [CCSequence actions:move1, move2, nil];
		CCRepeatForever* repeat = [CCRepeatForever actionWithAction:sequence];
		[paraNode runAction:repeat];
        
        
        self.isTouchEnabled = YES;

		[self resetMotionStreak];

    }
    
    return self;
}

- (void)dealloc
{
    [[DIRECTOR touchDispatcher] removeDelegate:self];
    
    [super dealloc];
}

- (void)registerWithTouchDispatcher
{
	[[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)resetMotionStreak
{
	// Removes the ribbon and creates a new one.
	[self removeChildByTag:PNT_TAG2 cleanup:YES];
    
	CCMotionStreak* streak = [CCMotionStreak streakWithFade:0.7f
                                                     minSeg:10 width:6
                                            color:ccc3(255, 0, 255)
                                textureFilename:@"streak.png"];

    [self addChild:streak z:5 tag:PNT_TAG2];
}

- (CCMotionStreak*)getMotionStreak
{
	CCNode* node = [self getChildByTag:PNT_TAG2];
	NSAssert([node isKindOfClass:[CCMotionStreak class]], @"node is not a CCMotionStreak");
	
	return (CCMotionStreak*)node;
}

- (void)addMotionStreakPoint:(CGPoint)point
{
	CCMotionStreak* streak = [self getMotionStreak];
    [streak setPosition:point];
}

- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
	[self addMotionStreakPoint:[RCMultiLayerScene locationFromTouch:touch]];
	
	// Always swallow touches.
	return YES;
}

- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event
{
	[self addMotionStreakPoint:[RCMultiLayerScene locationFromTouch:touch]];
}

- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event
{
	[self resetMotionStreak];
}

@end
