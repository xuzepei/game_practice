//
//  RCTileGameScene.m
//  RCGame
//
//  Created by xuzepei on 5/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RCTileGameScene.h"
#import "SimpleAudioEngine.h"

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
        
        //添加地图，地图锚点默认位于0，0
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemap.tmx"];
        self.tileMap.anchorPoint = ccp(0, 0);
        self.bgLayer = [self.tileMap layerNamed:@"background"];
        [self addChild:self.tileMap z:-1];
        
        self.metaLayer = [self.tileMap layerNamed:@"meta"];
        self.metaLayer.visible = NO;//设置碰撞层为不可见
        
        self.foodLayer = [self.tileMap layerNamed:@"food"];
        
        //从地图种读取对象，并设置位置
        CCTMXObjectGroup *objectGroup = [self.tileMap objectGroupNamed:@"objects"];
        for(NSMutableDictionary* spawnPoint in [objectGroup objects])
        {
            if(1 == [[spawnPoint valueForKey:@"enemy"] intValue])
            {
                int x = [[spawnPoint valueForKey:@"x"] intValue];
                int y = [[spawnPoint valueForKey:@"y"] intValue];
                [self addEnemyAtPoint:ccp(x/2.0, y/2.0)];
            }
            else if(1 == [[spawnPoint valueForKey:@"player"] intValue])
            {
                int x = [[spawnPoint valueForKey:@"x"] intValue];
                int y = [[spawnPoint valueForKey:@"y"] intValue];
                
                //添加主角
                self.player = [CCSprite spriteWithFile:@"player.png"];
                _player.position = ccp(x/2.0, y/2.0);
                [self.tileMap addChild:_player z:10];//添加对象到地图，并设置位置，包括z坐标
                
                //移动位置，使得屏幕大小内，能够显示要显示的点
                [self moveForMapPoint:_player.position map:self.tileMap];
            }
        }
        
        //添加按钮
        CCMenuItem *on = [CCMenuItemImage itemWithNormalImage:@"projectile_button_on.png"
                                     selectedImage:@"projectile_butto_on.png" target:nil selector:nil];
        CCMenuItem *off = [CCMenuItemImage itemWithNormalImage:@"projectile_button_off.png"
                                      selectedImage:@"projectile_button_off.png" target:nil selector:nil];
        
        CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self
                                                               selector:@selector(projectileButtonTapped:) items:off, on, nil];
        CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
        toggleMenu.position = ccp(100, 32);
        [self addChild:toggleMenu];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pickup.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"move.caf"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"tilemap.caf"];
    }
    
    return self;
}

- (void)dealloc
{
    self.tileMap = nil;
    self.bgLayer = nil;
    self.player = nil;
    self.metaLayer = nil;
    self.fgLayer = nil;
    self.foodLayer = nil;
    
    sharedInstance = nil;
    [super dealloc];
}

- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    int x = (position.x*2.0) / (_tileMap.tileSize.width*1.0);
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height)/1.0 - (position.y*2.0)) / (_tileMap.tileSize.height*1.0);
    return ccp(x, y);
}

/*
 point: 为地图上点的坐标
 */
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
    
    //反向移动场景坐标，显示地图区域
    self.tileMap.position = ccp(-x,-y);
}

/*
 point: 包含了x和y轴上的步长及方向
 */
- (void)moveToPointByStep:(CGPoint)point map:(CCTMXTiledMap*)map
{
    CGSize winSize = WIN_SIZE;
    
    int x = point.x;
    int y = point.y;

    int mapWith = (map.mapSize.width * map.tileSize.width)/2.0;
    int mapHeight = (map.mapSize.height * map.tileSize.height)/2.0;
    
    CGPoint movedOffsetPoint = ccp(-x, -y);
    
    NSLog(@"position0:%@,offset:%@,point:%@",NSStringFromCGPoint(self.position),NSStringFromCGPoint(movedOffsetPoint),NSStringFromCGPoint(point));
    CGPoint position = ccpAdd(self.tileMap.position, movedOffsetPoint);
    NSLog(@"position1:%@",NSStringFromCGPoint(position));
    position.x = MIN(position.x, 0);
    position.y = MIN(position.y, 0);
    
    NSLog(@"position2:%@",NSStringFromCGPoint(position));
    position.x = MAX(position.x,-(mapWith
                     - winSize.width));
    position.y = MAX(position.y, -(mapHeight
                     - winSize.height));
    
    NSLog(@"position:%@",NSStringFromCGPoint(position));
    self.tileMap.position = position;
}

#pragma mark - Touch Event

- (void)registerWithTouchDispatcher
{
    [[DIRECTOR touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    NSLog(@"touchLocation:%@",NSStringFromCGPoint(touchLocation));
    touchLocation = ccpSub(touchLocation, self.tileMap.position);
    
    if(_mode ==0)
    {
        CGSize winSize = WIN_SIZE;
        CGPoint point = _player.position;
        CGPoint diffPoint = CGPointZero;
        
        //根据点击点和对象点，计算移动的方向，并在该方向上产生tileSize.with或tileSize.height的位移（高精度图片位移／2.0）
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
                    NSString *b = [properties valueForKey:@"collidable"];
                    if(b && [b compare:@"true"] == NSOrderedSame) {
                        
                        [[SimpleAudioEngine sharedEngine] playEffect:@"hit.caf"];
                        return YES;
                    }
                    
                    b = [properties valueForKey:@"collectable"];
                    if(b && [b compare:@"true"] == NSOrderedSame) {
                        
                        NSString *collectable = [properties valueForKey:@"collectable"];
                        if (collectable && [collectable compare:@"true"] == NSOrderedSame)
                        {
                            [[SimpleAudioEngine sharedEngine] playEffect:@"pickup.caf"];
                            
                            [_foodLayer removeTileAt:tileCoord];
                            [_metaLayer removeTileAt:tileCoord];
                        }
                    }
                }
                
            }
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"move.caf"];
            _player.position = point;
            
            BOOL xCanMove = point.x >= winSize.width/2.0 && point.x <= (self.tileMap.mapSize.width * self.tileMap.tileSize.width)/2.0 - winSize.width/2.0;
            BOOL yCanMove = point.y >= winSize.height/2.0 && point.y <= (self.tileMap.mapSize.height * self.tileMap.tileSize.height)/2.0 - winSize.height/2.0;
            
            NSLog(@"diffPoint:%@",NSStringFromCGPoint(diffPoint));
            if((xCanMove && diffPoint.x) || (yCanMove && diffPoint.y))
            {
                [self moveToPointByStep:diffPoint map:self.tileMap];
            }
        }

    }
    else
    {
        //CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        
        // Create a projectile and put it at the player's location
        CCSprite *projectile = [CCSprite spriteWithFile:@"projectile.png"];
        projectile.position = _player.position;
        [self.tileMap addChild:projectile];
        
        // Determine where we wish to shoot the projectile to
        CGPoint targetPoint = CGPointZero;
        
        // Are we shooting to the left or right?
        CGPoint diff = ccpSub(touchLocation, _player.position);
        if(diff.x >0)
        {
            targetPoint.x = (_tileMap.mapSize.width * _tileMap.tileSize.width)/2.0 +
            (projectile.contentSize.width/2.0);
        }
        else
        {
            targetPoint.x = -(_tileMap.mapSize.width * _tileMap.tileSize.width)/2.0 -
            (projectile.contentSize.width/2.0);
        }
        
        float ratio = (float) diff.y / (float) diff.x;
        targetPoint.y = ((targetPoint.x - projectile.position.x) * ratio) + projectile.position.y;
        
        // Determine the length of how far we're shooting
        int offRealX = targetPoint.x - projectile.position.x;
        int offRealY = targetPoint.y - projectile.position.y;
        float length = sqrtf((offRealX*offRealX) + (offRealY*offRealY));
        float velocity = 480/1; // 480pixels/1sec
        float realMoveDuration = length/velocity;
        
        // Move projectile to actual endpoint
        id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                                 selector:@selector(projectileMoveFinished:)];
        [projectile runAction:
         [CCSequence actionOne:
          [CCMoveTo actionWithDuration: realMoveDuration
                              position: targetPoint]
                           two: actionMoveDone]];
    }

    return YES;
}

- (void)addEnemyAtPoint:(CGPoint)point
{
    CCSprite* enemy = [CCSprite spriteWithFile:@"enemy.png"];
    enemy.position = point;
    [self.tileMap addChild: enemy z:10];
    
    [self animateEnemy:enemy];
}

- (void)projectileMoveFinished:(id)sender
{
    CCSprite *sprite = (CCSprite *)sender;
    [self.tileMap removeChild:sprite cleanup:YES];
}

- (void)enemyMoveFinished:(id)sender
{
    CCSprite *enemy = (CCSprite *)sender;
    [self animateEnemy: enemy];
}

- (void)animateEnemy:(CCSprite*)enemy
{
    //speed of the enemy
    ccTime actualDuration = 0.3;
    
    //旋转enemy使之面向主角
    CGPoint diff = ccpSub(_player.position,enemy.position);
    float angleRadians = atanf((float)diff.y / (float)diff.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1* angleDegrees;
    if (diff.x <0) {
        cocosAngle +=180;
    }
    enemy.rotation = cocosAngle;
    
    //Create the actions
    id actionMove = [CCMoveBy actionWithDuration:actualDuration
                                        position:ccpMult(ccpNormalize(ccpSub(_player.position,enemy.position)), 10)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(enemyMoveFinished:)];
    [enemy runAction:
     [CCSequence actions:actionMove, actionMoveDone, nil]];
}

- (void)projectileButtonTapped:(id)sender
{
    self.mode = self.mode?NO:YES;
}

@end
