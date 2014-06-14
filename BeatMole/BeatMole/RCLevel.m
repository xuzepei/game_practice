//
//  RCLevel.m
//  BeatMole
//
//  Created by xuzepei on 6/4/13.
//
//

#import "RCLevel.h"
#import "RCWave.h"
#import "RCTool.h"

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

+ (void)saveLevelResult:(int)levelIndex
                   star:(int)star
                   coin:(int)coin
                     hp:(int)hp
         rightKillCount:(int)rightKillCount
         wrongKillCount:(int)wrongKillCount
continuousRightKillCount:(int)continuousRightKillCount
              showCount:(int*)showCount
              killCount:(int*)killCount
                length:(int)length
{
    NSDictionary* lastResult = [RCLevel getLevelResultByIndex:levelIndex];
    if(lastResult)
    {
        int lastStar = [[lastResult objectForKey:@"star"] intValue];
        if(lastStar > star)
            star = lastStar;
    }
    
    NSMutableDictionary* result = [[[NSMutableDictionary alloc] init] autorelease];
    
    [result setObject:[NSString stringWithFormat:@"%d",coin] forKey:@"coin"];
    [result setObject:[NSString stringWithFormat:@"%d",star] forKey:@"star"];
    [result setObject:[NSString stringWithFormat:@"%d",hp] forKey:@"hp"];
    [result setObject:[NSString stringWithFormat:@"%d",rightKillCount] forKey:@"rightKillCount"];
    [result setObject:[NSString stringWithFormat:@"%d",wrongKillCount] forKey:@"wrongKillCount"];
    [result setObject:[NSString stringWithFormat:@"%d",continuousRightKillCount] forKey:@"continuousRightKillCount"];
    
    NSMutableArray* showCountArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < length; i++)
    {
        [showCountArray addObject:[NSString stringWithFormat:@"%d",showCount[i]]];
    }
    
    [result setObject:showCountArray forKey:@"showCount"];
    [showCountArray release];
    
    NSMutableArray* killCountArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < length; i++)
    {
        [killCountArray addObject:[NSString stringWithFormat:@"%d",killCount[i]]];
    }
    
    [result setObject:killCountArray forKey:@"killCount"];
    [killCountArray release];
    
    NSString* path = [NSString stringWithFormat:@"%@/level_result_%d",[RCTool getUserDocumentDirectoryPath],levelIndex];
    [result writeToFile:path atomically:YES];
}

+ (NSDictionary*)getLevelResultByIndex:(int)levelIndex
{
    NSString* path = [NSString stringWithFormat:@"%@/level_result_%d",[RCTool getUserDocumentDirectoryPath],levelIndex];
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (void)setLastLevelIndex:(int)levelIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:levelIndex forKey:@"lastLevelIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)getLastLevelIndex
{
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLevelIndex"];
    
    if(number)
        return [number intValue];
    
    return 0;
}

- (id)init
{
    if(self = [super init])
    {
        _waveArray = [[NSMutableArray alloc] init];
        _holeArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    self.waveArray = nil;
    self.holeArray = nil;
    
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
    [_holeArray removeAllObjects];
    
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
    
    NSArray* holes = [levelInfo objectForKey:@"holes"];
    if(holes && [holes isKindOfClass:[NSArray class]])
    {
        [_holeArray addObjectsFromArray:holes];
    }
}




@end
