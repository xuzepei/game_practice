//
//  RCBeatTheMoleScene.h
//  RCGame
//
//  Created by xuzepei on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RCBeatTheMoleScene : CCLayer {
    
}

@property(nonatomic,retain)NSMutableArray* moles;
@property(nonatomic,retain)CCAnimation* laughAnimation;
@property(nonatomic,retain)CCAnimation* hitAnimation;
@property(nonatomic,retain)CCLabelTTF* scoreLabel;
@property(assign)int score;
@property(assign)int molePopCount;
@property(assign)BOOL isGameOver;

+ (id)scene;
+ (RCBeatTheMoleScene*)sharedInstance;

@end
