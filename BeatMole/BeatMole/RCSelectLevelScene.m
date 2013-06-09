//
//  RCSelectLevelScene.m
//  BeatMole
//
//  Created by xuzepei on 5/28/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCSelectLevelScene.h"
#import "RCSelectTeamScene.h"
#import "RCBeatMoleScene.h"

static RCSelectLevelScene* sharedInstance = nil;
@implementation RCSelectLevelScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCSelectLevelScene* layer = [RCSelectLevelScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCSelectLevelScene*)sharedInstance
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
        menuItem.tag = T_SELECT_LEVEL_BACKBUTTON;
        CCMenu* backMenu = [CCMenu menuWithItems:menuItem,nil];
        backMenu.position = ccp(10, winSize.height - menuItem.contentSize.height/2.0);
        [self addChild:backMenu];
        
        CCMenuItem* menuItem0 = [CCMenuItemImage itemWithNormalImage:@"level_0.png" selectedImage:@"level_0_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem0.tag = T_SELECT_LEVEL_MENUITEM0;
        
        CCMenuItem* menuItem1 = [CCMenuItemImage itemWithNormalImage:@"level_1.png" selectedImage:@"level_1_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem1.tag = T_SELECT_LEVEL_MENUITEM1;
        
        CCMenuItem* menuItem2 = [CCMenuItemImage itemWithNormalImage:@"level_2.png" selectedImage:@"level_2_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem2.tag = T_SELECT_LEVEL_MENUITEM2;
        
        CCMenuItem* menuItem3 = [CCMenuItemImage itemWithNormalImage:@"level_3.png" selectedImage:@"level_3_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem3.tag = T_SELECT_LEVEL_MENUITEM3;
        
        CCMenuItem* menuItem4 = [CCMenuItemImage itemWithNormalImage:@"level_4.png" selectedImage:@"level_4_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem4.tag = T_SELECT_LEVEL_MENUITEM4;
        
        CCMenuItem* menuItem5 = [CCMenuItemImage itemWithNormalImage:@"level_5.png" selectedImage:@"level_5_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem5.tag = T_SELECT_LEVEL_MENUITEM5;
        
        
        CCMenu* menuLine0 = [CCMenu menuWithItems:menuItem0,menuItem1,menuItem2,nil];
        [menuLine0 alignItemsHorizontallyWithPadding:60];
        menuLine0.position = ccp(winSize.width/2.0, winSize.height/2.0 + menuItem.contentSize.height);
        [self addChild:menuLine0];
        
        CCMenu* menuLine1 = [CCMenu menuWithItems:menuItem3,menuItem4,menuItem5,nil];
        [menuLine1 alignItemsHorizontallyWithPadding:60];
        menuLine1.position = ccp(winSize.width/2.0, winSize.height/2.0 - menuItem.contentSize.height);
        [self addChild:menuLine1];
        
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
    
    CCScene* scene = nil;
    switch (menuItem.tag)
    {
        case T_SELECT_LEVEL_BACKBUTTON:
        {
            CCScene* scene = [RCSelectTeamScene scene];
            [DIRECTOR replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
            
            break;
        }
        case T_SELECT_LEVEL_MENUITEM0:
        {
            scene = [RCBeatMoleScene scene:0];
            
            break;
        }
        case T_SELECT_LEVEL_MENUITEM1:
        {
            scene = [RCBeatMoleScene scene:1];

            break;
        }
        case T_SELECT_LEVEL_MENUITEM2:
        {
            scene = [RCBeatMoleScene scene:2];
            
            break;
        }
        case T_SELECT_LEVEL_MENUITEM3:
        {
            scene = [RCBeatMoleScene scene:3];
            
            break;
        }
        case T_SELECT_LEVEL_MENUITEM4:
        {
            scene = [RCBeatMoleScene scene:4];
            
            break;
        }
        case T_SELECT_LEVEL_MENUITEM5:
        {
            scene = [RCBeatMoleScene scene:5];
            
            break;
        }
        case T_SELECT_LEVEL_MENUITEM6:
        {
            scene = [RCBeatMoleScene scene:6];
            
            break;
        }
        case T_SELECT_LEVEL_MENUITEM7:
        {
            scene = [RCBeatMoleScene scene:7];
            
            break;
        }
        case T_SELECT_LEVEL_MENUITEM8:
        {
            scene = [RCBeatMoleScene scene:8];
            
            break;
        }
        case T_SELECT_LEVEL_MENUITEM9:
        {
            scene = [RCBeatMoleScene scene:9];
            
            break;
        }
        default:
            break;
    }
    
    if(scene)
    {
        [DIRECTOR replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
    }
}

@end
