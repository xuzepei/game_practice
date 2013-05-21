//
//  RCShootGameOverScene.m
//  RCGame
//
//  Created by xuzepei on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCShootGameOverScene.h"
#import "RCShootGameScene.h"

@implementation RCShootGameOverScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCShootGameScene* layer = [RCShootGameScene node];
    [scene addChild:layer];
    return scene;
}

- (id)init
{
    if(self = [super init])
    {
        CGSize screenSize = WIN_SIZE;
        
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 0)];
		[self addChild:colorLayer z:0 tag:SG_GAME_OVER_BG_TAG];
        
		self.label = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:30];
		self.label.position = ccp(screenSize.width/2, screenSize.height/2);
        self.label.tag = SG_GAME_OVER_LABEL_TAG;
		[self addChild:self.label];
        
        
        //创建动作
        id actionDelayTime = [CCDelayTime actionWithDuration:3];
        //设置动作完成调用方法
        id actionDone = [CCCallFuncN actionWithTarget:self selector:@selector(gameOverDone)];

        [self runAction:[CCSequence actions:actionDelayTime,actionDone,nil]];
    }
    
    return self;
}

- (void)dealloc
{
    self.label = nil;
    
    [super dealloc];
}

- (void)gameOverDone
{
    [DIRECTOR replaceScene:[RCShootGameScene node]];
}

@end
