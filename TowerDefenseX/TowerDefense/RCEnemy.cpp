//
//  RCEnemy.cpp
//  TowerDefense
//
//  Created by xuzepei on 7/28/13.
//
//

#include "RCEnemy.h"
#include "RCTool.h"
#include "RCTower.h"
#include "SimpleAudioEngine.h"

#define HEALTH_BAR_WIDTH 20
#define HEALTH_BAR_ORIGIN -10

using namespace CocosDenshion;

RCEnemy::RCEnemy(void)
{
    _attackedBy = NULL;
    _gameScene = NULL;
}

RCEnemy::~RCEnemy(void)
{
    CC_SAFE_RELEASE_NULL(_attackedBy);
}

RCEnemy* RCEnemy::enemy(RCGameScene* gameScene)
{
    if(NULL == gameScene)
        return NULL;
    
    RCEnemy* pRet = new RCEnemy();
    if(pRet)
    {
        pRet->_gameScene = gameScene;
        pRet->_maxHp = 40.0;
        pRet->_currentHp = pRet->_maxHp;
        pRet->_speed = 0.5;
        pRet->_active = false;
        pRet->setVisible(false);
        
        pRet->_attackedBy = CCArray::create();
        pRet->_attackedBy->retain();
        
        pRet->_mySprite = CCSprite::create("enemy.png");
        pRet->addChild(pRet->_mySprite);
        
        RCWaypoint* waypoint = (RCWaypoint*)pRet->_gameScene->getWaypoints()->objectAtIndex(0);
        pRet->_destinationWaypoint = waypoint->getNextWaypoint();
        pRet->_location = waypoint->getPoint();
        pRet->_mySprite->setPosition(pRet->_location);
        
        pRet->scheduleUpdate();
        
        
    }
    
    return pRet;
}

void RCEnemy::update(float dt)
{
    if (!_active)
    {
        return;
    }
    
    if(RCTool::collisionWithCircle(_location, 1, _destinationWaypoint->getPoint(), 1))
    {
        if(_destinationWaypoint->getNextWaypoint())
        {
            _destinationWaypoint = _destinationWaypoint->getNextWaypoint();
        }
        else //到达终点
        {
            //_theGame->getHpDamage();
            this->remove();
        }
    }
    
    CCPoint targetPoint = _destinationWaypoint->getPoint();
    float moveSpeed = _speed;
    
    //ccpNormalize标准化向量，使向量长度为1
    CCPoint normalized = ccpNormalize(ccp(targetPoint.x - _location.x, targetPoint.y - _location.y));
    /*  对于任意不同时等于0的实参数x和y，atan2(y,x)所表达的意思是坐标原点为起点，指向(x,y)的射线在坐标平面上与x轴正方向之间的角的角度度。当y>0时，射线与x轴正方向的所得的角的角度指的是x轴正方向绕逆时针方向到达射线旋转的角的角度；而当y<0时，射线与x轴正方向所得的角的角度指的是x轴正方向绕顺时针方向达到射线旋转的角的角度。*/
    double radian = atan2(normalized.y, - normalized.x);
    _mySprite->setRotation(CC_RADIANS_TO_DEGREES(radian));
    
    _location = ccp(_location.x + normalized.x * moveSpeed, _location.y + normalized.y * moveSpeed);
    _mySprite->setPosition(_location);
}

void RCEnemy::draw(void)
{
    CCPoint healthBarBack[] = {
        ccp(_mySprite->getPosition().x - 10, _mySprite->getPosition().y + 16),
        ccp(_mySprite->getPosition().x + 10, _mySprite->getPosition().y + 16),
        ccp(_mySprite->getPosition().x + 10, _mySprite->getPosition().y + 14),
        ccp(_mySprite->getPosition().x - 10, _mySprite->getPosition().y + 14)
    };
    ccDrawSolidPoly(healthBarBack, 4, ccc4f(255, 0, 0, 255));
    
    CCPoint healthBar[] = {
        ccp(_mySprite->getPosition().x + HEALTH_BAR_ORIGIN, _mySprite->getPosition().y + 16),
        ccp(_mySprite->getPosition().x + HEALTH_BAR_ORIGIN + (float)(_currentHp * HEALTH_BAR_WIDTH) / _maxHp, _mySprite->getPosition().y + 16),
        ccp(_mySprite->getPosition().x + HEALTH_BAR_ORIGIN + (float)(_currentHp * HEALTH_BAR_WIDTH) / _maxHp, _mySprite->getPosition().y + 14),
        ccp(_mySprite->getPosition().x + HEALTH_BAR_ORIGIN, _mySprite->getPosition().y + 14)
    };
    ccDrawSolidPoly(healthBar, 4, ccc4f(0, 255, 0, 255));
    
    CCNode::draw();
}

void RCEnemy::activate(float dt)
{
    _active = true;
    this->setVisible(true);
}

void RCEnemy::remove()
{
    CCObject *pObject = NULL;
    CCARRAY_FOREACH(_attackedBy, pObject)
    {
        RCTower* attacker = (RCTower*)pObject;
        attacker->targetKilled();
    }
    
    this->getParent()->removeChild(this, true);
    _gameScene->getEnemies()->removeObject(this);
    _gameScene->enemyGotKilled();
}


void RCEnemy::getAttacked(RCTower* attacker)
{
    _attackedBy->addObject(attacker);
}

void RCEnemy::gotLostSight(RCTower* attacker)
{
    _attackedBy->removeObject(attacker);
}

void RCEnemy::getDamaged(float damage)
{
    SimpleAudioEngine::sharedEngine()->playEffect("laser_shoot.wav");
    _currentHp -= damage;
    if(_currentHp <= 0)
    {
        this->remove();
    }
}