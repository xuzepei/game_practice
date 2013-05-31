//
//  RCParallaxBackground.m
//  RCGame
//
//  Created by xuzepei on 5/31/13.
//
//

#import "RCParallaxBackground.h"

@implementation RCParallaxBackground

- (id)init
{
    if(self = [super init])
    {
        _screenSize = WIN_SIZE;
        
        CCSpriteFrame* bulletFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bullet.png"];
		self.batch = [CCSpriteBatchNode batchNodeWithTexture:bulletFrame.texture];
        [self addChild:self.batch];
        
        _spritesNum = 7;
        
        for(int i = 0; i < _spritesNum; i++)
		{
			NSString* frameName = [NSString stringWithFormat:@"bg%i.png", i];
			CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:frameName];
			sprite.anchorPoint = CGPointMake(0, 0.5);
			sprite.position = CGPointMake(0, _screenSize.height / 2);
			[self.batch addChild:sprite z:i tag:i];
		}
        
        
        for(int i = 0; i < _spritesNum; i++)
		{
			NSString* frameName = [NSString stringWithFormat:@"bg%i.png", i];
			CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:frameName];
			
			// Position the new sprite one screen width to the right
			sprite.anchorPoint = CGPointMake(0, 0.5);
			sprite.position = CGPointMake(_screenSize.width - 1, _screenSize.height / 2);
            
			// Flip the sprite so that it aligns perfectly with its neighbor
			sprite.flipX = YES;
			
			// Add the sprite using the same tag offset by numStripes
			[self.batch addChild:sprite z:i tag:i + _spritesNum];
		}
        
        
        // Initialize the array that contains the scroll factors for individual stripes.
		_speedFactors = [[CCArray alloc] initWithCapacity:_spritesNum];
		[_speedFactors addObject:[NSNumber numberWithFloat:0.1f]];
		[_speedFactors addObject:[NSNumber numberWithFloat:0.3f]];
		[_speedFactors addObject:[NSNumber numberWithFloat:0.3f]];
		[_speedFactors addObject:[NSNumber numberWithFloat:0.5f]];
		[_speedFactors addObject:[NSNumber numberWithFloat:0.5f]];
		[_speedFactors addObject:[NSNumber numberWithFloat:0.9f]];
		[_speedFactors addObject:[NSNumber numberWithFloat:0.9f]];
		NSAssert([_speedFactors count] == _spritesNum, @"speedFactors count does not match numStripes!");
        
		_scrollSpeed = 1.0f;
		[self scheduleUpdate];
    }
    
    return self;
}

- (void)dealloc
{
    self.batch = nil;
    self.speedFactors = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)delta
{
	CCSprite* sprite;
	CCARRAY_FOREACH([self.batch children], sprite)
	{
		//CCLOG(@"tag: %i", sprite.tag);
		NSNumber* factor = [_speedFactors objectAtIndex:sprite.zOrder];
		
		CGPoint pos = sprite.position;
		pos.x -= _scrollSpeed * [factor floatValue];
		
		// Reposition stripes when they're out of bounds
//		if (pos.x < -_screenSize.width)
//		{
//			pos.x += (_screenSize.width * 2) - 2;
//		}
		
		sprite.position = pos;
	}
}

@end
