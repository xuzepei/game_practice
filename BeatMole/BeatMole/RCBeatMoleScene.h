//
//  RCBeatMoleScene.h
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class RCWave;
@interface RCBeatMoleScene : CCLayer {
    
}

@property(nonatomic,retain)NSMutableArray* moles;
@property(nonatomic,retain)CCAnimation* laughAnimation;
@property(nonatomic,retain)CCAnimation* hitAnimation;
@property(nonatomic,retain)CCLabelTTF* scoreLabel;
@property(nonatomic,retain)CCLabelTTF* hpLabel;
@property(assign)int score;
@property(assign)int userHP;
@property(assign)int molePopCount;
@property(assign)BOOL isGameOver;
@property(nonatomic,retain)NSMutableArray* positionArray;
@property(nonatomic,retain)NSMutableArray* showingMoleArray;
@property(nonatomic,retain)NSMutableSet* showingHoleSet;
@property(assign)int rightTapCount;//正确击杀小兵次数
@property(assign)int wrongTapCount;//错误击杀小兵次数
@property(assign)int continuousRightTapCount;//最大连续正确击杀小兵次数
@property(nonatomic,retain)CCMenuItemFont* pauseMenuItem;
@property(assign)int currentWaveNumber;
@property(nonatomic,retain)RCWave* currentWave;

+ (id)scene;
+ (RCBeatMoleScene*)sharedInstance;

@end
