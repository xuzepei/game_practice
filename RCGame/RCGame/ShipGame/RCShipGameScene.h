//
//  RCShipGameScene.h
//  RCGame
//
//  Created by xuzepei on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class RCShip;
@interface RCShipGameScene : CCLayer {
    
}

@property(assign)int nextInactiveBullet;

+ (id)scene;
+ (RCShipGameScene*)sharedInstance;
-(void) shootBulletFromShip:(RCShip*)ship;

@end
