//
//  RCTower.h
//  TowerDefense
//
//  Created by xuzepei on 7/26/13.
//
//

#ifndef __TowerDefense__RCTower__
#define __TowerDefense__RCTower__

#include "cocos2d.h"
#include "RCEnemy.h"

using namespace cocos2d;

class RCTower : public CCNode {
    
private:
    float _attackRange;
    float _damage;
    float _fireRate;
    bool _attacking;
    RCEnemy* _chosenEnemy;

public:
    RCTower();
    ~RCTower();
    
    static RCTower* tower(CCPoint location, RCGameScene* gameScene);
    void update(float delta);
    void draw();
    
    CC_SYNTHESIZE(CCSprite*, _mySprite, MySprite);
    CC_SYNTHESIZE(CCPoint, _location, Location);
    CC_SYNTHESIZE(RCGameScene*, _gameScene, GameScene);
    
    void attackEnemy();
    void chosenEnemyForAttack(RCEnemy *enemy);
    void shoot(float dt);
    void removeBullet(CCSprite *bullet);
    void damageEnemy();
    void targetKilled();
    void lostSightOfEnemy();
};

#endif /* defined(__TowerDefense__RCTower__) */
