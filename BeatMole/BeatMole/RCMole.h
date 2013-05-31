//
//  RCMole.h
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RCHPBar.h"

@interface RCMole : CCSprite {
    
}

@property(nonatomic,retain)NSString* name;
@property(nonatomic,retain)NSString* imageName;
@property(assign)MOLE_TYPE type;
@property(assign)CGFloat showTime;
@property(assign)int hp;
@property(assign)int beatCount;
@property(assign)int coin;
@property(assign)int penalty;
@property(assign)TEAM_TYPE teamType;
@property(assign)int showingHoleIndex;
@property(nonatomic,retain)CCProgressTimer* hpBar;
@property(nonatomic,retain)CCAnimation* moveUpAnimation;
@property(nonatomic,retain)CCAnimation* moveDownAnimation;
@property(nonatomic,retain)CCAnimation* beatMoveDownAnimation;

- (void)addHPBar;
- (void)resetHP;

@end
