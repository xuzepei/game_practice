//
//  RCSelectTeamScene.m
//  BeatMole
//
//  Created by xuzepei on 5/28/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCSelectTeamScene.h"
#import "RCUser.h"
#import "RCHomeScene.h"
#import "RCSelectLevelScene.h"
#import "RCLevel.h"

static RCSelectTeamScene* sharedInstance = nil;
@implementation RCSelectTeamScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCSelectTeamScene* layer = [RCSelectTeamScene node];
    [scene addChild: layer];
    return scene;
}

+ (RCSelectTeamScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        sharedInstance = self;
        CGSize winSize = WIN_SIZE;
        
        CCLayerColor* bgColorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:bgColorLayer];
        
        CCMenuItem* menuItem = [CCMenuItemImage itemWithNormalImage:@"back_button.png" selectedImage:@"back_button_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem.anchorPoint = ccp(0,0.5);
        menuItem.tag = T_SELECT_TEAM_BACKBUTTON;
        CCMenu* backMenu = [CCMenu menuWithItems:menuItem,nil];
        backMenu.position = ccp(10, winSize.height - menuItem.contentSize.height/2.0);
        [self addChild:backMenu];
        
        
        CCMenuItem* menuItem0 = [CCMenuItemImage itemWithNormalImage:@"red_team_select.png" selectedImage:@"red_team_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem0.tag = T_SELECT_TEAM_MENUITEM0;
        
        CCMenuItem* menuItem1 = [CCMenuItemImage itemWithNormalImage:@"blue_team_select.png" selectedImage:@"blue_team_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem1.tag = T_SELECT_TEAM_MENUITEM1;
        
        CCMenu* selectionMenu = [CCMenu menuWithItems:menuItem0,menuItem1,nil];
        [selectionMenu alignItemsHorizontallyWithPadding:60];
        selectionMenu.position = ccp(winSize.width/2.0, winSize.height/2.0);
        [self addChild:selectionMenu];
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
        case T_SELECT_TEAM_MENUITEM0:
        {
            [RCUser sharedInstance].teamType = TT_RED;
            
            CCScene* scene = [RCSelectLevelScene scene:[RCLevel getLastLevelIndex]];
            [DIRECTOR replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
            
            break;
        }
        case T_SELECT_TEAM_MENUITEM1:
        {
            [RCUser sharedInstance].teamType = TT_BLUE;
            
            CCScene* scene = [RCSelectLevelScene scene:[RCLevel getLastLevelIndex]];
            [DIRECTOR replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
            
            break;
        }
        case T_SELECT_TEAM_BACKBUTTON:
        {
            CCScene* scene = [RCHomeScene scene];
            [DIRECTOR replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
            
            break;
        }
        default:
            break;
    }
}

@end
