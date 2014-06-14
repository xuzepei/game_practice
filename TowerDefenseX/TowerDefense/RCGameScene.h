//
//  RCGameScene.h
//  TowerDefense
//
//  Created by xuzepei on 7/25/13.
//
//

#ifndef __TowerDefense__RCGameScene__
#define __TowerDefense__RCGameScene__

#include "cocos2d.h"

//指定命名空间，否者需要带前缀cocos2d::，如cocos2d::CCLayer
using namespace cocos2d;

class RCGameScene : public CCLayer
{
private:
    int _waveNum;
    CCLabelTTF* _waveLabel;
    
public:

    RCGameScene(void);
    ~RCGameScene(void);
    
    bool init();

    static CCScene* scene();

    CREATE_FUNC(RCGameScene);//CREATE_FUNC 定义了RCGameScene得create方法
    
    CCArray* _towerBaseArray;
    
    /*CC_SYNTHESIZE_RETAIN 定义非基本变量得set和get方法, 参数1:类型 参数2:变量名 参数3:set或get方法名后面部分*/
    CC_SYNTHESIZE_RETAIN(CCArray*, _towers, Towers);
    CC_SYNTHESIZE_RETAIN(CCArray*, _waypoints, Waypoints);
    CC_SYNTHESIZE_RETAIN(CCArray*, _enemies, Enemies);
    
    void ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent);
    void enemyGotKilled();
    
private:
    void initTowerBases();
    void initWaypoints();
    bool loadWave();
};

#endif /* defined(__TowerDefense__RCGameScene__) */
