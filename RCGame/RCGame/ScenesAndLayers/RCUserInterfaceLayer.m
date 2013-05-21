//
//  RCUserInterfaceLayer.m
//  RCGame
//
//  Created by xuzepei on 5/3/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCUserInterfaceLayer.h"
#import "RCMultiLayerScene.h"
#import "RCGameLayer.h"



@implementation RCUserInterfaceLayer

- (id)init
{
    if(self = [super init])
    {
        
        CGSize screenSize = WIN_SIZE;
        
        CCSprite* titleBar = [CCSprite spriteWithFile:@"ui-frame@2x.png"];
        
        titleBar.position = ccp(screenSize.width/2.0, screenSize.height);
		titleBar.anchorPoint = CGPointMake(0.5, 1);
		[self addChild:titleBar z:0 tag:LT_TITLEBAR];
        
        CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"Here be your Game Scores etc" fontName:@"Courier" fontSize:12];
        titleLabel.color = ccBLACK;
        titleLabel.position = ccp(screenSize.width/2.0,screenSize.height);
        titleLabel.anchorPoint = ccp(0.5,1);
        [self addChild: titleLabel];
        
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Touch Event

- (void)registerWithTouchDispatcher
{
    CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
}

- (BOOL)touchOnTitleBar:(CGPoint)point
{
    CCNode* node = [self getChildByTag:LT_TITLEBAR];
    return CGRectContainsPoint([node boundingBox], point);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [RCMultiLayerScene locationFromTouch:touch];
    BOOL b = [self touchOnTitleBar:location];
    if(b)//点击Title bar 动画效果
    {

		CCNode* node = [self getChildByTag:LT_TITLEBAR];
		NSAssert([node isKindOfClass:[CCSprite class]], @"node is not a CCSprite");
		
		((CCSprite*)node).color = ccRED;
		
		CCRotateBy* rotate = [CCRotateBy actionWithDuration:4 angle:360];
        
        
		CCScaleTo* scaleDown = [CCScaleTo actionWithDuration:2 scale:0];
		CCScaleTo* scaleUp = [CCScaleTo actionWithDuration:2 scale:1];
        CCCallFunc* func = [CCCallFunc actionWithTarget:self selector:@selector(actionFinished:)];
		CCSequence* sequence = [CCSequence actions:scaleDown,scaleUp,func,nil];
		sequence.tag = AT_ROTATION;
		
		RCGameLayer* gameLayer = [[RCMultiLayerScene sharedInstance] gameLayer];
		
		[gameLayer stopActionByTag:AT_ROTATION];
		[gameLayer setRotation:0];
		[gameLayer setScale:1];
		
		[gameLayer runAction:rotate];
		[gameLayer runAction:sequence];
    }
    
    return b;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCNode* node = [self getChildByTag:LT_TITLEBAR];
	NSAssert([node isKindOfClass:[CCSprite class]], @"node is not a CCSprite");
	
	((CCSprite*)node).color = ccWHITE;
}


- (void)actionFinished:(id)sender
{
}

@end
