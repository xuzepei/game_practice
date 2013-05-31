//
//  RCMonster.h
//  RCGame
//
//  Created by xuzepei on 5/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RCMonster : CCSprite {
    
}

@property(assign)int hp;
@property(assign)int minMoveDuration;
@property(assign)int maxMoveDuration;

@end

@interface RCWeakAndFastMonster : RCMonster {
    
}

+(id)monster;

@end


@interface RCStrongAndSlowMonster : RCMonster {
    
}

+(id)monster;

@end
