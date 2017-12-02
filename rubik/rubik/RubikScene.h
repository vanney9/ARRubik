//
//  RubikScene.h
//  rubik
//
//  Created by vanney on 2017/11/24.
//  Copyright © 2017年 vanney9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class ARPlaneAnchor;

@interface RubikScene : NSObject

@property (nonatomic, strong) SCNNode *frame;

- (instancetype)initWithScene:(SCNScene *)scene andAnchor:(ARPlaneAnchor *)anchor andNode:(SCNNode *)anchorNode;

- (void)rotateWithXAxisAtIndex:(NSInteger)x andDirection:(BOOL)direction;
- (void)rotateWithYAxisAtIndex:(NSInteger)y andDirection:(BOOL)direction;
- (void)rotateWithZAxisAtIndex:(NSInteger)z andDirection:(BOOL)direction;

- (void)handleRotationWithStartNode:(SCNNode *)startNode andEndNode:(SCNNode *)endNode startPos:(SCNVector3)startPos andEndPos:(SCNVector3)endPos;
- (void)handleTap:(SCNNode *)startNode andNormal:(SCNVector3)normal;

@end
