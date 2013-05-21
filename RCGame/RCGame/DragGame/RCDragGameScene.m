//
//  RCDragGameScene.m
//  RCGame
//
//  Created by xuzepei on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCDragGameScene.h"

static RCDragGameScene* sharedInstance;
@implementation RCDragGameScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCDragGameScene* layer = [RCDragGameScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCDragGameScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        sharedInstance = self;
        self.isTouchEnabled = YES;
        
        CGSize screenSize = WIN_SIZE;
    }
    
    return self;
}

- (void)dealloc
{
    sharedInstance = nil;
    [super dealloc];
}

#pragma mark - Touch Event

- (void)registerWithTouchDispatcher
{
    [[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [DIRECTOR convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];

}

@end
