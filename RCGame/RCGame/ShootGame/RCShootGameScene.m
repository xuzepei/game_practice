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
#import "RCMonster.h"

#define LEVEL_MAX_KILL_COUNT 5
#define MAX_LEVEL 3

static RCShootGameScene* sharedInstance = nil;
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
        self.level = 1;
        
        CGSize screenSize = WIN_SIZE;
        
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
		[self addChild:colorLayer z:0 tag:SHOOT_GAME_BG_TAG];
        
        self.levelLabel = [CCLabelTTF labelWithString:@"Level: 0" fontName:@"Verdana" fontSize:14];
        self.levelLabel.color = ccc3(0, 0, 0);
        self.levelLabel.anchorPoint = ccp(0, 1);
        self.levelLabel.position = ccp(10, screenSize.height - 10);
        [self addChild:self.levelLabel z:10];
        
        self.killCountLabel = [CCLabelTTF labelWithString:@"Kill Enemy: 0" fontName:@"Verdana" fontSize:14];
        self.killCountLabel.color = ccc3(0, 0, 0);
        self.killCountLabel.anchorPoint = ccp(1, 0);
        self.killCountLabel.position = ccp(screenSize.width - 10, 10);
        [self addChild:self.killCountLabel z:10];
        
        
        self.player = [CCSprite spriteWithFile:@"player2.png"];
        self.player.position = ccp(self.player.contentSize.width/2.0,screenSize.height/2.0);
        [self addChild: self.player];

        [self schedule:@selector(scheduleAddTarget:) interval:1.0];
        
        [self schedule:@selector(update:)];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf" loop:YES];
        
        [self start];
    }
    
    return self;
}

- (void)dealloc
{
    self.targets = nil;
    self.projectiles = nil;
    self.player = nil;
    self.levelLabel = nil;
    self.killCountLabel = nil;
    sharedInstance = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt
{
    //刷新数量
    [self.levelLabel setString:[NSString stringWithFormat:@"Level: %d",self.level]];
    [self.killCountLabel setString:[NSString stringWithFormat:@"Kill enemy: %d",self.targetsDestoryed]];
    
    if(NO == self.isGameProgressing)
        return;
    
    //检测子弹和敌人碰撞
    NSMutableArray* projectilesToDelete = [[NSMutableArray alloc] init];
    
    for(CCSprite* projectile in self.projectiles)
    {
        CGRect projectileRect = CGRectMake(
                                           projectile.position.x - (projectile.contentSize.width/2),
                                           projectile.position.y - (projectile.contentSize.height/2),
                                           projectile.contentSize.width,
                                           projectile.contentSize.height);
        
        BOOL monsterHit = NO;
        NSMutableArray* targetsToDelete = [[NSMutableArray alloc] init];
        
        for(CCSprite* target in self.targets)
        {
            CGRect targetRect = CGRectMake(
                                           target.position.x - (target.contentSize.width/2),
                                           target.position.y - (target.contentSize.height/2),
                                           target.contentSize.width,
                                           target.contentSize.height);
            
            //检查矩形相交,检测碰撞，根据血量判断是否击毙
            if(CGRectIntersectsRect(projectileRect, targetRect))
            {
                monsterHit = YES;
                RCMonster* monster = (RCMonster*)target;
                monster.hp--;
                if(monster.hp <= 0)
                {
                    [targetsToDelete addObject:target];
                }
                
                break;
            }
        }
        
        //如果打中了，则删除消耗的子弹，并播放声音
        if(monsterHit)
        {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
        }
        
        //删除被击毙的目标
        for(CCSprite* target in targetsToDelete)
        {
            [self.targets removeObject:target];
            [self removeChild:target cleanup:YES]; 
        }

        //记录被击毙的敌人数量
        self.targetsDestoryed += [targetsToDelete count];
        
        [targetsToDelete release];
    }
    
    //移除消耗的子弹
    for(CCSprite* projectile in projectilesToDelete)
    {
        [self.projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    
    [projectilesToDelete release];
    
    
    //判断是否击毙超过等级数目敌人，超过判定胜利
    if(self.targetsDestoryed >= LEVEL_MAX_KILL_COUNT)
    {
        self.level++;
        
        if(self.level > MAX_LEVEL)
        {
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            RCShootGameOverScene* gameOverScene = [RCShootGameOverScene node];
            [gameOverScene.label setString:@"You Win!"];
            [DIRECTOR replaceScene:(CCScene*)gameOverScene];
        }
        else
        {
            [self reset];
            
            CGSize screenSize = WIN_SIZE;
            CCLabelTTF* levelTipLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d wave!",self.level] fontName:@"Verdana" fontSize:40.0];
            levelTipLabel.tag = SG_LEVEL_TIP_TAG;
            levelTipLabel.color = ccc3(0, 0, 0);
            levelTipLabel.position = ccp(screenSize.width/2, screenSize.height/2);
            levelTipLabel.scale = 0.1;
            [self addChild:levelTipLabel z:10];
            
            id scaleToBig = [CCScaleTo actionWithDuration:0.5 scale:1.0];
            id scaleToSmall = [CCScaleTo actionWithDuration:0.5 scale:0.1];
            id actionDelayTime = [CCDelayTime actionWithDuration:1];
            CCCallFunc* doneAction = [CCCallFuncN actionWithTarget:self selector:@selector(finishedLevelTip)];

           [levelTipLabel runAction:[CCSequence actions:scaleToBig,actionDelayTime,scaleToSmall,doneAction,nil]];
        }
    }

}

- (void)scheduleAddTarget:(ccTime)dt
{
    if(NO == self.isGameProgressing)
        return;
    
    //添加敌人
    [self addTarget];
}

- (void)addTarget
{
    CGSize screenSize = WIN_SIZE;
    
    //设置target，坐标
    //CCSprite* target = [CCSprite spriteWithFile:@"target.png"];
    RCMonster* target = nil;
    if ((arc4random() %2) ==0)
    {
        target = [RCWeakAndFastMonster monster];
        target.hp *= self.level;
        target.minMoveDuration /= self.level;
        target.maxMoveDuration /= self.level;
    }
    else
    {
        target = [RCStrongAndSlowMonster monster];
        target.hp *= self.level;
        target.minMoveDuration /= self.level;
        target.maxMoveDuration /= self.level;
    }
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
    int min_duration = target.minMoveDuration;
    int max_duration = target.maxMoveDuration;
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

- (void)reset
{
    for(CCSprite* target in self.targets)
    {
        [self removeChild:target cleanup:YES];
    }
    
    [self.targets removeAllObjects];
    
    
    for(CCSprite* projectile in self.projectiles)
    {
        [self removeChild:projectile cleanup:YES];
    }
    
    [self.projectiles removeAllObjects];
    
    self.targetsDestoryed = 0;
    self.isGameProgressing = NO;
}

- (void)start
{
    self.isGameProgressing = YES;
}

- (void)finishedLevelTip
{
    [self removeChildByTag:SG_LEVEL_TIP_TAG cleanup:YES];
    
    [self start];
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
    CCSprite* projectile = [CCSprite spriteWithFile:@"projectile2.png"];
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
    
    //炮塔旋转角度
    float angleRadians = atanf(ratio);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocos2dAngle = -1* angleDegrees; //cocos2d中顺时针转动角度为负数
    _player.rotation = cocos2dAngle;
    
    //计算动作时间
    CGFloat distance = ccpDistance(projectile.position, real_position);
    CGFloat velocity = 480/1.0; // 480 pixels/1sec
    CGFloat duration = distance/velocity;
    
    id actionMove = [CCMoveTo actionWithDuration:duration position:real_position];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [projectile runAction:[CCSequence actions:actionMove,actionMoveDone,nil]];
}

@end
