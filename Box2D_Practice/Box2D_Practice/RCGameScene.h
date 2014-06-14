//
//  RCGameScene.h
//  Box2D_Practice
//
//  Created by xuzepei on 8/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "PhysicsSprite.h"

@interface RCGameScene : CCLayer {
    
    b2World* _world;
    
}

@property(nonatomic,retain)PhysicsSprite* ballSprite;

+ (id)scene;

@end
