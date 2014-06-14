//
//  RCAchievement.h
//  BeatMole
//
//  Created by xuzepei on 8/5/13.
//
//

#import <Foundation/Foundation.h>

@interface RCAchievement : NSObject

@property(assign)CGFloat interval;
@property(assign)CGFloat difficultyFactor;
@property(assign)int maxShowNumber;
@property(nonatomic,retain)NSMutableArray* assignmentArray;
@property(assign)int wrongShowNumber;

@end
