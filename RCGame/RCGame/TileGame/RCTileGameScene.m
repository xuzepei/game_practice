//
//  RCTileGameScene.m
//  RCGame
//
//  Created by xuzepei on 5/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCTileGameScene.h"

static RCTileGameScene* sharedInstance;
@implementation RCTileGameScene

+ (id)scene
{
    CCScene* scene = [CCScene node];
    RCTileGameScene* layer = [RCTileGameScene node];
    [scene addChild:layer];
    return scene;
}

+ (RCTileGameScene*)sharedInstance
{
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        sharedInstance = self;
        self.isTouchEnabled = YES;
        CGSize winSize = WIN_SIZE;
        
        CCLayerColor* colorLayer = [[[CCLayerColor alloc] initWithColor:ccc4(255, 0, 0, 255)] autorelease];
        [self addChild: colorLayer z:-2];
        
        //地图锚点默认位于0，0
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemap.tmx"];
        self.bgLayer = [self.tileMap layerNamed:@"background"];
        self.tileMap.position = ccp(0,0);
        
        [self addChild:self.tileMap z:-1];
        
        
        CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"objects"];
        NSAssert(objects != nil, @"'Objects' object group not found");
        NSMutableDictionary* spawnPoint = [objects objectNamed:@"player_point"];
        NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
        int x = [[spawnPoint valueForKey:@"x"] intValue];
        int y = [[spawnPoint valueForKey:@"y"] intValue];
        
        self.player = [CCSprite spriteWithFile:@"player.png"];
        _player.position = ccp(x/2.0, y/2.0);
        [self addChild:_player];

        //移动位置，使得屏幕大小内，能够包含要显示的点
        [self moveForPoint:_player.position map:self.tileMap];
    }
    
    return self;
}

- (void)dealloc
{
    self.tileMap = nil;
    self.bgLayer = nil;
    self.player = nil;
    
    sharedInstance = nil;
    [super dealloc];
}

- (void)moveForPoint:(CGPoint)point map:(CCTMXTiledMap*)map
{
    CGSize winSize = WIN_SIZE;
    
    NSLog(@"point.x:%f,point.y:%f",point.x,point.y);
    
    int x = point.x;
    int y = point.y;

    int mapWith = (map.mapSize.width * map.tileSize.width)/2.0;
    int mapHeight = (map.mapSize.height * map.tileSize.height)/2.0;
    
    //设置地图起点，使得该起点开始屏幕大小内，包含要显示的点

//    x = MAX(x, winSize.width/2.0);
//    y = MAX(y, winSize.height/2.0);
    
    x = x/(int)winSize.width * winSize.width;
    y = y/(int)winSize.height * winSize.height;
    
    //限制地图显示区域至少为一个屏幕大小
    x = MIN(x, mapWith
            - winSize.width);
    y = MIN(y, mapHeight
            - winSize.height);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2.0, winSize.height/2.0);
    CGPoint position = ccpSub(centerOfView, actualPosition);

    self.position = position;
}

- (void)moveByPoint:(CGPoint)point map:(CCTMXTiledMap*)map
{
    CGSize winSize = WIN_SIZE;

    int x = point.x;
    int y = point.y;
    
    int mapWith = (map.mapSize.width * map.tileSize.width)/2.0;
    int mapHeight = (map.mapSize.height * map.tileSize.height)/2.0;
    
    //限制地图显示区域至少为一个屏幕大小
    CGPoint position = ccpAdd(self.position, ccp(x,y));
    position.x = MIN(position.x, mapWith
            - winSize.width);
    position.y = MIN(position.y, mapHeight
            - winSize.height);
    
    self.position = position;
}

#pragma mark - Touch Event

- (void)registerWithTouchDispatcher
{
    [[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
//    CGPoint touchLocation = [touch locationInView: [touch view]];
//    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
//    touchLocation = [self convertToNodeSpace:touchLocation];
    
    CGPoint point = _player.position;
    CGPoint diffPoint = CGPointZero;
    CGPoint diff = ccpSub(touchLocation, point);
    if (abs(diff.x) > abs(diff.y)) {
        if (diff.x >0) {
            point.x += self.tileMap.tileSize.width/2.0;
            diffPoint.x += self.tileMap.tileSize.width/2.0;
        } else {
            point.x -= self.tileMap.tileSize.width/2.0;
            diffPoint.x -= self.tileMap.tileSize.width/2.0;
        }
    } else {
        if (diff.y >0) {
            point.y += self.tileMap.tileSize.height/2.0;
            diffPoint.y += self.tileMap.tileSize.height/2.0;
        } else {
            point.y -= self.tileMap.tileSize.height/2.0;
            diffPoint.y -= self.tileMap.tileSize.height/2.0;
        }
    }
    
    if (point.x <= (self.tileMap.mapSize.width * self.tileMap.tileSize.width)/2.0 &&
        point.y <= (self.tileMap.mapSize.height * self.tileMap.tileSize.height)/2.0 &&
        point.y >=0&&
        point.x >=0 ) 
    {
        _player.position = point;
    }
    
    [self moveForPoint:point map:self.tileMap];
}

@end
