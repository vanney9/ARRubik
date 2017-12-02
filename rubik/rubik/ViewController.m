//
//  ViewController.m
//  rubik
//
//  Created by vanney on 2017/11/24.
//  Copyright © 2017年 vanney9. All rights reserved.
//

#import "ViewController.h"
#import "RubikScene.h"
//#import "RubikNode.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, strong) RubikScene *rubik;
@property (nonatomic, strong) SCNNode *containerNode;

@property (nonatomic, strong) SCNNode *startNode;
@property (nonatomic, strong) SCNNode *endNode;

@property (nonatomic, assign) SCNVector3 startPos;
@property (nonatomic, assign) SCNVector3 endPos;
@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the view's delegate
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    self.sceneView.showsStatistics = YES;
    self.sceneView.autoenablesDefaultLighting = YES;
    self.sceneView.scene = [SCNScene new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create a session configuration
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;

    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.sceneView addGestureRecognizer:panGestureRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"vanney code log : start pan");
        CGPoint location = [recognizer locationInView:self.sceneView];
        NSArray *results = [self.sceneView hitTest:location options:@{SCNHitTestOptionBoundingBoxOnly: @(YES)}];
        SCNHitTestResult *result = results.firstObject;
        self.startNode = result.node;
        self.startPos = result.worldCoordinates;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"vanney code log : end pan");
        CGPoint location = [recognizer locationInView:self.sceneView];
        NSArray *results = [self.sceneView hitTest:location options:@{SCNHitTestOptionBoundingBoxOnly: @(YES)}];
        SCNHitTestResult *result = results.firstObject;
        self.endNode = result.node;
        self.endPos = result.worldCoordinates;
        [self.rubik handleRotationWithStartNode:self.startNode andEndNode:self.endNode startPos:self.startPos andEndPos:self.endPos];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"vanney code log : change in progress");
//        CGPoint location = [recognizer locationInView:self.sceneView];
//        NSArray *results = [self.sceneView hitTest:location options:nil];
//        SCNHitTestResult *result = results.firstObject;
//        //self.endNode = result.node;
//        self.endPos = result.worldCoordinates;
    }
}


- (void)test:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.sceneView];
    NSArray *results = [self.sceneView hitTest:location options:nil];
    SCNHitTestResult *result = results.firstObject;
    [self.rubik handleTap:result.node andNormal:result.worldCoordinates];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ARSCNViewDelegate

/*
// Override to create and configure nodes for anchors added to the view's session.
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
    SCNNode *node = [SCNNode new];
 
    // Add geometry to the node...
 
    return node;
}
*/

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    NSLog(@"vanney code log : yayayayayyyyyyyyyyy");
    if ([anchor isKindOfClass:[ARPlaneAnchor class]]) {
        if (self.rubik == nil) {
            NSLog(@"vanney code log : first detect a plane");
            self.rubik = [[RubikScene alloc] initWithScene:self.sceneView.scene andAnchor:anchor andNode:node];
            //self.containerNode = [SCNNode node];
            //self.containerNode.position = node.position;
            //[self.containerNode addChildNode:self.rubik.frame];
        }
    }
}

@end
