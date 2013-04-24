//
//  RCMultiLayerScene.m
//  RCGame
//
//  Created by xuzepei on 1/28/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCMultiLayerScene.h"
#import "RCGameLayer.h"
#import "RCUserInterfaceLayer.h"

#define GAME_LAYER_TAG 100
#define USERINTERFACE_LAYER_TAG 101

@implementation RCMultiLayerScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCMultiLayerScene* layer = [RCMultiLayerScene node];
    [scene addChild: layer];
    
    return scene;
}

+ (id)sharedInstance
{
    static id sharedInstance = nil;

    if(nil == sharedInstance)
    {
        @synchronized([RCMultiLayerScene class])
        {
            if(nil == sharedInstance)
            {
                sharedInstance = [RCMultiLayerScene scene];
            }
        }
    }
    
    return sharedInstance;
}

+ (CGPoint)locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

+ (CGPoint)locationFromTouches:(NSSet*)touches
{
	return [self locationFromTouch:[touches anyObject]];
}

- (id)init
{
    if(self = [super init])
    {
//        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 0, 255, 255)];
//		[self addChild:colorLayer z:0];
        
        RCGameLayer* gameLayer = [RCGameLayer node];
        [self addChild:gameLayer z:1 tag:GAME_LAYER_TAG];
        
        RCUserInterfaceLayer* uiLayer = [RCUserInterfaceLayer node];
        [self addChild:uiLayer z:2 tag:USERINTERFACE_LAYER_TAG];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (RCGameLayer*)gameLayer
{
    CCNode* layer = [self getChildByTag:GAME_LAYER_TAG];
    if([layer isKindOfClass:[RCGameLayer class]])
        return (RCGameLayer*)layer;
    
    return nil;
}

- (RCUserInterfaceLayer*)uiLayer
{
    CCNode* layer = [self getChildByTag:USERINTERFACE_LAYER_TAG];
    if([layer isKindOfClass:[RCUserInterfaceLayer class]])
        return (RCUserInterfaceLayer*)layer;
    
    return nil;
}

@end
