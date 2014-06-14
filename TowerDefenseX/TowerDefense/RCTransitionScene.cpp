//
//  RCTransitionScene.cpp
//  TowerDefense
//
//  Created by xuzepei on 7/25/13.
//
//

#include "RCTransitionScene.h"
#include "RCGameScene.h"
#include "HelloWorldScene.h"

CCScene* RCTransitionScene::goToScene(SCENE_TYPE sceneType)
{
    CCScene *scene = CCScene::create();
    
    RCTransitionScene* layer = new RCTransitionScene();
    if (layer && layer->initWithSceneType(sceneType))
        layer->autorelease();
    else
    {
        CC_SAFE_DELETE(layer);
        layer = NULL;
    }
    
    if(layer)
        scene->addChild(layer);
    
    return scene;
}

bool RCTransitionScene::initWithSceneType(SCENE_TYPE sceneType)
{
    if(!CCLayer::init())
    {
        return false;
    }

    _sceneType = sceneType;

    CCLabelTTF* pLabel = CCLabelTTF::create("Loading...", "Thonburi", 34);
    
    // ask director the window size
    CCSize size = CCDirector::sharedDirector()->getWinSize();
    
    // position the label on the center of the screen
    pLabel->setPosition(ccp(size.width / 2, size.height/2));
    
    // add the label as a child to this layer
    this->addChild(pLabel, 1);
    
    this->scheduleOnce(schedule_selector(RCTransitionScene::doTransition), 1.0);
    
    return true;
}

void RCTransitionScene::doTransition(CCTime delta)
{
    CCScene* scene = NULL;
    switch (_sceneType) {
        case ST_HELLOWORLD:
        {
            scene = HelloWorld::scene();
            break;
        }
        case ST_GAME:
        {
            scene = RCGameScene::scene();
            break;
        }
         default:
            break;
    }
    
    if(scene)
    {
        CCTransitionFade* fade = CCTransitionFade::create(1.0, scene, ccWHITE);
        CCDirector::sharedDirector()->replaceScene(fade);
    }
}
