//
//  RCMaskScene.m
//  RCGame
//
//  Created by xuzepei on 5/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCMaskScene.h"
#import "SimpleAudioEngine.h"
#import "RCMaskLayer.h"


static RCMaskScene* sharedInstance;
@implementation RCMaskScene

+ (id)scene:(int)lastCalendar
{
    CCScene* scene = [CCScene node];
    RCMaskScene* layer = [[[RCMaskScene alloc] init:lastCalendar] autorelease];
    [scene addChild:layer];
    return scene;
}

+ (RCMaskScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init:(int)lastCalendar
{
    if(self = [super init])
    {
        sharedInstance = self;
        self.isTouchEnabled = YES;
        CGSize winSize = WIN_SIZE;
        
        do {
            self.calendarNum = arc4random() %3+1;
        } while (self.calendarNum == lastCalendar);
        
        NSString* spriteName = [NSString
                                 stringWithFormat:@"calendar%d.png", self.calendarNum];
        
        CCSprite * land = [CCSprite spriteWithFile:@"land.png"];
        land.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:land];
        
        CCSprite * hole = [CCSprite spriteWithFile:@"hole.png"];
        hole.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:hole];
        
        
//矩形的MASK
        RCMaskLayer* maskLayer = [RCMaskLayer layerWithColor:ccc4(0, 0, 0, 0)];
        [self addChild:maskLayer];
        

        // BEGINTEMP
        self.mole = [CCSprite spriteWithFile:spriteName];
        self.anchorPoint = ccp(0.5, 1);
        self.mole.position = ccp(winSize.width/2, winSize.height/2 - 100);
        [maskLayer addChild:self.mole];
        
        
        [self doAction];
        
        static BOOL b = YES;
        if(b)
        {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"tearoots.mp3" loop:YES];
            
            b = NO;
        }

    }
    
    return self;
}

- (void)dealloc
{
    self.mole = nil;
    sharedInstance = nil;
    [super dealloc];
}

- (void)registerWithTouchDispatcher {
    [[DIRECTOR touchDispatcher] addTargetedDelegate:self
                                                     priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCScene *scene = [RCMaskScene scene:self.calendarNum];
    [DIRECTOR replaceScene:
     [CCTransitionJumpZoom transitionWithDuration:1.0 scene:scene]];
    return YES;
}

- (CCSprite *)maskedSpriteWithSprite:(CCSprite *)textureSprite maskSprite:(CCSprite *)maskSprite {
    
    // 1
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:maskSprite.contentSize.width height:maskSprite.contentSize.height];
    
    // 2
    maskSprite.position = ccp(maskSprite.contentSize.width/2, maskSprite.contentSize.height/2);
    textureSprite.position = ccp(textureSprite.contentSize.width/2, textureSprite.contentSize.height/2);
    
    // 3
    [maskSprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
    [textureSprite setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ZERO}];
    
    // 4
    [rt begin];
    [maskSprite visit];
    [textureSprite visit];
    [rt end];
    
    // 5
//    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
//    retval.flipY = YES;
//    return retval;
    
    return nil;
    
}

- (void)redo
{
    [self doAction];
}

- (void)doAction
{
    CCMoveBy* moveUp = [CCMoveBy actionWithDuration:3.0
                                           position:ccp(0, self.mole.contentSize.height)];
    
    CCCallFunc *redo = [CCCallFuncN actionWithTarget:self selector:@selector(redo)];
    //        CCCallFunc *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unsetTappable:)];
    
    CCEaseInOut* easeMoveUp = [CCEaseInOut actionWithAction:moveUp rate:3.0];
    CCAction *easeMoveDown = [easeMoveUp reverse];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1];
    
    [self.mole runAction:[CCSequence actions:easeMoveUp,delay, easeMoveDown,redo,nil]];
}

@end
