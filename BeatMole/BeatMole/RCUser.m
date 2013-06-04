//
//  RCUser.m
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//
//

#import "RCUser.h"

@implementation RCUser

+ (RCUser*)sharedInstance
{
    static RCUser* sharedInstance = nil;
    
    if(nil == sharedInstance)
    {
        @synchronized([RCUser class])
        {
            if (nil == sharedInstance)
            {
                sharedInstance = [[RCUser alloc] init];
            }
        }
    }
    
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        self.nickname = @"玩家";
        self.teamType = TT_RED;
        self.ap = 1;
    }
    
    return self;
}

- (void)dealloc
{
    self.nickname = nil;
    [super dealloc];
}

@end
