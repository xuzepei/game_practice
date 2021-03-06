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
+ (RCMole*)getMoleByTeamType:(TEAM_TYPE)teamType moleType:(NSString*)moleType;
+ (RCNavigationController*)getRootNavigationController;


@end
