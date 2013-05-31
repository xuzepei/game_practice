//
//  RCUser.h
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//
//

#import <Foundation/Foundation.h>

@interface RCUser : NSObject

@property(nonatomic,retain)NSString* nickname;
@property(assign)TEAM_TYPE teamType;

+ (RCUser*)sharedInstance;

@end
