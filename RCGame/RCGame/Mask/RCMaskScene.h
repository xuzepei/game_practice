//
//  RCMaskScene.h
//  RCGame
//
//  Created by xuzepei on 5/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RCMaskScene : CCLayer {
    
}

@property(nonatomic,retain)CCSprite* mole;

@property(assign)int calendarNum;

+ (id)scene:(int)lastCalendar;
- (id)init:(int)lastCalendar;
+ (RCMaskScene*)sharedInstance;

@end
