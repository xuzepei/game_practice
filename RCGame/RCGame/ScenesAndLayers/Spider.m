//
//  Spider.m
//  RCGame
//
//  Created by xuzepei on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Spider.h"
#import "RCMultiLayerScene.h"

@implementation Spider

- (void)dealloc
{
    [[DIRECTOR touchDispatcher] removeDelegate:self];
    self.spiderSprite = nil;
    
    [super dealloc];
}

+ (id)spiderWithParentNode:(CCNode*)parentNode
{
    return [[[self alloc] initWithParentNode:parentNode] autorelease];
}

- (id)initWithParentNode:(CCNode*)parentNode
{
    if((self = [super init]) && parentNode)
    {
        [parentNode addChild: self];
        
        CGSize screenSize = WIN_SIZE;
        
		self.spiderSprite = [CCSprite spriteWithFile:@"spider@2x.png"];
        
		self.spiderSprite.position = CGPointMake(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height);
        
		[self addChild:self.spiderSprite];
        
		[self scheduleUpdate];
//        [self schedule:@selector(updatePerSecond:) interval:50/60.0];
        
        [[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
        
        return self;
    }
    
    return nil;
}

- (void)moveAway:(float)duration position:(CGPoint)moveTo
{
	[self.spiderSprite stopAllActions];
    
	CCMoveBy* move = [CCMoveBy actionWithDuration:duration position:moveTo];
	[self.spiderSprite runAction:move];
}

- (void)update:(ccTime)delta
{
	self.numUpdates++;
    
	if(self.numUpdates > 50)
	{
		self.numUpdates = 0;
		
		// Move at regular speed.
		CGPoint moveTo = CGPointMake(CCRANDOM_0_1() * 200 - 100, CCRANDOM_0_1() * 100 - 50);
		[self moveAway:2 position:moveTo];
	}
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [RCMultiLayerScene locationFromTouch:touch];
	
	// Check if this touch is on the Spider's sprite.
	BOOL isTouchHandled = CGRectContainsPoint([self.spiderSprite boundingBox], touchLocation);
	if(isTouchHandled)
	{
		// Reset move counter.
		self.numUpdates = 0;
		
		// Move away from touch loation rapidly.
		CGPoint moveTo;
		float moveDistance = 60;
		float rand = CCRANDOM_0_1();
        
		// Randomly pick one of four corners to move away to.
		if (rand < 0.25f)
			moveTo = CGPointMake(moveDistance, moveDistance);
		else if (rand < 0.5f)
			moveTo = CGPointMake(-moveDistance, moveDistance);
		else if (rand < 0.75f)
			moveTo = CGPointMake(moveDistance, -moveDistance);
		else
			moveTo = CGPointMake(-moveDistance, -moveDistance);
		
		[self moveAway:0.1f position:moveTo];
	}
    
	return isTouchHandled;
}

@end
