//
//  RCParallaxBackground.h
//  RCGame
//
//  Created by xuzepei on 5/31/13.
//
//

#import "CCNode.h"

@interface RCParallaxBackground : CCNode
{
}

@property(nonatomic,retain)CCSpriteBatchNode* batch;
@property(nonatomic,retain)CCArray* speedFactors;
@property(assign)float scrollSpeed;
@property(assign)int spritesNum;
@property(assign)CGSize screenSize;

@end
