//
//  RCTower.cpp
//  TowerDefense
//
//  Created by xuzepei on 7/26/13.
//
//

#include "RCTower.h"
#include "RCTool.h"

RCTower::RCTower()
{
    _gameScene = NULL;
    _attackRange = 0.0;
    _damage = 0.0;
    _fireRate = 0.0;
    _mySprite = NULL;
    _attacking = false;
    _chosenEnemy = NULL;
}

RCTower::~RCTower()
{
}

RCTower* RCTower::tower(CCPoint location, RCGameScene* gameScene)
{
    RCTower* pRet = new RCTower();
    if(pRet)
    {
        pRet->_gameScene = gameScene;
        pRet->_location = location;
        pRet->_attackRange = 120;
        pRet->_damage = 10;
        pRet->_fireRate = 1;
        
        pRet->_mySprite = CCSprite::create("tower.png");
        pRet->_mySprite->setPosition(location);
        pRet->addChild(pRet->_mySprite);

        pRet->scheduleUpdate();
    }
    
    return pRet;
}

void RCTower::update(float delta)
{
    if(_chosenEnemy)
    {
        //We make it turn to target the enemy chosen
        CCPoint normalized = ccpNormalize(ccp(_chosenEnemy->getMySprite()->getPosition().x - _mySprite->getPosition().x,
                                              _chosenEnemy->getMySprite()->getPosition().y - _mySprite->getPosition().y));
        _mySprite->setRotation(CC_RADIANS_TO_DEGREES(atan2(normalized.y, - normalized.x)) + 90);
        
        if (!RCTool::collisionWithCircle(_mySprite->getPosition(), _attackRange, _chosenEnemy->getMySprite()->getPosition(), 1))
        {
            this->lostSightOfEnemy();
        }
    }
    else
    {
        CCObject *pObject = NULL;
        CCARRAY_FOREACH(_gameScene->getEnemies(), pObject)
        {
            RCEnemy *enemy = (RCEnemy*)pObject;
            if (RCTool::collisionWithCircle(_mySprite->getPosition(), _attackRange, enemy->getMySprite()->getPosition(), 1))
            {
                this->chosenEnemyForAttack(enemy);
                break;
            }           
        }
    }
}

void RCTower::draw()
{
    if(NULL == _mySprite)
    {
        CCNode::draw();
        return;
    }
    
    #ifdef COCOS2D_DEBUG
        ccDrawColor4F(255, 0, 0, 255);
        ccDrawCircle(_mySprite->getPosition(), _attackRange, 360, 50, false);
    #endif
        CCNode::draw();
}

void RCTower::attackEnemy()
{
    this->schedule(schedule_selector(RCTower::shoot), _fireRate);
}

void RCTower::chosenEnemyForAttack(RCEnemy *enemy)
{
    _chosenEnemy = NULL;
    _chosenEnemy = enemy;
    this->attackEnemy();
    enemy->getAttacked(this);
}

void RCTower::shoot(float dt)
{
    CCSprite *bullet = CCSprite::create("bullet.png");
    _gameScene->addChild(bullet);
    
    bullet->setPosition(_mySprite->getPosition());
    bullet->runAction(CCSequence::create(
                                         CCMoveTo::create(0.1, _chosenEnemy->getMySprite()->getPosition()),
                                         CCCallFunc::create(this, callfunc_selector(RCTower::damageEnemy)),
                                         CCCallFuncN::create(this, callfuncN_selector(RCTower::removeBullet)),
                                         NULL));
}

void RCTower::removeBullet(CCSprite *bullet)
{
    bullet->getParent()->removeChild(bullet, true);
}

void RCTower::damageEnemy()
{
    if(_chosenEnemy)
    {
        _chosenEnemy->getDamaged(_damage);
    }
}

void RCTower::targetKilled()
{
    if(_chosenEnemy)
    {
        _chosenEnemy = NULL;
    }
    
    this->unschedule(schedule_selector(RCTower::shoot));
}

void RCTower::lostSightOfEnemy()
{
    _chosenEnemy->gotLostSight(this);
    
    if(_chosenEnemy)
    {
        _chosenEnemy = NULL;
    }
    
    this->unschedule(schedule_selector(RCTower::shoot));
}