//
//  RCBreakoutGameScene.m
//  Box2D_Practice
//
//  Created by xuzepei on 8/27/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCBreakoutGameScene.h"


#define PTM_RATIO 32.0

#define BALL_TAG 1
#define PADDLE_TAG 2

@implementation RCBreakoutGameScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    
    RCBreakoutGameScene* layer = [RCBreakoutGameScene node];
    [scene addChild:layer];
    
    return scene;
}

- (id)init
{
    if(self = [super init])
    {
        //CGSize winSize = WIN_SIZE;
        
        self.isTouchEnabled = YES;
        
        //创建物理引擎
        [self initPhysics];
        
        [self initBall];
        
        [self initPaddle];
        
        [self initPrismaticJoint];
        
        [self schedule:@selector(tick:)];
    }
    
    return self;
}

- (void)dealloc
{
    delete _world;
    _world = NULL;
    
    delete _debugDraw;
    _debugDraw = NULL;
    
    _groundBody = NULL;
    delete _ballFixture;
    _ballFixture = NULL;
    
    _paddleBody = NULL;
    delete _paddleFixture;
    _paddleFixture = NULL;
    
    //delete _mouseJoint;
    _mouseJoint = NULL;
    
    self.ballSprite = nil;
    self.paddleSprite = nil;
    
    [super dealloc];
}

- (void)initPhysics
{
    CGSize winSize = WIN_SIZE;
    
    //创建world
    b2Vec2 gravity = b2Vec2(0.0f,0.0f)
    ;
    _world = new b2World(gravity);
    _world->SetAllowSleeping(true);
    _world->SetContinuousPhysics(true);
    
    _debugDraw = new GLESDebugDraw(PTM_RATIO);
	_world->SetDebugDraw(_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	_debugDraw->SetFlags(flags);
    

    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    _groundBody = _world->CreateBody(&groundBodyDef);
    
    //为屏幕的每一个边界创建一个多边形shape
    b2EdgeShape groundEdge;
    
    //top edge
    groundEdge.Set(b2Vec2(0, winSize.height/PTM_RATIO),
                   b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundEdge,0);
    
    //bottom edge
    groundEdge.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
    _groundBody->CreateFixture(&groundEdge,0);
    
    //left edge
    groundEdge.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundEdge,0);
    
    //right edge
    groundEdge.Set(b2Vec2(winSize.width/PTM_RATIO,
                          0), b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundEdge,0);
}

- (void)initBall
{
    self.ballSprite = [PhysicsSprite spriteWithFile:@"ball.jpg" rect:CGRectMake(0, 0, 26, 26)];
    self.ballSprite.position = ccp(100,100);
    self.ballSprite.tag = BALL_TAG;
    [self addChild:self.ballSprite];
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(self.ballSprite.position.x/PTM_RATIO, self.ballSprite.position.y/PTM_RATIO);
    ballBodyDef.userData = self.ballSprite;
    b2Body* ballBody = _world->CreateBody(&ballBodyDef);
    
    b2CircleShape circle;
    circle.m_radius = 13.0/PTM_RATIO;

    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0;
    ballShapeDef.restitution = 1.0f;
    _ballFixture = ballBody->CreateFixture(&ballShapeDef);
    
    //这里往球上面施加了一个冲力（impulse），这样可以让它初始化的时候朝一个特定的方向运动
    b2Vec2 impulse = b2Vec2(10,10);
    ballBody->ApplyLinearImpulse(impulse, ballBodyDef.position);
    
    [self.ballSprite setPhysicsBody:ballBody];
}

- (void)initPaddle
{
    CGSize winSize = WIN_SIZE;
    self.paddleSprite = [PhysicsSprite spriteWithFile:@"paddle.png"];
    self.paddleSprite.position = ccp(winSize.width/2.0,50);
    self.paddleSprite.tag = PADDLE_TAG;
    [self addChild:self.paddleSprite];
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(self.paddleSprite.position.x/PTM_RATIO, self.paddleSprite.position.y/PTM_RATIO);
    bodyDef.userData = self.paddleSprite;
    _paddleBody = _world->CreateBody(&bodyDef);
    
    b2PolygonShape shape;
    shape.SetAsBox(self.paddleSprite.contentSize.width/2.0/PTM_RATIO, self.paddleSprite.contentSize.height/2.0/PTM_RATIO);
    
    b2FixtureDef shapeDef;
    shapeDef.shape = &shape;
    shapeDef.density = 10.0f;
    shapeDef.friction = 0.4f;
    shapeDef.restitution = 0.1f;
    _paddleFixture = _paddleBody->CreateFixture(&shapeDef);
    
    [self.paddleSprite setPhysicsBody:_paddleBody];
}

- (void)initPrismaticJoint
{
    //Restrict paddle along the x axis
    b2PrismaticJointDef jointDef;
    b2Vec2 worldAxis(1.0f, 0.0f);
    jointDef.collideConnected = true;
    jointDef.Initialize(_paddleBody, _groundBody,
                        _paddleBody->GetWorldCenter(), worldAxis);
    _world->CreateJoint(&jointDef);
}

- (void)draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
	
	kmGLPushMatrix();
	_world->DrawDebugData();
	kmGLPopMatrix();
}

- (void)tick:(ccTime)dt
{
    int32 velocityIterations = 8;
	int32 positionIterations = 1;

	_world->Step(dt, velocityIterations, positionIterations);
    
    if (self.ballSprite) {
        static int maxSpeed = 10;
        b2Vec2 velocity = [self.ballSprite getBody]->GetLinearVelocity();
        float32 speed = velocity.Length();
        if (speed > maxSpeed) {
            [self.ballSprite getBody]->SetLinearDamping(0.5);
        } else if (speed < maxSpeed) {
            [self.ballSprite getBody]->SetLinearDamping(0.0);
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_mouseJoint != NULL)
        return;
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [DIRECTOR convertToGL:location];
    
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    if (_paddleFixture->TestPoint(locationWorld))//测试点是否在fixture内部
    {
        b2MouseJointDef md;
        md.bodyA = _groundBody; //未使用，通常设置为groundBody
        md.bodyB = _paddleBody; //要移动的body
        md.target = locationWorld;
        md.collideConnected = true; //不忽略碰撞
        md.maxForce = 1000.0f * _paddleBody->GetMass();
        _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
        _paddleBody->SetAwake(true);//body设置成苏醒的（awake）。之所以要这么做，是因为如果body在睡觉的话，那么它就不会响应鼠标的移动！
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(NULL == _mouseJoint)
        return;
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [DIRECTOR convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    _mouseJoint->SetTarget(locationWorld);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_mouseJoint)
    {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_mouseJoint)
    {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

@end
