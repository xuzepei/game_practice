//
//  RCEarthScene.m
//  RCGame
//
//  Created by xuzepei on 5/2/13.
//
//

#import "RCEarthScene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"


@implementation RCEarthScene

- (void)dealloc
{
    [super dealloc];
}

/**
 * Constructs the 3D scene.
 *
 * Adds 3D objects to the scene, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model scene.
 *
 * NOTES:
 *
 * 1) To help you find your scene content once it is loaded, the onOpen method below contains
 *    code to automatically move the camera so that it frames the scene. You can remove that
 *    code once you know where you want to place your camera.
 *
 * 2) The POD file used for the 'hello, world' message model is fairly large, because converting a
 *    font to a mesh results in a LOT of triangles. When adapting this template project for your own
 *    application, REMOVE the POD file 'hello-world.pod' from the Resources folder of your project.
 */

- (void)showEarth
{
    // Create the camera, place it back a bit, and add it to the world
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v( 0.0, 0.0, 4.0 ); // 6.0
	[self addChild: cam];
    
	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the world
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( -2.0, 0.0, 0.0 ); // -2.0, 0.0, 0.0
	lamp.isDirectionalOnly = NO;
	[cam addChild: lamp];
    
	// This is the simplest way to load a POD resource file and add the
	// nodes to the CC3World, if no customized resource subclass is needed.
	[self addContentFromPODResourceFile: @"earth.pod"];
    
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex data in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantData];
    
	// That's it! The model world is now constructed and is good to go.
    
	// ------------------------------------------
    
	// But to add some dynamism, we'll animate the 'world'
	// using a couple of cocos2d actions...
    
	// Fetch the 'earth' 3D object that was loaded from the
	// POD file and start it rotating
	CC3MeshNode* earth = (CC3MeshNode*)[self getNodeNamed: @"Sphere"];
    [earth setRotation:cc3v(-20.0, 0.0, 0.0)];
	CCActionInterval* partialRot = [CC3RotateBy actionWithDuration: 1.0
                                                          rotateBy: cc3v(0.0, 30.0, 0.0)];
	[earth runAction: [CCRepeatForever actionWithAction: partialRot]];
}

- (void)initializeScene
{
    [self showEarth];
}


#pragma mark Updating custom activity

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the 3D nodes in the scene.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities after
 * the transformMatrix of the 3D nodes in the scen have been recalculated.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {
	// If you have uncommented the moveWithDuration: invocation in the onOpen: method, you
	// can uncomment the following to track how the camera moves, where it ends up, and what
	// the camera's clipping distances are, in order to determine how to position and configure
	// the camera to view the entire scene.
    //	LogDebug(@"Camera: %@", activeCamera.fullDescription);
}


#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {
    
	// Move the camera to frame the scene. You can uncomment the LogDebug line in the
	// updateAfterTransform: method to track how the camera moves, where it ends up, and
	// what the camera's clipping distances are, in order to determine how to position
	// and configure the camera to view your entire scene. Then you can remove this code.
	[self.activeCamera moveWithDuration: 3.0 toShowAllOf: self withPadding: 0.5f];
    
	// Uncomment this line to draw the bounding box of the scene.
    //	self.shouldDrawWireframeBox = YES;
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


#pragma mark Handling touch events

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touch events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint {}

/**
 * This callback template method is invoked automatically when a node has been picked
 * by the invocation of the pickNodeFromTapAt: or pickNodeFromTouchEvent:at: methods,
 * as a result of a touch event or tap gesture.
 *
 * Override this method to perform activities on 3D nodes that have been picked by the user.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {}

@end
