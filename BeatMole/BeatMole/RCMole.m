//
//  RCMole.m
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCMole.h"


@implementation RCMole

- (void)dealloc
{
    self.name = nil;
    self.imageName = nil;
    self.moveUpAnimation = nil;
    self.moveDownAnimation = nil;
    self.beatMoveDownAnimation = nil;
    self.deadDownAnimation = nil;
    self.hpBar = nil;
    
    [super dealloc];
}

- (void)addHPBar
{
    if(TT_RED == self.teamType)
    {
        CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"red_hp_bar.png"];
        self.hpBar = [CCProgressTimer progressWithSprite:sprite];
        self.hpBar.barChangeRate=ccp(1,0);
        self.hpBar.midpoint=ccp(0.0,0.0f);
        [self.hpBar setAnchorPoint:ccp(0,1)];
        self.hpBar.type = kCCProgressTimerTypeBar;
        [self.hpBar setPosition:ccp(0, self.contentSize.height)];
        [self addChild:self.hpBar];
        self.hpBar.visible = NO;
    }
    else if(TT_BLUE == self.teamType)
    {
        CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"blue_hp_bar.png"];
        self.hpBar = [CCProgressTimer progressWithSprite:sprite];
        self.hpBar.barChangeRate=ccp(1,0);
        self.hpBar.midpoint=ccp(0.0,0.0f);
        [self.hpBar setAnchorPoint:ccp(0,1)];
        self.hpBar.type = kCCProgressTimerTypeBar;
        [self.hpBar setPosition:ccp(0, self.contentSize.height)];
        [self addChild:self.hpBar];
        self.hpBar.visible = NO;
    }
    
    [self unscheduleUpdate];
    [self scheduleUpdate];
}

- (void)resetHP
{
    self.beatCount = 0;
    if(self.hpBar)
        [self.hpBar setPercentage:100];
}

- (void)update:(ccTime)delta
{
    if(self.hpBar)
    {
        if(self.beatCount >= self.hp)
        {
            [self.hpBar setPercentage:0];
            return;
        }
        else
        {
            [self.hpBar setPercentage:100*(self.hp - self.beatCount) / (float)self.hp];
        }
    }
}

@end
