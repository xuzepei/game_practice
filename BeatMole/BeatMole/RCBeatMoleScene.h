//
//  RCBeatMoleScene.h
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RCBeatMoleScene : CCLayer {
    
}

@property(nonatomic,retain)NSMutableArray* moles;
@property(nonatomic,retain)CCAnimation* laughAnimation;
@property(nonatomic,retain)CCAnimation* hitAnimation;
@property(nonatomic,retain)CCLabelTTF* scoreLabel;
@property(assign)int score;
@property(assign)int molePopCount;
@property(assign)BOOL isGameOver;
@property(nonatomic,retain)NSMutableArray* positionArray;
@property(nonatomic,retain)NSArray* layerZIndex;
@property(nonatomic,retain)NSMutableSet* showingHoleSet;
@property(assign)int rightTapCount;
@property(assign)int wrongTapCount;
@property(assign)int continuousRightTapCount;
@property(nonatomic,retain)CCMenuItemFont* pauseMenuItem;

+ (id)scene;
+ (RCBeatMoleScene*)sharedInstance;

@end
