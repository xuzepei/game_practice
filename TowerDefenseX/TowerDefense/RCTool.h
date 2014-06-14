//
//  RCTool.h
//  TowerDefense
//
//  Created by xuzepei on 7/28/13.
//
//

#ifndef __TowerDefense__RCTool__
#define __TowerDefense__RCTool__

#include "cocos2d.h"
using namespace cocos2d;

class RCTool : public CCObject {

public:
    static RCTool* sharedInstance(void);
    RCTool();
    ~RCTool();
    
    static bool collisionWithCircle(CCPoint circlePoint0, float radius0, CCPoint circlePoint1, float radius1);
};

#endif /* defined(__TowerDefense__RCTool__) */
