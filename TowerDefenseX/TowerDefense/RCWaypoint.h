//
//  RCWaypoint.h
//  TowerDefense
//
//  Created by xuzepei on 7/26/13.
//
//

#ifndef __TowerDefense__RCWaypoint__
#define __TowerDefense__RCWaypoint__

#include "cocos2d.h"
using namespace cocos2d;

class RCWaypoint : public CCNode {
   
public:
    RCWaypoint(void);
    ~RCWaypoint(void);
    
    static RCWaypoint* waypoint(CCPoint point);
    void draw(void);
    
    CC_SYNTHESIZE(CCPoint, _point, Point);
    CC_SYNTHESIZE(RCWaypoint*, _nextWaypoint, NextWaypoint);
};

#endif /* defined(__TowerDefense__RCWaypoint__) */
