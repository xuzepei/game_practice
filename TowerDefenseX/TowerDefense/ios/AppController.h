//
//  TowerDefenseAppController.h
//  TowerDefense
//
//  Created by xuzepei on 7/25/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

@class RootViewController;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIApplicationDelegate>
{
}

@property (nonatomic, retain)UIWindow* window;
@property (nonatomic, retain)RootViewController* rootViewController;

@end

