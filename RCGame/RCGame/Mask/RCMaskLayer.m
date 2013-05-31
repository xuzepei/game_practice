//
//  RCMaskLayer.m
//  RCGame
//
//  Created by xuzepei on 5/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCMaskLayer.h"


@implementation RCMaskLayer

- (void)visit
{
    glEnable(GL_SCISSOR_TEST);
    glScissor(0, 320, 1136, 640);//x, y, w, h
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}

@end
