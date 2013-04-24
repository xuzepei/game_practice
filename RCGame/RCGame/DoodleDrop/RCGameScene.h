//
//  RCGameScene.h
//  RCGame
//
//  Created by xuzepei on 1/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RCGameScene : CCLayer {
    
    CCSprite* player;
    CGPoint playerVelocity;
    
    CCArray* spiders;
    CGFloat spiderMoveDuration;
    int numSpidersMoved;
    
    CCLabelTTF* scoreLabel;
    int totalTime;
    int score;
}

+ (id)scene;

@end
