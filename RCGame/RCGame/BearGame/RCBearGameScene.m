//
//  RCBearGameScene.m
//  RCGame
//
//  Created by xuzepei on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCBearGameScene.h"


static RCBearGameScene* sharedInstance;
@implementation RCBearGameScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCBearGameScene* layer = [RCBearGameScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCBearGameScene*)sharedInstance
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
        
        //1.生成缓存帧
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear.plist"];
        
        //2.创建批处理节点
        CCSpriteBatchNode* batchNode = [CCSpriteBatchNode batchNodeWithFile:@"bear.png"];
        [self addChild: batchNode];
        
        //3.取得准备要用的帧
        NSMutableArray* walkAnimationFrames = [[[NSMutableArray alloc] init] autorelease];
        for(int i=1; i<=8; i++)
        {
            CCSpriteFrame* spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bear%d.png",i]];
            if(spriteFrame)
                [walkAnimationFrames addObject:spriteFrame];
        }
        
        //4.创建动画
        CCAnimation* walkAnimation = [CCAnimation animationWithSpriteFrames:walkAnimationFrames delay:0.1f];
        
        //5.创建精灵并且让它运行动画
        self.bear = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
        self.bear.position = ccp(screenSize.width/2.0, screenSize.height/2.0);
        
        
        CCAnimate* animate = [CCAnimate actionWithAnimation:walkAnimation];
        self.walkAction = [CCRepeatForever actionWithAction:animate];
        //[self.bear runAction:self.walkAction];
        
        [batchNode addChild:self.bear];//注意，如果在这里我们没有把它加到batchNode中，而是加到当前层里面的话。那么我们将得不到batchNode为我们带来的性能提升!

    }
    
    return self;
}

- (void)dealloc
{
    self.bear = nil;
    self.walkAction = nil;
    self.moveAction = nil;
    
    sharedInstance = nil;

    [super dealloc];
}

- (void)bearMoveEnded
{
    [self.bear stopAction:self.walkAction];
    self.isMoving = NO;
}

#pragma mark - Touch Event

- (void)registerWithTouchDispatcher
{
    [[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    
    NSLog(@"touchLocation0:%@",NSStringFromCGPoint(touchLocation));
    
    touchLocation = [DIRECTOR convertToGL: touchLocation];
    NSLog(@"touchLocation1:%@",NSStringFromCGPoint(touchLocation));
    
    touchLocation = [self convertToNodeSpace:touchLocation];
    NSLog(@"touchLocation2:%@",NSStringFromCGPoint(touchLocation));
    
    //速率
    CGFloat moveVelocity = 480.0/1.0;
    
    //求两点间的偏移量
    CGPoint moveDifference = ccpSub(touchLocation, self.bear.position);
    
    //根据偏移量，求两点间实际移动的距离
    CGFloat distanceToMove = ccpLength(moveDifference);
    
    //计算时间
    CGFloat duration = distanceToMove/moveVelocity;
    
    if(moveDifference.x < 0)
    {
        self.bear.flipX = NO;
    }
    else
    {
        self.bear.flipX = YES;
    }
    
    [self.bear stopAction:self.moveAction];
    if(NO == self.isMoving)
    {
        [self.bear runAction:self.walkAction];
    }
    
    id actionMove = [CCMoveTo actionWithDuration:duration position:touchLocation];
    id actionDone = [CCCallFuncN actionWithTarget:self selector:@selector(bearMoveEnded)];
    self.moveAction = [CCSequence actions:actionMove,actionDone,nil];
    [self.bear runAction:self.moveAction];
    self.isMoving = YES;
}



@end
