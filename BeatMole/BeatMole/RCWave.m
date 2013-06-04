//
//  RCWave.m
//  BeatMole
//
//  Created by xuzepei on 6/4/13.
//
//

#import "RCWave.h"

@implementation RCWave

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
