//
//  Spider.h
//  RCGame
//
//  Created by xuzepei on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Spider : CCNode<CCTargetedTouchDelegate> {
    
}

@property(nonatomic,retain)CCSprite* spiderSprite;
@property(assign)int numUpdates;

+ (id)spiderWithParentNode:(CCNode*)parentNode;
- (id)initWithParentNode:(CCNode*)parentNode;

@end
