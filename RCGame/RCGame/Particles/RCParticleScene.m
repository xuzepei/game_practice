//
//  RCParticleScene.m
//  RCGame
//
//  Created by xuzepei on 7/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCParticleScene.h"

static RCParticleScene* sharedInstance;
@implementation RCParticleScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCParticleScene* layer = [RCParticleScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCParticleScene*)sharedInstance
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
        
        [self runEffect];
    }
    
    return self;
}

- (void)dealloc
{
    sharedInstance = nil;
    [super dealloc];
}

- (void)runEffect
{
    [self removeChildByTag:1 cleanup:YES];
    
    CCParticleSystem* system = [CCParticleSystemQuad particleWithFile:@"fire.plist"];
    //system.position = self.position;
    system.autoRemoveOnFinish = YES;
	[self addChild:system z:1 tag:1];
    
}

@end
