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

+ (RCLevel*)sharedInstance;
- (void)updateByLevelNumber:(int)levelNumber;

@end
