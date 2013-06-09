//
//  RCTool.h
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//
//

#import <Foundation/Foundation.h>

@class RCMainViewController;
@class RCNavigationController;
@class RCMole;
@interface RCTool : NSObject

+ (NSString*)getUserDocumentDirectoryPath;
+ (NSString *)md5:(NSString *)str;
+ (NSString *)getIpAddress;
+ (NSString*)base64forData:(NSData*)theData;
+ (CGSize)getScreenSize;
+ (CGRect)getScreenRect;
+ (BOOL)isIphone5;
+ (BOOL)isIpad;
+ (UIWindow*)frontWindow;
+ (NSArray*)getMolesByTeamType:(TEAM_TYPE)type;
+ (RCMole*)getMoleByTeamType:(TEAM_TYPE)teamType moleType:(NSString*)moleType;
+ (RCMole*)getMoleById:(NSString*)moleId;
+ (RCNavigationController*)getRootNavigationController;
+ (void)saveLevelResult:(int)levelIndex
                   star:(int)star
                   coin:(int)coin
                     hp:(int)hp
         rightKillCount:(int)rightKillCount
         wrongKillCount:(int)wrongKillCount
continuousRightKillCount:(int)continuousRightKillCount
              showCount:(int*)showCount
              killCount:(int*)killCount
                idCount:(int)idCount;
+ (NSDictionary*)getLevelResultByIndex:(int)levelIndex;


@end
