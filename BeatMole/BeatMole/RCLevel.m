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
    NSString* name = [NSString stringWithFormat:@"level_%d",levelNumber];
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary* levelInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    if(nil == levelInfo)
        return;
    
    [_waveArray removeAllObjects];
    
    self.userHP = [[levelInfo objectForKey:@"userHP"] intValue];
    self.starLevel0 = [[levelInfo objectForKey:@"starLevel0"] intValue];
    self.starLevel1 = [[levelInfo objectForKey:@"starLevel1"] intValue];
    self.starLevel2 = [[levelInfo objectForKey:@"starLevel2"] intValue];
    
    NSArray* waves = [levelInfo objectForKey:@"waves"];
    if(waves && [waves isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* waveDict in waves)
        {
            RCWave* wave = [[[RCWave alloc] init] autorelease];
            wave.interval = [[waveDict objectForKey:@"interval"] floatValue];
            wave.difficultyFactor = [[waveDict objectForKey:@"difficultyFactor"] floatValue];
            wave.wrongShowNumber = [[waveDict objectForKey:@"wrongShowNumber"] intValue];
            wave.maxShowNumber = [[waveDict objectForKey:@"maxShowNumber"] intValue];
            [wave.assignmentArray addObjectsFromArray:[waveDict objectForKey:@"assignments"]];
            [_waveArray addObject:wave];
        }
    }
}

@end
