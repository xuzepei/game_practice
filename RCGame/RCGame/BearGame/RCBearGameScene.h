//
//  RCBearGameScene.h
//  RCGame
//
//  Created by xuzepei on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RCBearGameScene : CCLayer {
    
}

@property(nonatomic,retain)CCSprite* bear;
@property(nonatomic,retain)CCAction* walkAction;
@property(nonatomic,retain)CCAction* moveAction;
@property(assign)BOOL isMoving;


+ (id)scene;
+ (RCBearGameScene*)sharedInstance;

@end
