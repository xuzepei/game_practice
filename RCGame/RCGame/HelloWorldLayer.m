//
//  HelloWorldLayer.m
//  RCGame
//
//  Created by xuzepei on 9/18/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "AppDelegate.h"
#import "RCMenuItemFont.h"

#define HELLOW_WORLD_TAG 200
#define SPRITE_FIRE_TAG 201

enum {
    ACTION_EASE = 100,

    };

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        //接收 Touch 事件
        self.isTouchEnabled = YES;
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
        
        label.tag = HELLOW_WORLD_TAG;
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		//显示精灵
        CCSprite* sprite = [CCSprite spriteWithFile:@"fire@2x.png"];
        sprite.tag = SPRITE_FIRE_TAG;
        sprite.anchorPoint = CGPointMake(0, 0); //默认锚点为0.5,0.5
        [self addChild:sprite];
        
        
        //进行行动按钮
        CGFloat fontSize = 16;
        CCLabelTTF *actionlabel = [CCLabelTTF labelWithString:@"EASE_ACTION" fontName:@"Helvetica-Bold" fontSize:fontSize];
        CCMenuItem *actionMenuItem = [CCMenuItemLabel itemWithLabel:actionlabel target:self selector:@selector(clickedActionButton:)];
        actionMenuItem.anchorPoint = CGPointMake(0, 1);
        actionMenuItem.tag = ACTION_EASE;
        CCMenu *actionMenu = [CCMenu menuWithItems:actionMenuItem, nil];
        actionMenu.position = ccp(0, size.height - fontSize);
        [self addChild:actionMenu];
        
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}
									   ];
        
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

#pragma mark - Touch Event

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCNode* node = [self getChildByTag:HELLOW_WORLD_TAG];
    NSAssert([node isKindOfClass:[CCLabelTTF class]], @"node is not a CCLabelTTF!");
    CCLabelTTF* label = (CCLabelTTF*)node;
    label.scale = CCRANDOM_0_1();
}

#pragma mark - Action Practice

- (void)clickedActionButton:(id)sender
{
    CCLOG(@"clickedActionButton");
    CCMenuItem* item = (CCMenuItem*)sender;
    if(ACTION_EASE == item.tag)
    {
        CCSprite* node = (CCSprite*)[self getChildByTag:SPRITE_FIRE_TAG];
        if(node)
        {
            CGSize size = [[CCDirector sharedDirector] winSize];
            
            node.position = ccp(size.width/2.0, size.height/2.0);
            

            CGPoint point = ccp(size.width - node.contentSize.width, size.height- node.contentSize.height);
            CCMoveTo* move = [CCMoveTo actionWithDuration:5 position:point];
            
            //淡入淡出
            CCEaseInOut* ease = [CCEaseInOut actionWithAction:move rate:4];
            
            //先回，再向前
//            CCEaseBackInOut* ease = [CCEaseBackInOut actionWithAction:move];            
            
            //弹力球效果
//            CCEaseBounceInOut* ease = [CCEaseBounceInOut actionWithAction:move];
            
            //橡皮筋效果
//            CCEaseElasticInOut* ease = [CCEaseElasticInOut actionWithAction:move];
            
            //指数效果
//            CCEaseExponentialInOut* ease = [CCEaseExponentialInOut actionWithAction:move];
            
            //正弦效果
//            CCEaseSineInOut* ease = [CCEaseSineInOut actionWithAction:move];
            
            [node runAction:ease];
        }
    }
    
}

@end
