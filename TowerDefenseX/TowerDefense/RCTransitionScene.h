//
//  RCTransitionScene.h
//  TowerDefense
//
//  Created by xuzepei on 7/25/13.
//
//

#ifndef __TowerDefense__RCTransitionScene__
#define __TowerDefense__RCTransitionScene__

#include "cocos2d.h"
using namespace cocos2d;

class RCTransitionScene : public CCLayer
{
private:
    SCENE_TYPE _sceneType;
    
public:
    static CCScene* goToScene(SCENE_TYPE sceneType);
    bool initWithSceneType(SCENE_TYPE sceneType);
    void doTransition(CCTime delta);
};

#endif /* defined(__TowerDefense__RCTransitionScene__) */
