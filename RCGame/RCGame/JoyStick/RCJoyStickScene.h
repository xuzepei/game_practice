//
//  RCJoyStickScene.h
//  RCGame
//
//  Created by xuzepei on 5/31/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SneakyJoystick;
@class SneakyButton;
@interface RCJoyStickScene : CCLayer {
    
}

@property(nonatomic,retain)SneakyJoystick* leftJoyStick;
@property(nonatomic,retain)SneakyButton* rightButton;

+ (id)scene;
+ (RCJoyStickScene*)sharedInstance;

@end
