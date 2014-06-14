//
//  RCEnemy.h
//  TowerDefense
//
//  Created by xuzepei on 7/28/13.
//
//

#ifndef __TowerDefense__RCEnemy__
#define __TowerDefense__RCEnemy__

#include "cocos2d.h"
#include "RCWaypoint.h"
#include "RCGameScene.h"

using namespace cocos2d;

class RCTower;

class RCEnemy : public CCNode {
    
private:
    CCPoint _location;
    float _maxHp;
    float _currentHp;
    float _speed;
    RCWaypoint* _destinationWaypoint;
    bool _active;
    
public:
    RCEnemy();
    ~RCEnemy();
    
    static RCEnemy* enemy(RCGameScene* gameScene);
    void update(float delta);
    void draw();
    CC_SYNTHESIZE(CCSprite*, _mySprite, MySprite);
    CC_SYNTHESIZE(RCGameScene*, _gameScene, GameScene);
    CC_SYNTHESIZE_RETAIN(CCArray*, _attackedBy, AttackBy);
    
    void activate(float dt);
    void remove();
    void getDamaged(float damage);
    void gotLostSight(RCTower* attacker);
    void getAttacked(RCTower* attacker);
};

#endif /* defined(__TowerDefense__RCEnemy__) */
