//
//  RCBeatTheMoleScene.m
//  RCGame
//
//  Created by xuzepei on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCBeatTheMoleScene.h"
#import "CCAnimation+Helper.h"
#import "SimpleAudioEngine.h"


static RCBeatTheMoleScene* sharedInstance;
@implementation RCBeatTheMoleScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCBeatTheMoleScene* layer = [RCBeatTheMoleScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCBeatTheMoleScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        sharedInstance = self;
        self.isTouchEnabled = YES;
        CGSize screenSize = WIN_SIZE;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bg_dirt.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btm_grass.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mole_team_0.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mole_team_1.plist"];
        
        //添加背景
        CCSprite* dirt = [CCSprite spriteWithSpriteFrameName:@"bg_dirt.png"];
        dirt.scale = 2.0;
        dirt.position = ccp(screenSize.width/2.0, screenSize.height/2.0);
        [self addChild:dirt z:-2];
        
        //添加分数显示
        self.scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Verdana" fontSize:14];
        self.scoreLabel.anchorPoint = ccp(1, 0);
        self.scoreLabel.position = ccp(screenSize.width - 10, 10);
        [self addChild:self.scoreLabel z:10];
        
        //添加草
        CCSprite* grass_lower = [CCSprite spriteWithSpriteFrameName:@"grass_lower.png"];
        grass_lower.anchorPoint = ccp(0.5, 1);
        grass_lower.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:grass_lower z:1];

        CCSprite* grass_upper = [CCSprite spriteWithSpriteFrameName:@"grass_upper.png"];
        grass_upper.anchorPoint = ccp(0.5, 0);
        grass_upper.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:grass_upper z:-1];
        
        //创建地鼠
        CCSpriteBatchNode* moleBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"mole.png"];
        [self addChild:moleBatchNode z:0];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mole.plist"];
        
        _moles = [[NSMutableArray alloc] init];
        
        CCSprite *mole1 = [CCSprite spriteWithSpriteFrameName:@"mole_1.png"];
        mole1.position = ccp(85, 85);
        [moleBatchNode addChild:mole1];
        [_moles addObject:mole1];
        
        CCSprite *mole2 = [CCSprite spriteWithSpriteFrameName:@"mole_1.png"];
        mole2.position = ccp(240, 85);
        [moleBatchNode addChild:mole2];
        [_moles addObject:mole2];
        
        CCSprite *mole3 = [CCSprite spriteWithSpriteFrameName:@"mole_1.png"];
        mole3.position = ccp(395, 85);
        [moleBatchNode addChild:mole3];
        [_moles addObject:mole3];
        
        
        //创建动画
        NSArray* indexArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"2",@"3",@"1",nil];
        self.laughAnimation = [CCAnimation animationWithFrame:@"mole_laugh" indexArray:indexArray delay:0.1];
        self.laughAnimation.restoreOriginalFrame = YES;
        
        indexArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",nil];
        self.hitAnimation = [CCAnimation animationWithFrame:@"mole_thump" indexArray:indexArray delay:0.02];
        
//        [[CCAnimationCache sharedAnimationCache] addAnimation:laughAnimation name:@"laugh_animation"];
//        [[CCAnimationCache sharedAnimationCache] addAnimation:hitAnimation name:@"hit_animation"];
        
        [self schedule:@selector(tryPopMoles:) interval:0.5];
        
        // Preload sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"laugh.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ow.caf"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"whack.caf" loop:YES];
    }
    
    return self;
}

- (void)dealloc
{
    self.moles = nil;
    self.laughAnimation = nil;
    self.hitAnimation = nil;
    self.scoreLabel = nil;
    
    sharedInstance = nil;
    [super dealloc];
}

- (void)tryPopMoles:(ccTime)dt
{
    if(self.isGameOver)
        return;
    
    [self.scoreLabel setString:[NSString stringWithFormat:@"Score: %d", self.score]];
    
    if(self.molePopCount >= 50)
    {
        CGSize screenSize = WIN_SIZE;
        
        CCLabelTTF* gameOverLabel = [CCLabelTTF labelWithString:@"Level Complete!" fontName:@"Verdana" fontSize:40.0];
        gameOverLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        gameOverLabel.scale = 0.1;
        [self addChild:gameOverLabel z:10];
        [gameOverLabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
        
        self.isGameOver = true;
        return;
        
    }
    
    for(CCSprite* mole in self.moles)
    {
        if(arc4random()%3 == 0)
        {
            if(0 == mole.numberOfRunningActions)
            {
                [self popMole:mole];
            }
        }
    }
}

- (void)setTappable:(id)sender
{
    CCSprite* mole = (CCSprite *)sender;
    [mole setUserData:YES];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"laugh.caf"];
}

- (void)unsetTappable:(id)sender
{
    CCSprite* mole = (CCSprite *)sender;
    [mole setUserData:NO];
}

- (void)popMole:(CCSprite *)mole
{
    if (self.molePopCount > 50)
        return;
    self.molePopCount++;
    
    
    CCMoveBy* moveUp = [CCMoveBy actionWithDuration:0.2
                                           position:ccp(0, mole.contentSize.height)];
    
    CCCallFunc *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCCallFunc *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unsetTappable:)];
    
    CCEaseInOut* easeMoveUp = [CCEaseInOut actionWithAction:moveUp rate:3.0];
    CCAction *easeMoveDown = [easeMoveUp reverse];
    //CCDelayTime *delay = [CCDelayTime actionWithDuration:0.5];
    CCAnimate* laughAnimate = [CCAnimate actionWithAnimation:self.laughAnimation];
    
    [mole runAction:[CCSequence actions:easeMoveUp, setTappable,laughAnimate, unsetTappable, easeMoveDown, nil]];
}

#pragma mark - Touch Event

- (void)registerWithTouchDispatcher
{
    [[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    for(CCSprite* mole in self.moles)
    {
        if(NO == mole.userData)
            continue;
        
        if(CGRectContainsPoint(mole.boundingBox, touchLocation))
        {
            mole.userData = NO;
            self.score += 10;
            [mole stopAllActions];
            
            CCAnimate* hit = [CCAnimate actionWithAnimation:self.hitAnimation];
            CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.2 position:ccp(0, -mole.contentSize.height)];
            CCEaseInOut *easeMoveDown = [CCEaseInOut actionWithAction:moveDown rate:3.0];
            [mole runAction:[CCSequence actions:hit,easeMoveDown, nil]];
        }
    }
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //    CGPoint touchLocation = [touch locationInView: [touch view]];
    //    touchLocation = [DIRECTOR convertToGL: touchLocation];
    //    touchLocation = [self convertToNodeSpace:touchLocation];
}

@end
