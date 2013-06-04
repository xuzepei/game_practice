//
//  RCWave.h
//  BeatMole
//
//  Created by xuzepei on 6/4/13.
//
//

#import <Foundation/Foundation.h>

@interface RCWave : NSObject

@property(assign)CGFloat interval;
@property(assign)CGFloat difficultyFactor;
@property(assign)int maxShowNumber;
@property(nonatomic,retain)NSMutableArray* assignmentArray;
@property(assign)int wrongShowNumber;

@end
