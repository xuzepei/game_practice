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

        NSLog(@"self.anchorPoint:%@,self.position:%@",NSStringFromCGPoint(self.anchorPoint),NSStringFromCGPoint(self.position));
        
        CCLayerColor* colorLayer = [[[CCLayerColor alloc] initWithColor:ccc4(255, 0, 0, 255)] autorelease];
        [self addChild: colorLayer z:-2];
        
        //地图锚点默认位于0，0
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemap.tmx"];
        self.bgLayer = [self.tileMap layerNamed:@"background"];
        [self addChild:self.tileMap z:-1];
        
        self.metaLayer = [self.tileMap layerNamed:@"meta"];
        self.metaLayer.visible = NO;
        
        
        CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"objects"];
        NSAssert(objects != nil, @"'Objects' object group not found");
        NSMutableDictionary* spawnPoint = [objects objectNamed:@"player_point"];
        NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
        int x = [[spawnPoint valueForKey:@"x"] intValue];
        int y = [[spawnPoint valueForKey:@"y"] intValue];
        
        self.player = [CCSprite spriteWithFile:@"player.png"];
        _player.position = ccp(x/2.0, y/2.0);
        [self.tileMap addChild:_player];

        //移动位置，使得屏幕大小内，能够包含要显示的点
        [self moveForMapPoint:_player.position map:self.tileMap];
    }
    
    return self;
}

- (void)dealloc
{
    self.tileMap = nil;
    self.bgLayer = nil;
    self.player = nil;
    self.metaLayer = nil;
    
    sharedInstance = nil;
    [super dealloc];
}

- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    int x = position.x / (_tileMap.tileSize.width*0.5);
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height)/2.0 - position.y) / (_tileMap.tileSize.height*0.5);
    return ccp(x, y);
}

- (void)moveForMapPoint:(CGPoint)point map:(CCTMXTiledMap*)map
{
    CGSize winSize = WIN_SIZE;
    
    NSLog(@"mapPoint.x:%f,mapPoint.y:%f",point.x,point.y);
    
    int x = point.x;
    int y = point.y;

    int mapWith = (map.mapSize.width * map.tileSize.width)/2.0;
    int mapHeight = (map.mapSize.height * map.tileSize.height)/2.0;
    
    x = floor(x/winSize.width)*winSize.width;
    y = floor(y/winSize.height)*winSize.height;
    
    //限制地图显示区域至少为一个屏幕大小
    x = MIN(x, mapWith
            - winSize.width);
    y = MIN(y, mapHeight
            - winSize.height);
    
    self.position = ccp(-x,-y);
}

- (void)moveToPointByStep:(CGPoint)point map:(CCTMXTiledMap*)map
{
    CGSize winSize = WIN_SIZE;
    
    int x = point.x;
    int y = point.y;

    int mapWith = (map.mapSize.width * map.tileSize.width)/2.0;
    int mapHeight = (map.mapSize.height * map.tileSize.height)/2.0;
    
    //限制地图显示区域至少为一个屏幕大小
    CGPoint movedOffsetPoint = ccp(-x, -y);
    
    NSLog(@"position0:%@,offset:%@,point:%@",NSStringFromCGPoint(self.position),NSStringFromCGPoint(movedOffsetPoint),NSStringFromCGPoint(point));
    CGPoint position = ccpAdd(self.position, movedOffsetPoint);
    NSLog(@"position1:%@",NSStringFromCGPoint(position));
    position.x = MIN(position.x, 0);
    position.y = MIN(position.y, 0);
    
    NSLog(@"position2:%@",NSStringFromCGPoint(position));
    position.x = MAX(position.x,-(mapWith
                     - winSize.width));
    position.y = MAX(position.y, -(mapHeight
                     - winSize.height));
    
    NSLog(@"position:%@",NSStringFromCGPoint(position));
    self.position = position;
}

#pragma mark - Touch Event

- (void)registerWithTouchDispatcher
{
    [[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGSize winSize = WIN_SIZE;
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
        CGPoint tileCoord = [self tileCoordForPosition:point];
        int tileGid = [self.metaLayer tileGIDAt:tileCoord];
        if (tileGid) {
            NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
            if (properties) {
                NSString *collision = [properties valueForKey:@"Collidable"];
                if (collision && [collision compare:@"true"] == NSOrderedSame) {
                    return YES;
                }
            }
        }
        
        _player.position = point;
        
        BOOL xCanMove = point.x >= winSize.width/2.0 && point.x <= (self.tileMap.mapSize.width * self.tileMap.tileSize.width)/2.0 - winSize.width/2.0;
        BOOL yCanMove = point.y >= winSize.height/2.0 && point.y <= (self.tileMap.mapSize.height * self.tileMap.tileSize.height)/2.0 - winSize.height/2.0;
        
        NSLog(@"diffPoint:%@",NSStringFromCGPoint(diffPoint));
        if((xCanMove && diffPoint.x) || (yCanMove && diffPoint.y))
         [self moveToPointByStep:diffPoint map:self.tileMap];
    }
    
//    if (point.x <= (self.tileMap.mapSize.width * self.tileMap.tileSize.width)/2.0 &&
//        point.y <= (self.tileMap.mapSize.height * self.tileMap.tileSize.height)/2.0 &&
//        (point.y >= winSize.width/2.0 ||
//        point.x >= winSize.width/2.0) )
//    {
//        [self moveToPointByStep:diffPoint map:self.tileMap];
//    }

    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    
//    CGPoint touchLocation = [touch locationInView: [touch view]];
//    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
//    touchLocation = [self convertToNodeSpace:touchLocation];
    
//    CGPoint point = _player.position;
//    CGPoint diffPoint = CGPointZero;
//    CGPoint diff = ccpSub(touchLocation, point);
//    if (abs(diff.x) > abs(diff.y)) {
//        if (diff.x >0) {
//            point.x += self.tileMap.tileSize.width/2.0;
//            diffPoint.x += self.tileMap.tileSize.width/2.0;
//        } else {
//            point.x -= self.tileMap.tileSize.width/2.0;
//            diffPoint.x -= self.tileMap.tileSize.width/2.0;
//        }
//    } else {
//        if (diff.y >0) {
//            point.y += self.tileMap.tileSize.height/2.0;
//            diffPoint.y += self.tileMap.tileSize.height/2.0;
//        } else {
//            point.y -= self.tileMap.tileSize.height/2.0;
//            diffPoint.y -= self.tileMap.tileSize.height/2.0;
//        }
//    }
//    
//    if (point.x <= (self.tileMap.mapSize.width * self.tileMap.tileSize.width)/2.0 &&
//        point.y <= (self.tileMap.mapSize.height * self.tileMap.tileSize.height)/2.0 &&
//        point.y >=0&&
//        point.x >=0 ) 
//    {
//        _player.position = point;
//    }
//    
//    [self moveForMapPoint:point map:self.tileMap];
}

@end
