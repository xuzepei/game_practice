//
//  RCTool.cpp
//  TowerDefense
//
//  Created by xuzepei on 7/28/13.
//
//

#include "RCTool.h"

static RCTool *s_sharedTool = NULL;

RCTool* RCTool::sharedInstance(void)
{
    if(!s_sharedTool)
    {
        s_sharedTool = new RCTool();
    }
    
    return s_sharedTool;
}

RCTool::RCTool()
{
}

RCTool::~RCTool()
{
    s_sharedTool = NULL;
}

/*
 检测两个圆是否相交
 */
bool RCTool::collisionWithCircle(CCPoint circlePoint0, float radius0, CCPoint circlePoint1, float radius1)
{
    float xdif = circlePoint0.x - circlePoint1.x;
    float ydif = circlePoint0.y - circlePoint1.y;
    
    float distance = sqrt(xdif * xdif + ydif * ydif);
    
    if(distance <= radius0 + radius1)
    {
        return true;
    }
    
    return false;
}