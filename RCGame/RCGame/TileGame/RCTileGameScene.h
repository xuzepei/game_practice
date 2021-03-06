//
//  RCTileGameScene.h
//  RCGame
//
//  Created by xuzepei on 5/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RCTileGameScene : CCLayer {
    
}

@property(nonatomic,retain)CCTMXTiledMap* tileMap;
@property(nonatomic,retain)CCTMXLayer* bgLayer;
@property(nonatomic,retain)CCSprite* player;
@property(nonatomic,retain)CCTMXLayer* metaLayer;
@property(nonatomic,retain)CCTMXLayer* fgLayer;
@property(nonatomic,retain)CCTMXLayer* foodLayer;
@property(assign)BOOL mode;

+ (id)scene;
+ (RCTileGameScene*)sharedInstance;

@end
