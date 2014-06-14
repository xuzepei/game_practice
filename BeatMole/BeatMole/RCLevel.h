//
//  RCLevel.h
//  BeatMole
//
//  Created by xuzepei on 6/4/13.
//
//

#import <Foundation/Foundation.h>

@interface RCLevel : NSObject


@property(assign)int userHP;
@property(assign)int starLevel0;//根据金币数量判断
@property(assign)int starLevel1;
@property(assign)int starLevel2;
@property(nonatomic,retain)NSMutableArray* waveArray;
@property(nonatomic,retain)NSMutableArray* holeArray;

+ (RCLevel*)sharedInstance;
+ (void)saveLevelResult:(int)levelIndex//关卡级数
                   star:(int)star//星级
                   coin:(int)coin//获得金币数量
                     hp:(int)hp//玩家剩余血量
         rightKillCount:(int)rightKillCount//正确击杀小兵次数
         wrongKillCount:(int)wrongKillCount//错误击杀小兵次数
continuousRightKillCount:(int)continuousRightKillCount//最大连续正确击杀小兵次数
              showCount:(int*)showCount//各兵显示数量
              killCount:(int*)killCount//各兵被击杀数量
                length:(int)length;//showCount和killCount的长度
+ (NSDictionary*)getLevelResultByIndex:(int)levelIndex;

+ (void)setLastLevelIndex:(int)levelIndex;
+ (int)getLastLevelIndex;

- (void)updateByLevelNumber:(int)levelNumber;

@end
