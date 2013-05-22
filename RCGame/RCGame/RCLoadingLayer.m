//
//  RCLoadingLayer.m
//  RCGame
//
//  Created by xuzepei on 4/27/13.
//
//

#import "RCLoadingLayer.h"
#import "HelloWorldLayer.h"
#import "RCGameScene.h"
#import "RCMultiLayerScene.h"
#import "RCEarthScene.h"
#import "RCParallaxScene.h"
#import "RCShipGameScene.h"
#import "RCShootGameScene.h"
#import "RCBearGameScene.h"
#import "RCDragGameScene.h"
#import "RCBeatTheMoleScene.h"

@implementation RCLoadingLayer

+ (CCScene*)goToScene:(SCENE_TYPE)targetSceneType
{
    CCScene* scene = [CCScene node];
    RCLoadingLayer* layer = [[[RCLoadingLayer alloc] initWithSceneType:targetSceneType] autorelease];
    [scene addChild:layer];
    
    return scene;
}

- (id)initWithSceneType:(SCENE_TYPE)targetSceneType
{
    if(self = [super init])
    {
        _targetSceneType = targetSceneType;
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Loading ..." fontName:@"Marker Felt"
                                               fontSize:64];
        CGSize size = WIN_SIZE;
        label.position = CGPointMake(size.width / 2.0, size.height / 2.0);
        [self addChild:label];
        
        [self scheduleOnce:@selector(doTransition:) delay:1];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)doTransition:(ccTime)delta
{
    CCScene* scene = nil;
    switch (_targetSceneType) {
        case ST_HELLOWORLD:
        {
            scene = [HelloWorldLayer scene];
            break;
        }
        case ST_DOODLEDROP:
        {
            scene = [RCGameScene scene];
            break;
        }
        case ST_MULTILAYER:
        {
            scene = [RCMultiLayerScene scene];
            break;
        }
        case ST_EARTH:
        {
            scene = [RCEarthScene node];
            break;
        }
        case ST_PARALLAX:
        {
            scene = [RCParallaxScene node];
            break;
        }
        case ST_SHIPGAMESCENE:
        {
            scene = [RCShipGameScene node];
            break;
        }
        case ST_SHOOTGAME:
        {
            scene = [RCShootGameScene node];
            break;
        }
        case ST_BEARGAME:
        {
            scene = [RCBearGameScene node];
            break;
        }
        case ST_DRAGGAME:
        {
            scene = [RCDragGameScene node];
            break;
        }
        case ST_BEATTHEMOLE:
        {
            scene = [RCBeatTheMoleScene node];
            break;
        }
        default:
            break;
    }
    
    if(scene)
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
    }
}

@end
