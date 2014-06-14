//
//  RCSelectLevelScene.h
//  BeatMole
//
//  Created by xuzepei on 5/28/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"
#import "CCLayer+CCLayer_Opaque.h"

@interface RCSelectLevelScene : CCLayer<CCScrollLayerDelegate> {
    
}

+ (id)scene:(int)levelIndex;
+ (RCSelectLevelScene*)sharedInstance;

@end
