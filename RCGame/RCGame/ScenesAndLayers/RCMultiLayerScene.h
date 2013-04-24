//
//  RCMultiLayerScene.h
//  RCGame
//
//  Created by xuzepei on 1/28/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
	ActionTagGameLayerMovesBack,
	ActionTagGameLayerRotates,
} MultiLayerSceneActionTags;

@interface RCMultiLayerScene : CCLayer {
    
}


+ (id)scene;
+ (id)sharedInstance;
+ (CGPoint)locationFromTouch:(UITouch*)touch;
+ (CGPoint)locationFromTouches:(NSSet *)touches;

@end
