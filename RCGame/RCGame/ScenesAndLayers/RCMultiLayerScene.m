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

static id g_multiLayerSceneSharedInstance = nil;

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
    return g_multiLayerSceneSharedInstance;
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
        g_multiLayerSceneSharedInstance = self;
        
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 0, 255, 255)];
		[self addChild:colorLayer z:0 tag:LT_BG];
        
        RCGameLayer* gameLayer = [RCGameLayer node];
        [self addChild:gameLayer z:1 tag:LT_GAME];
        
        RCUserInterfaceLayer* uiLayer = [RCUserInterfaceLayer node];
        [self addChild:uiLayer z:2 tag:LT_USERINTERFACE];
    }
    
    return self;
}

- (void)dealloc
{
    g_multiLayerSceneSharedInstance = nil;
    [super dealloc];
}

- (RCGameLayer*)gameLayer
{
    CCNode* layer = [self getChildByTag:LT_GAME];
    if([layer isKindOfClass:[RCGameLayer class]])
        return (RCGameLayer*)layer;
    
    return nil;
}

- (RCUserInterfaceLayer*)uiLayer
{
    CCNode* layer = [self getChildByTag:LT_USERINTERFACE];
    if([layer isKindOfClass:[RCUserInterfaceLayer class]])
        return (RCUserInterfaceLayer*)layer;
    
    return nil;
}

@end
