//
//  RCBullet.h
//  RCGame
//
//  Created by xuzepei on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class RCShip;

@interface RCBullet : CCSprite {
	CGPoint velocity;
	float outsideScreen;
}

@property (readwrite, nonatomic) CGPoint velocity;

+(id) bullet;
-(void) shootBulletFromShip:(RCShip*)ship;

@end
