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
        CCMenuItemImage* menuItem0 = [CCMenuItemImage itemWithNormalImage:@"home_menu_level_model.png" selectedImage:@"home_menu_level_model_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem0.tag = T_HOMEMENUITEM0;
        
        CCMenuItemImage* menuItem1 = [CCMenuItemImage itemWithNormalImage:@"home_menu_challenge_model.png" selectedImage:@"home_menu_challenge_model_selected.png"
            disabledImage:@"home_menu_challenge_model_disabled.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem1.tag = T_HOMEMENUITEM1;
        
        CCMenu* leftMenu = [CCMenu menuWithItems:menuItem0,menuItem1,nil];
        [leftMenu alignItemsVerticallyWithPadding:24.0];
        leftMenu.position = ccp(68, 182);
        [self addChild:leftMenu];
        
        //顶部
        CCMenuItem* menuItem2 = [CCMenuItemImage itemWithNormalImage:@"home_menu_toplist.png" selectedImage:@"home_menu_toplist_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem2.tag = T_HOMEMENUITEM2;
        CCMenu* topMenu = [CCMenu menuWithItems:menuItem2,nil];
        topMenu.position = ccp(30, 290);
        [self addChild:topMenu];
        

        CCMenuItem* menuItem3 = [CCMenuItemImage itemWithNormalImage:@"home_menu_about.png" selectedImage:@"home_menu_about_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem3.tag = T_HOMEMENUITEM3;
        
        CCMenuItem* menuItem4 = [CCMenuItemImage itemWithNormalImage:@"home_menu_setting.png" selectedImage:@"home_menu_setting_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem4.tag = T_HOMEMENUITEM4;
        
        CCMenu* rightMenu = [CCMenu menuWithItems:menuItem4,menuItem3,nil];
        [rightMenu alignItemsHorizontallyWithPadding:12];
        rightMenu.position = ccp(170, 25);
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
