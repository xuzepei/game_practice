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
    
    int _showCount[20]; //各兵显示数量
    int _killCount[20]; //各兵被击杀数量
    
}

@property(assign)int levelIndex;
@property(nonatomic,retain)NSMutableArray* moles;
@property(nonatomic,retain)CCAnimation* laughAnimation;
@property(nonatomic,retain)CCAnimation* hitAnimation;
@property(nonatomic,retain)CCLabelTTF* scoreLabel;
@property(nonatomic,retain)CCLabelTTF* hpLabel;
@property(assign)int score;  //总共获得金钱
@property(assign)int userHP; //玩家血量
@property(assign)BOOL isGameOver; //游戏关卡结束标识
@property(nonatomic,retain)NSMutableArray* positionArray; //地洞位置坐标
@property(nonatomic,retain)NSMutableArray* showingMoleArray; //正在显示的兵
@property(nonatomic,retain)NSMutableSet* showingHoleSet; //正在占用的地洞
@property(assign)int rightTapCount; //正确击杀小兵次数
@property(assign)int wrongTapCount; //错误击杀小兵次数
@property(assign)int continuousRightTapCount; //最大连续正确击杀小兵次数
@property(nonatomic,retain)CCMenuItemFont* pauseMenuItem;
@property(assign)int currentWaveNumber; //当前波数
@property(nonatomic,retain)RCWave* currentWave; //当前波

+ (id)scene:(int)levelIndex;
+ (RCBeatMoleScene*)sharedInstance;

@end
