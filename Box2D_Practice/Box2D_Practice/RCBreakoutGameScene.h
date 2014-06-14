//
//  RCBreakoutGameScene.h
//  Box2D_Practice
//
//  Created by xuzepei on 8/27/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "PhysicsSprite.h"
#import "GLES-Render.h"

@interface RCBreakoutGameScene : CCLayer {
    
    b2World* _world;
    GLESDebugDraw* _debugDraw;
    
    b2Body* _groundBody;
    b2Fixture* _ballFixture;
    
    b2Body* _paddleBody;
    b2Fixture* _paddleFixture;
    
    b2MouseJoint* _mouseJoint;
    
}

@property(nonatomic,retain)PhysicsSprite* ballSprite;
@property(nonatomic,retain)PhysicsSprite* paddleSprite;

+ (id)scene;

@end
