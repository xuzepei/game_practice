//
//  RCLevel.m
//  BeatMole
//
//  Created by xuzepei on 6/4/13.
//
//

#import "RCLevel.h"
#import "RCWave.h"

@implementation RCLevel

+ (RCLevel*)sharedInstance
{
    static RCLevel* sharedInstance = nil;
    
    if(nil == sharedInstance)
    {
        @synchronized([RCLevel class])
        {
            if(nil == sharedInstance)
            {
                sharedInstance = [[RCLevel alloc] init];
            }
        }
    }
    
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        _waveArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    self.waveArray = nil;
    
    [super dealloc];
}

- (void)updateByLevelNumber:(int)levelNumber
{
    switch (levelNumber) {
        case 0:
        {
            self.userHP = 10;
            self.starLevel0 = 495;
            self.starLevel1 = 660;
            self.starLevel2 = 825;
            
            RCWave* wave0 = [[[RCWave alloc] init] autorelease];
            wave0.interval = 0;
            wave0.difficultyFactor = 100;
            wave0.wrongShowNumber = 3;
            wave0.maxShowNumber = 1;
            
            NSMutableDictionary* assignment = [[[NSMutableDictionary alloc] init] autorelease];
            [assignment setObject:@"0" forKey:@"type"];
            [assignment setObject:@"10" forKey:@"count"];
            [wave0.assignmentArray addObject:assignment];
            [_waveArray addObject:wave0];
            
            RCWave* wave1 = [[[RCWave alloc] init] autorelease];
            wave1.interval = 0;
            wave1.difficultyFactor = 100;
            wave1.wrongShowNumber = 3;
            wave1.maxShowNumber = 1;
            
            assignment = [[[NSMutableDictionary alloc] init] autorelease];
            [assignment setObject:@"0" forKey:@"type"];
            [assignment setObject:@"5" forKey:@"count"];
            [wave1.assignmentArray addObject:assignment];
            
            assignment = [[[NSMutableDictionary alloc] init] autorelease];
            [assignment setObject:@"1" forKey:@"type"];
            [assignment setObject:@"5" forKey:@"count"];
            [wave1.assignmentArray addObject:assignment];

            [_waveArray addObject:wave1];
            
            
            RCWave* wave2 = [[[RCWave alloc] init] autorelease];
            wave2.interval = 0;
            wave2.difficultyFactor = 100;
            wave2.wrongShowNumber = 5;
            wave2.maxShowNumber = 1;
            
            assignment = [[[NSMutableDictionary alloc] init] autorelease];
            [assignment setObject:@"0" forKey:@"type"];
            [assignment setObject:@"10" forKey:@"count"];
            [wave2.assignmentArray addObject:assignment];
            
            assignment = [[[NSMutableDictionary alloc] init] autorelease];
            [assignment setObject:@"1" forKey:@"type"];
            [assignment setObject:@"5" forKey:@"count"];
            [wave2.assignmentArray addObject:assignment];
            
            [_waveArray addObject:wave2];
            
            
            
            RCWave* wave3 = [[[RCWave alloc] init] autorelease];
            wave3.interval = 0;
            wave3.difficultyFactor = 100;
            wave3.wrongShowNumber = 5;
            wave3.maxShowNumber = 2;
            
            assignment = [[[NSMutableDictionary alloc] init] autorelease];
            [assignment setObject:@"0" forKey:@"type"];
            [assignment setObject:@"10" forKey:@"count"];
            [wave3.assignmentArray addObject:assignment];
            
            assignment = [[[NSMutableDictionary alloc] init] autorelease];
            [assignment setObject:@"1" forKey:@"type"];
            [assignment setObject:@"10" forKey:@"count"];
            [wave3.assignmentArray addObject:assignment];
            
            [_waveArray addObject:wave3];
            
            
            RCWave* wave4 = [[[RCWave alloc] init] autorelease];
            wave4.interval = 0;
            wave4.difficultyFactor = 100;
            wave4.wrongShowNumber = 5;
            wave4.maxShowNumber = 2;
            
            assignment = [[[NSMutableDictionary alloc] init] autorelease];
            [assignment setObject:@"0" forKey:@"type"];
            [assignment setObject:@"10" forKey:@"count"];
            [wave4.assignmentArray addObject:assignment];
            
            assignment = [[[NSMutableDictionary alloc] init] autorelease];
            [assignment setObject:@"1" forKey:@"type"];
            [assignment setObject:@"15" forKey:@"count"];
            [wave4.assignmentArray addObject:assignment];
            
            [_waveArray addObject:wave4];
            
            break;
        }
        default:
            break;
    }
}

@end
