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
        
        self.bgSprite = [CCSprite spriteWithFile:@"blue-shooting-stars.png"];
        self.bgSprite.anchorPoint = ccp(0,0);
        [self addChild:self.bgSprite];
        
        
        _willMoveSpriteArray = [[NSMutableArray alloc] init];
        NSArray* imageNameArray = [NSArray arrayWithObjects:@"bird.png", @"cat.png", @"dog.png", @"turtle.png", nil];
        for(int i =0; i <[imageNameArray count]; ++i)
        {
            NSString* imageName = [imageNameArray objectAtIndex:i];
            
            CCSprite* sprite = [CCSprite spriteWithFile:imageName];
            
            CGFloat offset_x = i*100;
            sprite.position = ccp(80 + offset_x, screenSize.height/2.0);
            
            [self addChild:sprite];
            [_willMoveSpriteArray addObject:sprite];
        }
    }
    
    return self;
}

- (void)dealloc
{
    self.bgSprite = nil;
    self.selectedSprite = nil;
    self.willMoveSpriteArray = nil;
    
    sharedInstance = nil;
    [super dealloc];
}

- (void)selectSprite:(CGPoint)touchLocation
{
    CCSprite* newSprite = nil;
    for(CCSprite* sprite in _willMoveSpriteArray)
    {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation))
        {
            newSprite = sprite;
            break;
        }
    }
    
    if(newSprite != self.selectedSprite)
    {
        [self.selectedSprite stopAllActions];
        
        [self.selectedSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        
        CCRotateTo* rotateToLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo* rotateToCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo* rotateToRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence * rotateSequence = [CCSequence actions:rotateToLeft, rotateToCenter, rotateToRight, rotateToCenter, nil];
        [newSprite runAction:[CCRepeatForever actionWithAction:rotateSequence]]; 
        self.selectedSprite = newSprite;
    }
}

- (CGPoint)bgPosition:(CGPoint)newPosition
{
    CGSize screenSize = WIN_SIZE;
    CGPoint retval = newPosition;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -self.bgSprite.contentSize.width + screenSize.width);
    retval.y = self.position.y;
    return retval;
}

- (void)doTranslation:(CGPoint)translation
{
    if(self.selectedSprite)
    {
        CGPoint new_position = ccpAdd(self.selectedSprite.position, translation);
        self.selectedSprite.position = new_position;
    }
    else
    {
        CGPoint new_position = ccpAdd(self.position, translation);
        self.position = [self bgPosition:new_position];
    } 
}

#pragma mark - Touch Event

- (void)registerWithTouchDispatcher
{
    [[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSprite:touchLocation];
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [DIRECTOR convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self doTranslation:translation];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
//    CGPoint touchLocation = [touch locationInView: [touch view]];
//    touchLocation = [DIRECTOR convertToGL: touchLocation];
//    touchLocation = [self convertToNodeSpace:touchLocation];
}

@end
