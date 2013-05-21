//
//  RCShootGameScene.h
//  RCGame
//
//  Created by xuzepei on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RCShootGameScene : CCLayer {
    
}

+ (id)scene;
+ (RCShootGameScene*)sharedInstance;

@property(nonatomic,retain)NSMutableArray* targets;
@property(nonatomic,retain)NSMutableArray* projectiles;
@property(assign)int projectilesDestoryed;

@end
