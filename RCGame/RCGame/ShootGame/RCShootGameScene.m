//
//  RCShootGameScene.m
//  RCGame
//
//  Created by xuzepei on 5/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCShootGameScene.h"
#import "SimpleAudioEngine.h"
#import "RCShootGameOverScene.h"


static RCShootGameScene* sharedInstance;
@implementation RCShootGameScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCShootGameScene* layer = [RCShootGameScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCShootGameScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        sharedInstance = self;

        self.isTouchEnabled = YES;
        _targets = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        
        CGSize screenSize = WIN_SIZE;
        
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
		[self addChild:colorLayer z:0 tag:SHOOT_GAME_BG_TAG];
        
        CCSprite* player = [CCSprite spriteWithFile:@"player.png"];
        player.position = ccp(player.contentSize.width/2.0,screenSize.height/2.0);
        [self addChild: player];

        [self schedule:@selector(scheduleAddTarget:) interval:1.0];
        
        [self schedule:@selector(update:)];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf" loop:YES];
    }
    
    return self;
}

- (void)dealloc
{
    sharedInstance = nil;
    self.targets = nil;
    self.projectiles = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt
{
    NSMutableArray* projectilesToDelete = [[NSMutableArray alloc] init];
    
    for(CCSprite* projectile in self.projectiles)
    {
        CGRect projectileRect = CGRectMake(
                                           projectile.position.x - (projectile.contentSize.width/2),
                                           projectile.position.y - (projectile.contentSize.height/2),
                                           projectile.contentSize.width,
                                           projectile.contentSize.height);
        
        NSMutableArray* targetsToDelete = [[NSMutableArray alloc] init];
        
        for(CCSprite* target in self.targets)
        {
            CGRect targetRect = CGRectMake(
                                           target.position.x - (target.contentSize.width/2),
                                           target.position.y - (target.contentSize.height/2),
                                           target.contentSize.width,
                                           target.contentSize.height);
            
            //检查矩形相交
            if(CGRectIntersectsRect(projectileRect, targetRect))
            {
                [targetsToDelete addObject:target];
            } 
        }
        
        for(CCSprite* target in targetsToDelete)
        {
            [self.targets removeObject:target];
            [self removeChild:target cleanup:YES]; 
        }
        
        if([targetsToDelete count])
        {
            [projectilesToDelete addObject:projectile];
        }
        
        [targetsToDelete release];
    }
    
    self.projectilesDestoryed += [projectilesToDelete count];
    
    for(CCSprite* projectile in projectilesToDelete)
    {
        [self.projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    
    [projectilesToDelete release];
    
    
    if(self.projectilesDestoryed > 30)
    {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        RCShootGameOverScene* gameOverScene = [RCShootGameOverScene node];
        [gameOverScene.label setString:@"You Win!"];
        [DIRECTOR replaceScene:(CCScene*)gameOverScene];
    }

}

- (void)scheduleAddTarget:(ccTime)dt
{
    [self addTarget];
}

- (void)addTarget
{
    CGSize screenSize = WIN_SIZE;
    
    //设置target，坐标
    CCSprite* target = [CCSprite spriteWithFile:@"target.png"];
    target.tag = SG_TARGET_TAG;
    [self.targets addObject:target];
    
    //计算y值
    int min_y = target.contentSize.height/2.0;
    int max_y = screenSize.height - target.contentSize.height/2.0;
    int rang_y = max_y - min_y;
    int actual_y = (arc4random()%rang_y) + min_y;
    
    target.position = ccp(screenSize.width + target.contentSize.width/2.0,actual_y);
    [self addChild:target];
    
    //计算速度
    int min_duration = 6.0;
    int max_duration = 10.0;
    int range_duration = max_duration - min_duration;
    int actual_duration = (arc4random()%range_duration) + min_duration;
    
    //创建动作
    CGPoint targetPoint = ccp(-target.contentSize.width/2.0, actual_y);
    id actionMove = [CCMoveTo actionWithDuration:actual_duration position:targetPoint];
    //设置动作完成调用方法
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove,actionMoveDone,nil]];
}

- (void)spriteMoveFinished:(id)sender
{
    CCSprite* sprite = (CCSprite*)sender;
    
    if(SG_TARGET_TAG == sprite.tag)
    {
        [self.targets removeObject:sprite];
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        RCShootGameOverScene* gameOverScene = [RCShootGameOverScene node];
        [gameOverScene.label setString:@"You Lose :["];
        [DIRECTOR replaceScene:(CCScene*)gameOverScene];
    }
    else if(SG_PROJECTILE_TAG == sprite.tag)
    {
        [self.projectiles removeObject:sprite];
    }
    
    [self removeChild:sprite cleanup:YES];
}

#pragma mark - Touch Event

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:[touch view]];
    //转换坐标
    CGPoint location = [DIRECTOR convertToGL:endPoint];
    
    CGSize screenSize = WIN_SIZE;
    
    //创建飞盘
    CCSprite* projectile = [CCSprite spriteWithFile:@"projectile.png"];
    projectile.tag = SG_PROJECTILE_TAG;
    [self.projectiles addObject:projectile];
    
    projectile.position = ccp(projectile.contentSize.width, screenSize.height/2.0);
    
    //点击点和飞盘位置间的间隔
    int off_x = location.x - projectile.position.x;
    int off_y = location.y - projectile.position.y;
    if(off_x <= 0)//如果点击点在飞盘左边，则无效
        return;
    [self addChild:projectile];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    
    //计算飞盘最后掉落的目标位置
    int real_x = screenSize.width + projectile.contentSize.width/2.0;
    float ratio = (float)off_y / (float)off_x;
    int real_y = (real_x * ratio) + projectile.position.y;
    CGPoint real_position = ccp(real_x, real_y);
    
    //计算动作时间
    CGFloat distance = ccpDistance(projectile.position, real_position);
    CGFloat velocity = 480/1.0; // 480 pixels/1sec
    CGFloat duration = distance/velocity;
    
    id actionMove = [CCMoveTo actionWithDuration:duration position:real_position];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [projectile runAction:[CCSequence actions:actionMove,actionMoveDone,nil]];
}

@end
