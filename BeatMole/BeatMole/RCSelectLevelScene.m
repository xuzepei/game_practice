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
#import "RCLevel.h"

static RCSelectLevelScene* sharedInstance = nil;
@implementation RCSelectLevelScene

+ (id)scene:(int)levelIndex
{
    CCScene* scene = [CCScene node];
    RCSelectLevelScene* layer = [[RCSelectLevelScene alloc] initWithLevelIndex:levelIndex];
    [scene addChild:layer];
    return scene;
}

+ (RCSelectLevelScene*)sharedInstance
{
    return sharedInstance;
}

- (id)initWithLevelIndex:(int)levelIndex
{
    if(self = [super init])
    {
        sharedInstance = self;
        CGSize winSize = WIN_SIZE;
        
        CCLayerColor* bgColorLayer = [CCLayerColor layerWithColor:ccc4(255, 0, 0, 255)];
        [self addChild:bgColorLayer];
        
        NSMutableArray* pages = [[[NSMutableArray alloc] init] autorelease];
        
        BOOL previousLevelPassed = YES;
        for(int i = 0; i < 10; i++)
        {
            int star = 0;
            NSDictionary* levelResult = [RCLevel getLevelResultByIndex:i];
            if(levelResult)
            {
                NSString* temp = [levelResult objectForKey:@"star"];
                if([temp length])
                    star = [temp intValue];
            }

            NSString* normalImage = [NSString stringWithFormat:@"level_%d.png",i];
            NSString* selectedImage = @"";
            NSString* disabledImage = [NSString stringWithFormat:@"level_%d_selected.png",i];
            
            CCLayer* page = [[[CCLayer alloc] init] autorelease];
            [page setOpacity:NOT_CURRENT_PAGE_OPACITY];
            CCMenuItem* menuItem = [CCMenuItemImage itemWithNormalImage:normalImage selectedImage:selectedImage disabledImage:disabledImage target:self selector:@selector(clickedMenuItem:)];
            menuItem.tag = T_SELECT_LEVEL_MENUITEM0 + i;
            
            if(previousLevelPassed)
               [menuItem setIsEnabled:YES];
            else
               [menuItem setIsEnabled:NO];
                
            CCMenu* menu = [CCMenu menuWithItems:menuItem, nil];
            menu.position = ccp(winSize.width/2, winSize.height/2);
            [page addChild:menu];
            
            for(int i = 0; i < star; i++)
            {
                CCSprite* starSprite = [CCSprite spriteWithFile:@"star.png"];
                starSprite.position = ccp(winSize.width/2 + i*60, winSize.height/2 - 120);
                [page addChild: starSprite];
            }

            [pages addObject: page];
            
            if(star < 1)
            {
                previousLevelPassed = NO;
            }
        }

        CCScrollLayer* scroller = [[CCScrollLayer alloc] initWithLayers:pages widthOffset: 100];
        scroller.showPagesIndicator = NO;
        [self addChild:scroller];
        
        [scroller moveToPage:levelIndex];
        
        //返回按钮
        CCMenuItem* menuItem = [CCMenuItemImage itemWithNormalImage:@"back_button.png" selectedImage:@"back_button_selected.png" target:self selector:@selector(clickedMenuItem:)];
        menuItem.anchorPoint = ccp(0,0.5);
        menuItem.tag = T_SELECT_LEVEL_BACKBUTTON;
        CCMenu* backMenu = [CCMenu menuWithItems:menuItem,nil];
        backMenu.position = ccp(10, winSize.height - menuItem.contentSize.height/2.0);
        [self addChild:backMenu z:10];
        
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
