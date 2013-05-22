//
//  RCDragGameScene.h
//  RCGame
//
//  Created by xuzepei on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RCDragGameScene : CCLayer {
    
}

@property(nonatomic,retain)CCSprite* bgSprite;
@property(nonatomic,retain)CCSprite* selectedSprite;
@property(nonatomic,retain)NSMutableArray* willMoveSpriteArray;

+ (id)scene;
+ (RCDragGameScene*)sharedInstance;

@end
