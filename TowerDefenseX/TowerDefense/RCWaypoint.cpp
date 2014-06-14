//
//  RCWaypoint.cpp
//  TowerDefense
//
//  Created by xuzepei on 7/26/13.
//
//

#include "RCWaypoint.h"

#define C_N_ RCWaypoint

C_N_::RCWaypoint()
{
    _nextWaypoint = NULL;
}

C_N_::~RCWaypoint()
{
}

RCWaypoint* C_N_::waypoint(CCPoint point)
{
    RCWaypoint* pRet = new RCWaypoint();
    if(pRet)
    {
        pRet->_point = point;
    }
    
    return pRet;
}

void C_N_::draw()
{
#ifdef COCOS2D_DEBUG
    ccDrawColor4F(127, 0, 127, 255);
    ccDrawCircle(_point, 6, 360, 30, false);
    ccDrawCircle(_point, 2, 360, 30, false);
    
    if(_nextWaypoint)
        ccDrawLine(_point, _nextWaypoint->_point);
#endif
    
    CCNode::draw();
}