//
//  RCAchievement.m
//  BeatMole
//
//  Created by xuzepei on 8/5/13.
//
//

#import "RCAchievement.h"

@implementation RCAchievement

- (id)init
{
    if(self = [super init])
    {
        _assignmentArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    self.assignmentArray = nil;
    [super dealloc];
}

@end
