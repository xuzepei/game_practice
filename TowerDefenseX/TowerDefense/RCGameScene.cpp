//
//  RCGameScene.cpp
//  TowerDefense
//
//  Created by xuzepei on 7/25/13.
//
//

#include "RCGameScene.h"
#include "RCTower.h"
#include "RCWaypoint.h"
#include "RCEnemy.h"
#include "SimpleAudioEngine.h"

using namespace CocosDenshion;

RCGameScene::RCGameScene(void)
{
    _towerBaseArray = NULL;
    _towers = NULL;
    _waypoints = NULL;
    _waveNum = 0;
}

RCGameScene::~RCGameScene(void)
{
    CCLog("%s,%s",__FUNCTION__,__FILE__);
    
    if(_towerBaseArray)
    {
        _towerBaseArray->release();
        _towerBaseArray = NULL;
    }
    
    CC_SAFE_RELEASE_NULL(_towers);
    CC_SAFE_RELEASE_NULL(_waypoints);
    CC_SAFE_RELEASE_NULL(_enemies);
}

CCScene* RCGameScene::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    RCGameScene *layer = RCGameScene::create();
    
    // add layer as a child to scene
    scene->addChild(layer);
    
    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool RCGameScene::init()
{
    if(!CCLayer::init())
    {
        return false;
    }
    
    this->setTouchEnabled(true);
    CCSize winSize = WIN_SIZE;
    
    //创建保存炮塔得数组
    _towers = CCArray::create();
    _towers->retain();//引用计数加1
    
    //设置背景
    CCSprite* bg = CCSprite::create("bg.png"); 
    bg->setPosition(ccp(winSize.width/2.0, winSize.height/2.0));
    this->addChild(bg);
    
    //创建炮塔底座
    this->initTowerBases();
    
    //初始化路径
    this->initWaypoints();
    
    _waveLabel = CCLabelTTF::create(CCString::createWithFormat("WAVE: %d", _waveNum)->getCString(), "Helvetica", 14);
    _waveLabel->setPosition(ccp(400, winSize.height - 12));
    _waveLabel->setAnchorPoint(ccp(0, 0.5));
    this->addChild(_waveLabel, 10);

    _enemies = CCArray::create();
    _enemies->retain();
    
    this->loadWave();
    
    SimpleAudioEngine::sharedEngine()->playBackgroundMusic("bg.mp3",true);

    return true;
}

void RCGameScene::initWaypoints()
{
    if(NULL == _waypoints)
    {
        CCArray* tempArray = CCArray::createWithContentsOfFile("waypoints.plist");
        
        _waypoints = CCArray::createWithCapacity(tempArray->count());
        _waypoints->retain();
        
        CCObject *pObject = NULL;
        CCARRAY_FOREACH(tempArray, pObject)
        {
            CCDictionary* position = (CCDictionary*)pObject;

            float x = ((CCString*)position->objectForKey("x"))->floatValue();
            float y = ((CCString*)position->objectForKey("y"))->floatValue();
            
            RCWaypoint* waypoint = RCWaypoint::waypoint(ccp(x,y));
            this->addChild(waypoint);
            _waypoints->addObject(waypoint);
        }
        
        //设置路点间的连接关系
        int j = 0;
        for(int i = 0; i < _waypoints->count() - 1; i++)
        {
            j = i + 1;
            if(j >= _waypoints->count())
                break;
            
            RCWaypoint* waypoint = (RCWaypoint*)_waypoints->objectAtIndex(i);
            
            RCWaypoint* nextWaypoint = (RCWaypoint*)_waypoints->objectAtIndex(j);
            
            waypoint->setNextWaypoint(nextWaypoint);
        }
    }
}

void RCGameScene::initTowerBases()
{
    if(NULL == _towerBaseArray)
    {
        CCArray* tempArray = CCArray::createWithContentsOfFile("towers_position.plist");
        
        _towerBaseArray = CCArray::createWithCapacity(tempArray->count());
        _towerBaseArray->retain();
        
        CCObject *pObject = NULL;
        CCARRAY_FOREACH(tempArray, pObject)//遍历数组
        {
            CCDictionary* position = (CCDictionary*)pObject;
            CCSprite* towerBase = CCSprite::create("tower_base.png");
            
            float x = ((CCString*)position->objectForKey("x"))->floatValue();
            float y = ((CCString*)position->objectForKey("y"))->floatValue();
            
            towerBase->setPosition(ccp(x,y));
            
            this->addChild(towerBase);
            _towerBaseArray->addObject(towerBase);
        }
    }
}

bool RCGameScene::loadWave()
{
    CCArray* waveData = CCArray::createWithContentsOfFile("waves.plist");
    if (_waveNum >= waveData->count())
    {
        return false;
    }
    
    CCArray* currentWaveData = (CCArray*)waveData->objectAtIndex(_waveNum);
    
    CCObject *pObject = NULL;
    CCARRAY_FOREACH(currentWaveData, pObject)
    {
        CCDictionary* enemyData = (CCDictionary*)pObject;
        RCEnemy *enemy = RCEnemy::enemy(this);
        this->addChild(enemy);
        _enemies->addObject(enemy);
        enemy->schedule(schedule_selector(RCEnemy::activate), ((CCString*)enemyData->objectForKey("spawnTime"))->floatValue());
    }
    
    _waveNum++;
    _waveLabel->setString(CCString::createWithFormat("WAVE: %d", _waveNum)->getCString());
    
    return true;
}

void RCGameScene::enemyGotKilled()
{
    if(_enemies->count() <= 0)
    {
        if(!this->loadWave())
        {
            CCLog("You win!");
        }
    }
}

#pragma mark - Touch Event

void RCGameScene::ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent)
{
    if(NULL == _towerBaseArray || 0 == _towerBaseArray->count())
        return;
    
    CCSetIterator iter = pTouches->begin();
    for (; iter != pTouches->end(); iter++)
    {
        CCTouch* pTouch = (CCTouch*)(*iter);
        CCPoint location = pTouch->getLocation();
        
        CCObject *pObject = NULL;
        CCARRAY_FOREACH(_towerBaseArray, pObject)
        {
            CCSprite* towerBase = (CCSprite*)pObject;
            if (towerBase->boundingBox().containsPoint(location) && !towerBase->getUserData())
            {
                RCTower* tower = RCTower::tower(towerBase->getPosition(),this);
                if(tower)
                {
                    SimpleAudioEngine::sharedEngine()->playEffect("tower_place.wav");
                    
                    this->addChild(tower);
                    _towers->addObject(tower);
                    towerBase->setUserData(tower);
                }
            }
        }
    }
}
