//
//  AppDelegate.h
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class RCNavigationController;
@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic,retain)RCNavigationController* navigationController;


@end
