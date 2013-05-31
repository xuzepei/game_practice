//
//  RCBeatMoleScene.m
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCBeatMoleScene.h"
#import "CCAnimation+Helper.h"
#import "SimpleAudioEngine.h"
#import "RCTool.h"
#import "RCMole.h"
#import "RCUser.h"
#import "RCSelectLevelScene.h"

#define MAX_SCORE 300

static RCBeatMoleScene* sharedInstance = nil;
@implementation RCBeatMoleScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCBeatMoleScene* layer = [RCBeatMoleScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCBeatMoleScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        sharedInstance = self;
        self.isTouchEnabled = YES;
        CGSize winSize = WIN_SIZE;
        
        //返回按钮
        CCMenuItem* menuItem = [CCMenuItemImage itemWithNormalImage:@"back_button.png" selectedImage:@"back_button_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem.anchorPoint = ccp(0,0.5);
        menuItem.tag = T_BEAT_MOLE_SCENE_BACKBUTTON;
        CCMenu* backMenu = [CCMenu menuWithItems:menuItem,nil];
        backMenu.position = ccp(10, winSize.height - menuItem.contentSize.height/2.0);
        [self addChild:backMenu];
        
        //暂停按钮
        self.pauseMenuItem = [CCMenuItemFont itemWithString:@"暂停" target:self selector:@selector(clickedMenuItem:)];
        [self.pauseMenuItem setFontSize:16];
        self.pauseMenuItem.anchorPoint = ccp(0.5,0.5);
        self.pauseMenuItem.tag = T_BEAT_MOLE_SCENE_PAUSEBUTTON;
        CCMenu* pauseButton = [CCMenu menuWithItems:self.pauseMenuItem,nil];
        pauseButton.position = ccp(winSize.width - self.pauseMenuItem.contentSize.height - 10, winSize.height - self.pauseMenuItem.contentSize.height/2.0 - 10);
        [self addChild:pauseButton];
        
        
        //添加分数显示
        self.scoreLabel = [CCLabelTTF labelWithString:@"score: 0" fontName:@"Verdana" fontSize:14];
        self.scoreLabel.anchorPoint = ccp(1, 0);
        self.scoreLabel.position = ccp(winSize.width - 10, 10);
        [self addChild:self.scoreLabel z:10];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"land.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bm_bg.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mole_team_0.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mole_team_1.plist"];
        
        //添加地面背景
        CCSprite* dirt = [CCSprite spriteWithSpriteFrameName:@"land.png"];
        dirt.position = ccp(winSize.width/2.0, winSize.height/2.0);
        [self addChild:dirt z:-20];
        

        //分层草地背景
        CGFloat offset_y = winSize.height;
        CCSprite* bg0 = [CCSprite spriteWithSpriteFrameName:@"bm_bg0.png"];
        bg0.anchorPoint = ccp(0, 1);
        bg0.position = ccp(0, offset_y);
        [self addChild:bg0 z:-10];
        offset_y -= bg0.contentSize.height;
        
        CCSprite* bg1 = [CCSprite spriteWithSpriteFrameName:@"bm_bg1.png"];
        bg1.anchorPoint = ccp(0, 1);
        bg1.position = ccp(0,offset_y);
        [self addChild:bg1 z:-8];
        offset_y -= bg1.contentSize.height;
        
        CCSprite* bg2 = [CCSprite spriteWithSpriteFrameName:@"bm_bg2.png"];
        bg2.anchorPoint = ccp(0, 1);
        bg2.position = ccp(0, offset_y);
        [self addChild:bg2 z:-6];
        offset_y -= bg2.contentSize.height;
        
        CCSprite* bg3 = [CCSprite spriteWithSpriteFrameName:@"bm_bg3.png"];
        bg3.anchorPoint = ccp(0, 1);
        bg3.position = ccp(0, offset_y);
        [self addChild:bg3 z:-4];
        offset_y -= bg3.contentSize.height;
        
        CCSprite* bg4 = [CCSprite spriteWithSpriteFrameName:@"bm_bg4.png"];
        bg4.anchorPoint = ccp(0, 1);
        bg4.position = ccp(0, offset_y);
        [self addChild:bg4 z:-2];
        offset_y -= bg4.contentSize.height;
        

        //设置洞口
        _positionArray = [[NSMutableArray alloc] init];
        
        CGPoint point = ccp(228/2.0, 496.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        point = ccp(630/2.0, 488.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(90/2.0, 392.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(438/2.0, 392.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(776/2.0, 392.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(296/2.0, 284/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(606/2.0, 284/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(190/2.0, 144/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(790/2.0, 138.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];

        
        NSArray* redTeamMoles = [RCTool getMoleByTeamType:TT_RED];
        NSArray* blueTeamMoles = [RCTool getMoleByTeamType:TT_BLUE];
        
        _moles = [[NSMutableArray alloc] init];
        [_moles addObjectsFromArray:redTeamMoles];
        [_moles addObjectsFromArray:blueTeamMoles];

        _showingHoleSet = [[NSMutableSet alloc] init];
        
        [self schedule:@selector(tryPopMoles:) interval:2.0];
        
        //倒计时
        CCSprite* progressBorder = [CCSprite spriteWithFile:@"progressbarborder.png"];
        [progressBorder setAnchorPoint:ccp(0,0)];
        [progressBorder setPosition:ccp(100+progressBorder.contentSize.width,winSize.height - progressBorder.contentSize.height)];
        [self addChild:progressBorder z:10];
        
        CCSprite* progressbarsprite = [CCSprite spriteWithFile:@"progressbar.png"];
        CCProgressTimer* progressBar = [CCProgressTimer progressWithSprite:progressbarsprite];
        progressBar.barChangeRate=ccp(1,0);
        progressBar.midpoint=ccp(0.0,0.0f);
        [progressBar setAnchorPoint:ccp(0,0)];
        progressBar.type = kCCProgressTimerTypeBar;
        [progressBar setPosition:ccp(100+progressBar.contentSize.width,winSize.height - progressBar.contentSize.height)];
        [self addChild:progressBar];
        
        CCProgressFromTo *progressTo = [CCProgressFromTo actionWithDuration:60 from:100 to:0];
        CCCallFunc *timeOut = [CCCallFunc actionWithTarget:self selector:@selector(timeOut:)];
        CCSequence *sequence = [CCSequence actions:progressTo, timeOut,nil];
        [progressBar runAction:sequence];
        
        // Preload sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hi.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"yes.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"no.caf"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bg.caf" loop:YES];
        
        
//        RCMole* mole = [_moles lastObject];
//        NSString* pointString = [_positionArray objectAtIndex:0];
//        mole.position = CGPointFromString(pointString);
//        [_showingHoleSet addObject:@"0"];
//        mole.showingHoleIndex = 0;
//        [self addChild:mole];
//        [self popMole:mole];
        
        [self scheduleUpdate];
        
    }
    
    return self;
}

- (void)dealloc
{
    self.moles = nil;
    self.laughAnimation = nil;
    self.hitAnimation = nil;
    self.scoreLabel = nil;
    self.positionArray = nil;
    self.layerZIndex = nil;
    self.showingHoleSet = nil;
    self.pauseMenuItem = nil;
    
    sharedInstance = nil;
    [super dealloc];
}

- (void)update:(ccTime)delta
{
    [self.scoreLabel setString:[NSString stringWithFormat:@"score: %d", self.score]];
}

- (void)tryPopMoles:(ccTime)dt
{
    if(self.isGameOver)
        return;
    
    if(self.score >= MAX_SCORE)
    {
        CGSize screenSize = WIN_SIZE;
        
        CCLabelTTF* gameOverLabel = [CCLabelTTF labelWithString:@"胜利过关！" fontName:@"Marker Felt" fontSize:60.0];
        gameOverLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        gameOverLabel.scale = 0.1;
        [self addChild:gameOverLabel z:10];
        [gameOverLabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
        
        self.isGameOver = YES;
        return;
        
    }
    
    if([_showingHoleSet count] < [_positionArray count])
    {
        for(RCMole* mole in self.moles)
        {
            if(arc4random()%[self.moles count] == 0)
            {
                if(0 == mole.numberOfRunningActions && -1 == mole.showingHoleIndex)
                {
                    BOOL isUsing = YES;
                    do
                    {
                        int holeIndex = arc4random()%[_positionArray count];
                        NSString* holeIndexString = [NSString stringWithFormat:@"%d",holeIndex];
                        isUsing = [_showingHoleSet containsObject:holeIndexString];
                        
                        if(NO == isUsing)
                        {
                            NSString* pointString = [_positionArray objectAtIndex:holeIndex];
                            mole.position = CGPointFromString(pointString);
                            [_showingHoleSet addObject:holeIndexString];
                            mole.showingHoleIndex = holeIndex;
                            [mole resetHP];
                            [self addChild:mole];
                            [self popMole:mole];
                        }
                        
                    }while (isUsing);
                }
            }
        }
    }
}

- (void)setTappable:(id)sender
{
    RCMole* mole = (RCMole *)sender;
    [mole setUserData:YES];
    
    mole.hpBar.visible = YES;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"hi.caf"];
}

- (void)unsetTappable:(id)sender
{
    RCMole* mole = (RCMole *)sender;
    [mole setUserData:NO];
    mole.hpBar.visible = NO;
}

- (void)popMole:(RCMole *)mole
{
    if (self.score >= MAX_SCORE)
        return;
    
    CCCallFunc *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCCallFunc *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unsetTappable:)];
    CCCallFunc *resetAction = [CCCallFuncN actionWithTarget:self selector:@selector(reset:)];

    CCAnimate* moveUp = [CCAnimate actionWithAnimation:mole.moveUpAnimation];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:mole.showTime];
    CCAnimate* moveDown = [CCAnimate actionWithAnimation:mole.moveDownAnimation];
    
    [mole runAction:[CCSequence actions:unsetTappable,moveUp,setTappable,delay,unsetTappable,moveDown,resetAction,nil]];
}

- (void)reset:(id)sender
{
    RCMole* mole = (RCMole*)sender;
    NSString* holeIndexString = [NSString stringWithFormat:@"%d",mole.showingHoleIndex];
    [_showingHoleSet removeObject:holeIndexString];
    mole.showingHoleIndex = -1;
    [mole removeFromParentAndCleanup:NO];
    
//    RCMole* mole1 = [_moles lastObject];
//    NSString* pointString = [_positionArray objectAtIndex:0];
//    mole1.position = CGPointFromString(pointString);
//    [_showingHoleSet addObject:@"0"];
//    mole1.showingHoleIndex = 0;
//    [self addChild:mole1];
//    [self popMole:mole1];
}

- (void)timeOut:(id)sender
{
    NSString* tipString = @"胜利过关！";
    if(self.score < MAX_SCORE)
    {
        tipString = @"挑战失败！";
    }
    
    CGSize screenSize = WIN_SIZE;
    CCLabelTTF* gameOverLabel = [CCLabelTTF labelWithString:tipString fontName:@"Marker Felt" fontSize:60.0];
    gameOverLabel.position = ccp(screenSize.width/2, screenSize.height/2);
    gameOverLabel.scale = 0.1;
    [self addChild:gameOverLabel z:10];
    [gameOverLabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
    self.isGameOver = YES;
}

- (void)stop
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)clickedMenuItem:(id)sender
{
    CCMenuItem* menuItem = (CCMenuItem*)sender;
    CCLOG(@"%d",menuItem.tag);
    switch (menuItem.tag)
    {
        case T_BEAT_MOLE_SCENE_BACKBUTTON:
        {
            [self stop];
            
            CCScene* scene = [RCSelectLevelScene scene];
            [DIRECTOR replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
            
            break;
        }
        case T_BEAT_MOLE_SCENE_PAUSEBUTTON:
        {
            if([DIRECTOR isPaused])
            {
                [self.pauseMenuItem setString:@"暂停"];
                [DIRECTOR resume];
            }
            else
            {
                [self.pauseMenuItem setString:@"继续"];
                [DIRECTOR pause];
            }
        }
        default:
            break;
    }
}

#pragma mark - Touch Event

- (void)registerWithTouchDispatcher
{
    [[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    for(RCMole* mole in self.moles)
    {
        if(NO == mole.userData)
            continue;
        
        if(CGRectContainsPoint(mole.boundingBox, touchLocation))
        {
            mole.beatCount++;
            
            BOOL beatAnimation = NO;
            if(mole.teamType != [RCUser sharedInstance].teamType)
            {
                if(mole.beatCount >= mole.hp)//点击足够多次，表示点击成功
                {
                    self.continuousRightTapCount++;
                    self.rightTapCount++;
                    self.score += mole.coin;
                    [[SimpleAudioEngine sharedEngine] playEffect:@"yes.caf"];
                    mole.userData = NO;
                    beatAnimation = YES;
                }
            }
            else
            {
                self.continuousRightTapCount = 0;
                self.wrongTapCount++;
                self.score -= mole.penalty;
                [[SimpleAudioEngine sharedEngine] playEffect:@"no.caf"];
                
                mole.userData = NO;
                beatAnimation = YES;
            }
            
            if(beatAnimation)
            {
                [mole stopAllActions];

                CCAnimate* beatMoveDown = [CCAnimate actionWithAnimation:mole.beatMoveDownAnimation];
                CCCallFunc *resetAction = [CCCallFuncN actionWithTarget:self selector:@selector(reset:)];
                [mole runAction:[CCSequence actions:beatMoveDown,resetAction,nil]];
            }
        }
    }
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end
