//
//  RCHomeScene.m
//  BeatMole
//
//  Created by xuzepei on 5/28/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCHomeScene.h"
#import "RCTool.h"
#import "RCSelectTeamScene.h"
#import "RCSettingsViewController.h"
#import "RCNavigationController.h"


static RCHomeScene* sharedInstance = nil;
@implementation RCHomeScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCHomeScene* layer = [RCHomeScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCHomeScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        sharedInstance = self;
        //self.isTouchEnabled = YES;
        CGSize winSize = WIN_SIZE;
        
        //设置背景
        NSString* bgImageName = @"home_bg.png";
        if([RCTool isIphone5])
            bgImageName = @"home_bg-568h.png";
        CCSprite* bgSprite = [CCSprite spriteWithFile:bgImageName];
        bgSprite.position = ccp(winSize.width/2.0, winSize.height/2.0);
        [self addChild:bgSprite];
        
        
        //设置菜单
        //左菜单
        CGFloat fontSize = 16;
        CCLabelTTF* textlabel = [CCLabelTTF labelWithString:@"关卡模式" fontName:@"Helvetica-Bold" fontSize:fontSize];
        CCMenuItem* menuItem0 = [CCMenuItemLabel itemWithLabel:textlabel target:self selector:@selector(clickedMenuItem:)];
        menuItem0.anchorPoint = CGPointMake(0, 0.5);
        //menuItem0 = ccp(10, 200);
        menuItem0.tag = T_HOMEMENUITEM0;
        
        textlabel = [CCLabelTTF labelWithString:@"挑战模式" fontName:@"Helvetica-Bold" fontSize:fontSize];
        CCMenuItem* menuItem1 = [CCMenuItemLabel itemWithLabel:textlabel target:self selector:@selector(clickedMenuItem:)];
        menuItem1.anchorPoint = CGPointMake(0, 0.5);
        menuItem1.tag = T_HOMEMENUITEM1;
        
        CCMenu* leftMenu = [CCMenu menuWithItems:menuItem0,menuItem1,nil];
        [leftMenu alignItemsVerticallyWithPadding:30];
        leftMenu.position = ccp(10, 220);
        [self addChild:leftMenu];
        
        //右菜单
        
        fontSize = 14;
        textlabel = [CCLabelTTF labelWithString:@"排行" fontName:@"Helvetica-Bold" fontSize:fontSize];
        CCMenuItem* menuItem2 = [CCMenuItemLabel itemWithLabel:textlabel target:self selector:@selector(clickedMenuItem:)];
        menuItem2.anchorPoint = CGPointMake(0, 0.5);
        menuItem2.tag = T_HOMEMENUITEM2;
        
        textlabel = [CCLabelTTF labelWithString:@"关于" fontName:@"Helvetica-Bold" fontSize:fontSize];
        CCMenuItem* menuItem3 = [CCMenuItemLabel itemWithLabel:textlabel target:self selector:@selector(clickedMenuItem:)];
        menuItem3.anchorPoint = CGPointMake(0, 0.5);
        menuItem3.tag = T_HOMEMENUITEM3;
        
        textlabel = [CCLabelTTF labelWithString:@"设置" fontName:@"Helvetica-Bold" fontSize:fontSize];
        CCMenuItem* menuItem4 = [CCMenuItemLabel itemWithLabel:textlabel target:self selector:@selector(clickedMenuItem:)];
        menuItem4.anchorPoint = CGPointMake(0, 0.5);
        menuItem4.tag = T_HOMEMENUITEM4;
        
        CCMenu* rightMenu = [CCMenu menuWithItems:menuItem2,menuItem3,menuItem4,nil];
        [rightMenu alignItemsVerticallyWithPadding:20];
        rightMenu.position = ccp(winSize.width - menuItem4.contentSize.width - 10, 80);
        [self addChild:rightMenu];

    }
    
    return self;
}

- (void)dealloc
{
    sharedInstance = nil;
    [super dealloc];
}

- (void)clickedMenuItem:(id)sender
{
    CCMenuItem* menuItem = (CCMenuItem*)sender;
    CCLOG(@"%d",menuItem.tag);
    switch (menuItem.tag)
    {
        case T_HOMEMENUITEM0:
        {
            CCScene* scene = [RCSelectTeamScene scene];
            [DIRECTOR replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
            break;
        }
        case T_HOMEMENUITEM1:
            break;
        case T_HOMEMENUITEM2:
            break;
        case T_HOMEMENUITEM3:
        {
            [DIRECTOR shareText:@"cool" type:SHT_QQ];
            break;
        }
        case T_HOMEMENUITEM4:
        {
            RCSettingsViewController* temp = [[RCSettingsViewController alloc] initWithNibName:nil bundle:nil];
            
            [[RCTool getRootNavigationController] pushViewController:temp animated:YES];
             [temp release];
            [DIRECTOR pause];
             
            break;
        }
            
        default:
            break;
    }
}

@end
