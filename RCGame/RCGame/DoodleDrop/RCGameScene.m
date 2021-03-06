//
//  RCGameScene.m
//  RCGame
//
//  Created by xuzepei on 1/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCGameScene.h"
#import "SimpleAudioEngine.h"

#define PLAYER_TAG 100
#define SPIDER_TAG 101
#define PLAYER_NAME_TAG 102

@implementation RCGameScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    CCLayer* layer = [RCGameScene node];
    [scene addChild: layer];
    
    return scene;
}

- (id)init
{
    if(self = [super init])
    {
        LOG_HERE;
        
        self.isAccelerometerEnabled = YES;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        player = [CCSprite spriteWithFile:@"alien@2x.png"];
        float imageWidth = player.contentSize.width;
        float imageHeight = player.contentSize.height;
        player.position = ccp(screenSize.width/2.0, imageHeight/2.0);
        [self addChild:player z:0 tag:PLAYER_TAG];
 
        
        CCLabelTTF* nameLabel = [CCLabelTTF labelWithString:@"OHanzi" fontName:@"Helvetica" fontSize:12];
        nameLabel.position = ccp(imageWidth/2.0, imageHeight + 10);
        [player addChild:nameLabel z:0 tag:PLAYER_NAME_TAG];
//        [nameLabel runAction:[CCFollow actionWithTarget:player]];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"blues.mp3" loop:YES];
        
        [self initSpiders];
        [self initScoreLabel];
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)dealloc
{
    LOG_HERE;
    
    [spiders release];
    spiders = nil;
    
    [super dealloc];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{    
    CGFloat deceleration = 0.4f; //该变量越大使得方向改变越困难
    CGFloat sensitivity = 6.0f;//该变量越大使得移动越大
    CGFloat maxVelocity = 100;
    
    playerVelocity.x = playerVelocity.x * deceleration +acceleration.x * sensitivity;
    
    if(playerVelocity.x > maxVelocity)
    {
        playerVelocity.x = maxVelocity;
    }
    else if(playerVelocity.x < -1 * maxVelocity)
    {
        playerVelocity.x = -1 * maxVelocity;
    }
    
    playerVelocity.y = playerVelocity.y * deceleration +acceleration.y * sensitivity;
    
    if(playerVelocity.y > maxVelocity)
    {
        playerVelocity.y = maxVelocity;
    }
    else if(playerVelocity.y < -1 * maxVelocity)
    {
        playerVelocity.y = -1 * maxVelocity;
    }
}

- (void)update:(ccTime)delta
{
    totalTime += delta*10;
    if(score < totalTime)
    {
        score = totalTime;
    }
    
    if(scoreLabel)
        [scoreLabel setString:[NSString stringWithFormat:@"第 %d 波", numSpidersMoved/8 + 1]];
    
    CGPoint pos = player.position;
    pos.x += playerVelocity.x;
    pos.y += playerVelocity.y;
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float imageWidth = [player texture].contentSize.width;
    float leftBorderLimit = imageWidth/2.0;
    float rightBorderLimit = screenSize.width - imageWidth/2.0;
    
    float topBorderLimit = screenSize.height - imageWidth/2.0;
    float bottomBorderLimit = imageWidth/2.0;
    
    if(pos.x < leftBorderLimit)
    {
        pos.x = leftBorderLimit;
        playerVelocity.x = 0;
    }
    else if(pos.x > rightBorderLimit)
    {
        pos.x = rightBorderLimit;
        playerVelocity.x = 0;
    }
    
    if(pos.y < bottomBorderLimit)
    {
        pos.y = bottomBorderLimit;
        playerVelocity.y = 0;
    }
    else if(pos.x > topBorderLimit)
    {
        pos.x = topBorderLimit;
        playerVelocity.y = 0;
    }

    player.position = pos;
    
    [self checkForCollision];
}

- (void)initSpiders
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSprite* spider = [CCSprite spriteWithFile:@"spider@2x.png"];
    CGFloat imageWidth = [spider texture].contentSize.width;
    int spiderCount = screenSize.width / imageWidth;
    
    if(nil == spiders)
    {
        spiders = [[CCArray alloc] initWithCapacity:spiderCount];
        for(int i = 0; i < spiderCount; i++)
        {
            CCSprite* spider = [CCSprite spriteWithFile:@"spider@2x.png"];
            [self addChild:spider z:0 tag:SPIDER_TAG];
            [spiders addObject:spider];
        }
    }
    
    [self arrangeSpiders];
}

- (void)arrangeSpiders
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSprite* spider = [spiders lastObject];
    CGSize size = [spider texture].contentSize;
    
    int spiderCount = [spiders count];
    for (int i = 0; i < spiderCount; i++)
    {
        CCSprite* spider = [spiders objectAtIndex:i];
        spider.position = CGPointMake(size.width * i + size.width * 0.5f,screenSize.height + size.height);
        [spider stopAllActions];
    }
    
    [self unschedule:@selector(spidersUpdate:)];
    [self schedule:@selector(spidersUpdate:) interval:0.7f];
    
    numSpidersMoved = 0;
    spiderMoveDuration = 6.0f;
}

- (void)spidersUpdate:(ccTime)delta
{
    for(int i = 0; i < 10; i++)
    {
        int randomSpiderIndex = CCRANDOM_0_1() * [spiders count];
        CCSprite* spider = [spiders objectAtIndex:randomSpiderIndex];
        
        //如果选中的Spider没有行动
        if(0 == [spider numberOfRunningActions])
        {
            [self runSpiderMoveSequence:spider];
            break;
        }
    }
}

- (void)runSpiderMoveSequence:(CCSprite*)spider
{
    if(numSpidersMoved % 8 == 0 && spiderMoveDuration > 0.0f)
    {
        spiderMoveDuration -= 0.2f;
    }
    
    CGPoint belowScreenPosition = CGPointMake(spider.position.x,-1 * [spider texture].contentSize.height);
    
    CCMoveTo* move = [CCMoveTo actionWithDuration:spiderMoveDuration
                                         position:belowScreenPosition];
    
    CCCallFuncN* callDidDrop = [CCCallFuncN actionWithTarget:self
                                                    selector:@selector(spiderDidDrop:)];
    CCSequence* sequence = [CCSequence actions:move, callDidDrop, nil];
    [spider runAction:sequence];
}

- (void)spiderDidDrop:(id)sender
{
    // Make sure sender is actually of the right class.
    NSAssert([sender isKindOfClass:[CCSprite class]], @"sender is not a CCSprite!");
    CCSprite* spider = (CCSprite*)sender;
    // move the spider back up outside the top of the screen
    CGPoint pos = spider.position;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    pos.y = screenSize.height + [spider texture].contentSize.height; spider.position = pos;
    
    numSpidersMoved++;
}

- (void)checkForCollision
{
    // Assumption: both player and spider images are squares.
    float playerImageSize = [player texture].contentSize.width;
    float spiderImageSize = [[spiders lastObject] texture].contentSize.width;

    float playerCollisionRadius = playerImageSize * 0.4f;
    float spiderCollisionRadius = spiderImageSize * 0.4f;
    
    // This collision distance will roughly equal the image shapes.
    float maxCollisionDistance = playerCollisionRadius + spiderCollisionRadius;
    int numSpiders = [spiders count];
    for(int i = 0; i < numSpiders; i++)
    {
        CCSprite* spider = [spiders objectAtIndex:i];
        if(0 == [spider numberOfRunningActions])
        {
            // This spider isn't even moving so we can skip checking it.
            continue;
        }
        
        // Get the distance between player and spider.
        float actualDistance = ccpDistance(player.position, spider.position);
        // Are the two objects closer than allowed?
        if(actualDistance < maxCollisionDistance)
        {
            // Game Over (just restart the game for now)
            [self arrangeSpiders];
            break;
        }
    }
}

- (void)initScoreLabel
{
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:48];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    scoreLabel.position = CGPointMake(screenSize.width / 2, screenSize.height);
    
    // Adjust the label's anchorPoint's y position to make it align with the top.
    scoreLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
    // Add the score label with z value of -1 so it's drawn below everything else
    [self addChild:scoreLabel z:-1];
}

@end
