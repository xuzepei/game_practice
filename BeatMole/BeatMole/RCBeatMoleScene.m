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
#import "RCLevel.h"
#import "RCWave.h"
#import "RCNavigationController.h"

#define MAX_SCORE 300

static RCBeatMoleScene* sharedInstance = nil;
@implementation RCBeatMoleScene

+ (id)scene:(int)levelIndex
{
    CCScene* scene = [CCScene node];
    RCBeatMoleScene* layer = [[[RCBeatMoleScene alloc] initWithLevelIndex:levelIndex] autorelease];
    [scene addChild:layer];
    return scene;
}

+ (RCBeatMoleScene*)sharedInstance
{
    return sharedInstance;
}

- (id)initWithLevelIndex:(int)levelIndex
{
    if(self = [super init])
    {
        sharedInstance = self;
        self.isTouchEnabled = YES;
        CGSize winSize = WIN_SIZE;
        self.levelIndex = levelIndex;
        
        memset(_showCount, 0, sizeof(int)*20);
        memset(_killCount, 0, sizeof(int)*20);
        
        _moles = [[NSMutableArray alloc] init];
        _showingHoleSet = [[NSMutableSet alloc] init];
        _showingMoleArray = [[NSMutableArray alloc] init];
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"land.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mole_animation.plist"];

        RCLevel* level = [RCLevel sharedInstance];
        [level updateByLevelNumber:self.levelIndex];
        self.userHP = level.userHP;
        
        //返回按钮
        CCMenuItem* menuItem = [CCMenuItemImage itemWithNormalImage:@"back_button.png" selectedImage:@"back_button_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem.anchorPoint = ccp(0,0.5);
        menuItem.tag = T_BEAT_MOLE_SCENE_BACKBUTTON;
        CCMenu* backMenu = [CCMenu menuWithItems:menuItem,nil];
        backMenu.position = ccp(10, winSize.height - menuItem.contentSize.height/2.0);
        [self addChild:backMenu z:10];
        
        //暂停按钮
        self.pauseMenuItem = [CCMenuItemFont itemWithString:@"暂停" target:self selector:@selector(clickedMenuItem:)];
        [self.pauseMenuItem setFontSize:16];
        self.pauseMenuItem.anchorPoint = ccp(0.5,0.5);
        self.pauseMenuItem.tag = T_BEAT_MOLE_SCENE_PAUSEBUTTON;
        CCMenu* pauseButton = [CCMenu menuWithItems:self.pauseMenuItem,nil];
        pauseButton.position = ccp(winSize.width - self.pauseMenuItem.contentSize.height - 10, winSize.height - self.pauseMenuItem.contentSize.height/2.0 - 10);
        [self addChild:pauseButton z:10];
        
        //添加分数显示
        self.scoreLabel = [CCLabelTTF labelWithString:@"score: 0" fontName:@"Verdana" fontSize:14];
        self.scoreLabel.anchorPoint = ccp(1, 0);
        self.scoreLabel.position = ccp(winSize.width - 10, 10);
        [self addChild:self.scoreLabel z:10];
        
        //添加生命值显示
        self.hpLabel = [CCLabelTTF labelWithString:@"hp: 0" fontName:@"Verdana" fontSize:14];
        self.hpLabel.anchorPoint = ccp(1, 0);
        self.hpLabel.position = ccp(winSize.width - 100, 10);
        [self addChild:self.hpLabel z:10];
        
        //添加地面背景
        NSString* bgImageName = @"land.png";
        if([RCTool isIphone5])
            bgImageName = @"land-568h.png";
        
        CCSprite* dirt = [CCSprite spriteWithSpriteFrameName:bgImageName];
        dirt.position = ccp(winSize.width/2.0, winSize.height/2.0);
        [self addChild:dirt z:-20];

        //设置洞口
        _positionArray = [[NSMutableArray alloc] init];
        
        CGPoint point = ccp(228/2.0, 476.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        point = ccp(630/2.0, 468.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(90/2.0, 372.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(438/2.0, 372.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(776/2.0, 372.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(296/2.0, 264/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(606/2.0, 264/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(190/2.0, 124/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];
        
        
        point = ccp(790/2.0, 118.0/2.0);
        [_positionArray addObject:NSStringFromCGPoint(point)];

        //计算第一波出兵
        NSArray* moles = [self molesForWave:0];
        if([moles count])
        {
            [_moles removeAllObjects];
            [_moles addObjectsFromArray:moles];
        }
        
        [self schedule:@selector(tryPopMoles:) interval:1.0];
        
        //倒计时
//        CCSprite* progressBorder = [CCSprite spriteWithFile:@"progressbarborder.png"];
//        [progressBorder setAnchorPoint:ccp(0,0)];
//        [progressBorder setPosition:ccp(100+progressBorder.contentSize.width,winSize.height - progressBorder.contentSize.height)];
//        [self addChild:progressBorder z:10];
//        
//        CCSprite* progressbarsprite = [CCSprite spriteWithFile:@"progressbar.png"];
//        CCProgressTimer* progressBar = [CCProgressTimer progressWithSprite:progressbarsprite];
//        progressBar.barChangeRate=ccp(1,0);
//        progressBar.midpoint=ccp(0.0,0.0f);
//        [progressBar setAnchorPoint:ccp(0,0)];
//        progressBar.type = kCCProgressTimerTypeBar;
//        [progressBar setPosition:ccp(100+progressBar.contentSize.width,winSize.height - progressBar.contentSize.height)];
//        [self addChild:progressBar];
        
//        CCProgressFromTo *progressTo = [CCProgressFromTo actionWithDuration:60 from:100 to:0];
//        CCCallFunc *timeOut = [CCCallFunc actionWithTarget:self selector:@selector(timeOut:)];
//        CCSequence *sequence = [CCSequence actions:progressTo, timeOut,nil];
//        [progressBar runAction:sequence];
        
        // Preload sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hi.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"yes.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"no.caf"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bg.caf" loop:YES];

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
    self.hpLabel = nil;
    self.positionArray = nil;
    self.showingMoleArray = nil;
    self.showingHoleSet = nil;
    self.pauseMenuItem = nil;
    self.currentWave = nil;
    
    sharedInstance = nil;
    [super dealloc];
}

- (void)update:(ccTime)delta
{
    [self.scoreLabel setString:[NSString stringWithFormat:@"score: %d", self.score]];
    
    [self.hpLabel setString:[NSString stringWithFormat:@"hp: %d",self.userHP]];
    
    if(self.currentWaveNumber > [[RCLevel sharedInstance].waveArray count] || self.userHP <= 0)
    {
        self.isGameOver = YES;
        [self unscheduleUpdate];
        [self unscheduleAllSelectors];
        [self showResult];
    }
}

- (NSArray*)molesForWave:(int)waveNumber
{
    NSMutableArray* moles = [[[NSMutableArray alloc] init] autorelease];
    
    self.currentWaveNumber = waveNumber;
    RCLevel* level = [RCLevel sharedInstance];
    RCUser* user = [RCUser sharedInstance];
    NSMutableSet* moleTypeSet = [[[NSMutableSet alloc] init] autorelease];
    if(self.currentWaveNumber < [level.waveArray count])
    {
        self.currentWave = [level.waveArray objectAtIndex:self.currentWaveNumber];
        NSMutableArray* assignmentArray = self.currentWave.assignmentArray;
        
        //添加正确的小兵
        for(NSDictionary* assignment in assignmentArray)
        {
            NSString* moleType = [assignment objectForKey:@"type"];
            if(0 == [moleType length])
                continue;
            
            [moleTypeSet addObject:moleType];
            
            NSString* count = [assignment objectForKey:@"count"];
            RCMole* mole = nil;
            if(TT_RED == user.teamType)
            {
                for(int i = 0; i < [count intValue]; i++)
                {
                    mole = [RCTool getMoleByTeamType:TT_BLUE moleType:moleType];
                    [moles addObject:mole];
                }
            }
            else if(TT_BLUE == user.teamType)
            {
                for(int i = 0; i < [count intValue]; i++)
                {
                    mole = [RCTool getMoleByTeamType:TT_RED moleType:moleType];
                    [moles addObject:mole];
                }
            }
        }
        
        //添加错误的小兵
        NSArray* moleTypeArray = [moleTypeSet allObjects];
        
        for(int i = 0; i < self.currentWave.wrongShowNumber; i++)
        {
            if(0 == [moleTypeArray count])
                continue;
            
            NSUInteger randomIndex = arc4random() % [moleTypeArray count];
            
            NSString* moleType = [moleTypeArray objectAtIndex:randomIndex];
            
            RCMole* mole = nil;
            if(TT_RED == user.teamType)
            {
                mole = [RCTool getMoleByTeamType:TT_RED moleType:moleType];
            }
            else if(TT_BLUE == user.teamType)
            {
                mole = [RCTool getMoleByTeamType:TT_BLUE moleType:moleType];
            }
            
            [moles addObject:mole];
        }
        
    }
    else
    {
        self.currentWave = nil;
    }
    
    //随机排序数组
    NSUInteger count = [moles count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [moles exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return moles;
}

- (void)tryPopMoles:(ccTime)dt
{
    if(self.isGameOver)
        return;
    
    if(0 == [self.moles count])
        return;
    
    int showingHoleCount = [_showingHoleSet count];
    int addCount = self.currentWave.maxShowNumber - showingHoleCount;
    if(addCount <= 0)
        return;
    
    for(int i = 0; i < addCount && [_moles count]; i++)
    {
        RCMole* mole = [_moles objectAtIndex:0];
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
                    mole.showTime = (self.currentWave.difficultyFactor - mole.speed)*0.1;
                    [mole resetHP];
                    [self addChild:mole];
                    [self popMole:mole];
                    
                    [_moles removeObject:mole];
                }
                
            }while (isUsing);
        }
    }

}

- (void)setTappable:(id)sender
{
    RCMole* mole = (RCMole *)sender;
    mole.clickable = YES;
    mole.hpBar.visible = YES;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"hi.caf"];
}

- (void)unsetTappable:(id)sender
{
    RCMole* mole = (RCMole *)sender;
    mole.clickable = NO;
    mole.hpBar.visible = NO;
}

- (void)popMole:(RCMole *)mole
{
    if (self.userHP <= 0 || self.isGameOver)
        return;
    
    [_showingMoleArray addObject:mole];
    _showCount[mole.id]++;
    
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
    [_showingMoleArray removeObject:mole];
    
    if(0 == [_moles count])
    {
        self.currentWaveNumber++;
        NSArray* moles = [self molesForWave:self.currentWaveNumber];
        if([moles count])
        {
            if(_currentWave)
            {
                [self performSelector:@selector(addMoles:) withObject:moles afterDelay:_currentWave.interval];
            }
        }
    }
}

- (void)addMoles:(id)argument
{
    NSArray* moles = (NSArray*)argument;
    if([moles count])
    {
        [_moles removeAllObjects];
        [_moles addObjectsFromArray:moles];
    }
}

- (void)showResult
{
    int star = 0;
    NSString* tipString = @"胜利过关！";
    if(self.score < [RCLevel sharedInstance].starLevel0 || self.userHP <= 0)
    {
        tipString = @"挑战失败！";
    }
    else if(self.userHP > 0)
    {
        if(self.score >= [RCLevel sharedInstance].starLevel2)
            star = 3;
        else if(self.score >= [RCLevel sharedInstance].starLevel1)
            star = 2;
        else if(self.score >= [RCLevel sharedInstance].starLevel0)
            star = 1;
    }
    
    [self stop];
    
    [RCTool saveLevelResult:self.levelIndex star:star coin:self.score hp:self.userHP rightKillCount:self.rightTapCount wrongKillCount:self.wrongTapCount continuousRightKillCount:self.continuousRightTapCount showCount:_showCount killCount:_killCount idCount:20];
    

    UIView* resultView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].height, [RCTool getScreenSize].width)] autorelease];
    resultView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    RCNavigationController* navigationController = [RCTool getRootNavigationController];
    [navigationController.view addSubview:resultView];
    
//    CGSize screenSize = WIN_SIZE;
//    CCLabelTTF* gameOverLabel = [CCLabelTTF labelWithString:tipString fontName:@"Marker Felt" fontSize:60.0];
//    gameOverLabel.position = ccp(screenSize.width/2, screenSize.height/2);
//    gameOverLabel.scale = 0.1;
//    [self addChild:gameOverLabel z:10];
//    [gameOverLabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
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
    for(RCMole* mole in self.showingMoleArray)
    {
        if(CGRectContainsPoint(mole.boundingBox, touchLocation))
        {
            if(NO == mole.clickable)
                continue;

            mole.beatCount += [RCUser sharedInstance].ap;
            
            BOOL beatAnimation = NO;
            if(mole.teamType != [RCUser sharedInstance].teamType)
            {
                if(mole.beatCount >= mole.hp)//点击足够多次，表示点击成功
                {
                    self.continuousRightTapCount++;
                    self.rightTapCount++;
                    self.score += mole.coin;
                    _killCount[mole.id]++;
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"yes.caf"];
                    mole.clickable = NO;
                    beatAnimation = YES;
                }
            }
            else
            {
                self.continuousRightTapCount = 0;
                self.wrongTapCount++;
                self.userHP -= mole.penalty;
                self.userHP = MAX(0,self.userHP);
                _killCount[mole.id]++;
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"no.caf"];
                
                mole.beatCount = 100000000;
                mole.clickable = NO;
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
