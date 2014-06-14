//
//  RCGameScene.m
//  Box2D_Practice
//
//  Created by xuzepei on 8/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCGameScene.h"

#define PTM_RATIO 32.0

@implementation RCGameScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    
    RCGameScene* layer = [RCGameScene node];
    [scene addChild:layer];
    
    return scene;
}

- (id)init
{
    if(self = [super init])
    {
        //CGSize winSize = WIN_SIZE;
        
        self.isAccelerometerEnabled = YES;
        
        //创建物理引擎
        [self initPhysics];
        
        //创建球
        [self initBall];
        
        [self schedule:@selector(tick:)];
    }

    return self;
}

- (void)dealloc
{
    delete _world;
    _world = NULL;

    self.ballSprite = nil;
    
    [super dealloc];
}

- (void)initPhysics
{
    CGSize winSize = WIN_SIZE;
    
    //创建world
    b2Vec2 gravity = b2Vec2(0.0f,-30.0f)
    ;
    _world = new b2World(gravity);
    
    _world->SetAllowSleeping(true);
    _world->SetContinuousPhysics(true);
    
    //为整个屏幕创建一个不可见的边
    b2BodyDef groundBodyDef;//定义body
    groundBodyDef.position.Set(0,0);//放在左下角
    b2Body* groundBody = _world->CreateBody(&groundBodyDef);//创建body
    
    //为屏幕的每一个边界创建一个多边形shape
    b2EdgeShape groundEdge;
    
    //top edge
    groundEdge.Set(b2Vec2(0, winSize.height/PTM_RATIO),
                   b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
    groundBody->CreateFixture(&groundEdge,0);
    
    //bottom edge
    groundEdge.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
    groundBody->CreateFixture(&groundEdge,0);
    
    //left edge
    groundEdge.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
    groundBody->CreateFixture(&groundEdge,0);
    
    //right edge
    groundEdge.Set(b2Vec2(winSize.width/PTM_RATIO,
                          0), b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
    groundBody->CreateFixture(&groundEdge,0);
}

- (void)initBall
{
    //创建球的精灵
    self.ballSprite = [PhysicsSprite spriteWithFile:@"ball.jpg" rect:CGRectMake(0, 0, 26, 26)];
    self.ballSprite.position = ccp(100,100);
    [self addChild:self.ballSprite];
    
    //创建球的body
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(self.ballSprite.position.x/PTM_RATIO, self.ballSprite.position.y/PTM_RATIO);
    ballBodyDef.userData = self.ballSprite;
    b2Body* ballBody = _world->CreateBody(&ballBodyDef);
    
    //定义形状
    b2CircleShape circle;
    circle.m_radius = 13.0/PTM_RATIO;
    
//    b2PolygonShape box;
//	box.SetAsBox(.5f, .5f);//These are mid points for our 1m box
    
    //定制器
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f; //密度,就是单位体积的质量。因此，一个对象的密度越大，那么它就有更多的质量，当然就会越难以移动。
    ballShapeDef.friction = 0.2f; //摩擦系数,它的范围是0-1.0, 0意味着没有摩擦，1代表最大摩擦，几乎移不动的摩擦。
    ballShapeDef.restitution = 0.1f; //补偿系数,它的范围也是0到1.0。 0意味着对象碰撞之后不会反弹，1意味着是完全弹性碰撞，会以同样的速度反弹。
    ballBody->CreateFixture(&ballShapeDef);
    
    [self.ballSprite setPhysicsBody:ballBody];
}

- (void)tick:(ccTime)dt
{
    int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
    //这里的两个参数分别是“速度迭代次数”和“位置迭代次数”–你应该设置他们的范围在8-10之间。（译者：这里的数字越小，精度越小，但是效率更高。数字越大，仿真越精确，但同时耗时更多。8一般是个折中，如果学过数值分析，应该知道迭代步数的具体作用）

	_world->Step(dt, velocityIterations, positionIterations);
    
//    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
//        if (b->GetUserData() != NULL) {
//            CCSprite *ballData = (CCSprite *)b->GetUserData();
//            ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
//                                    b->GetPosition().y * PTM_RATIO);
//            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
//        }
//    }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    NSLog(@"acceleration,x:%f,y:%f",acceleration.x,acceleration.y);

//    b2Vec2 gravity;
//    gravity.Set(acceleration.x * 10, acceleration.y *10);
//    _world->SetGravity(gravity);
}

@end
