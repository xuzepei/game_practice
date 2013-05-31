//
//  RCMonster.m
//  RCGame
//
//  Created by xuzepei on 5/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCMonster.h"


@implementation RCMonster

@end

@implementation RCWeakAndFastMonster

+ (id)monster {
    
    RCWeakAndFastMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"target.png"] autorelease])) {
        monster.hp = 1;
        monster.minMoveDuration = 12;
        monster.maxMoveDuration = 18;
    }
    return monster;
}

@end


@implementation RCStrongAndSlowMonster

+ (id)monster {
    
    RCStrongAndSlowMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"target2.png"] autorelease])) {
        monster.hp = 3;
        monster.minMoveDuration = 18;
        monster.maxMoveDuration = 24;
    }
    return monster;
}

@end
