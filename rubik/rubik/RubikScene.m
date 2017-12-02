//
//  RubikScene.m
//  rubik
//
//  Created by vanney on 2017/11/24.
//  Copyright © 2017年 vanney9. All rights reserved.
//

#import "RubikScene.h"
#import "RubikNode.h"
#import <ARKit/ARKit.h>

@interface RubikScene()
@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, strong) SCNScene *scene;
@end

@implementation RubikScene

- (instancetype)initWithScene:(SCNScene *)scene andAnchor:(ARPlaneAnchor *)anchor andNode:(SCNNode *)anchorNode {
    if (self = [super init]) {
        _frame = [SCNNode node];
        _nodes = [NSMutableArray new];
        //_frame.position = SCNVector3Make(anchor.center.x, anchor.center.y + 0.5, anchor.center.z);
        //SCNVector3 framePos = [anchorNode.parentNode convertPosition:anchorNode.position toNode:nil];
        _frame.position = SCNVector3Make(anchorNode.position.x, anchorNode.position.y - 0.5, anchorNode.position.z - 0.5);
        //_frame.position = framePos;
        //_frame.transform = anchorNode.transform;
        [scene.rootNode addChildNode:_frame];


        [self p_createRubikScene];
    }

    return self;
}

- (void)rotateWithXAxisAtIndex:(NSInteger)x andDirection:(BOOL)direction {
    NSMutableArray *rotateNodes = [self p_getRotateNodesAtIndex:x andAxis:0];
    [rotateNodes enumerateObjectsUsingBlock:^(RubikNode *obj, NSUInteger idx, BOOL *stop) {
        [obj rotateXWithDirection:direction];
    }];
}

- (void)rotateWithYAxisAtIndex:(NSInteger)y andDirection:(BOOL)direction {
    NSMutableArray *rotateNodes = [self p_getRotateNodesAtIndex:y andAxis:1];
    [rotateNodes enumerateObjectsUsingBlock:^(RubikNode *obj, NSUInteger idx, BOOL *stop) {
        [obj rotateYWithDirection:direction];
    }];
}

- (void)rotateWithZAxisAtIndex:(NSInteger)z andDirection:(BOOL)direction {
    NSMutableArray *rotateNodes = [self p_getRotateNodesAtIndex:z andAxis:2];
    [rotateNodes enumerateObjectsUsingBlock:^(RubikNode *obj, NSUInteger idx, BOOL *stop) {
        [obj rotateZWithDirection:direction];
    }];
}

- (void)handleRotationWithStartNode:(SCNNode *)startNode andEndNode:(SCNNode *)endNode startPos:(SCNVector3)startPos andEndPos:(SCNVector3)endPos {
    SCNVector3 startVector = [self.frame convertPosition:startNode.position fromNode:nil];
    SCNVector3 endVector = [self.frame convertPosition:endNode.position fromNode:nil];
    SCNVector3 realSP = [self.frame convertPosition:startPos fromNode:nil];
    SCNVector3 realEP = [self.frame convertPosition:endPos fromNode:nil];

    //NSLog(@"vanney code log : startVector x:%f,y:%f,z:%f", realFingerVector.x, realFingerVector.y, realFingerVector.z);
    //NSLog(@"vanney code log : endVector x:%f,y:%f,z:%f", endVector.x, endVector.y, endVector.z);

    startVector.y -= 0.5;
    startVector.z -= 0.5;

    endVector.y -= 0.5;
    endVector.z -= 0.5;

    NSInteger rotateFace;
    BOOL direction;
    NSInteger index;
    GLKVector3 rotateOrigin;

    GLKVector3 glkStart = SCNVector3ToGLKVector3(startVector);
    GLKVector3 glkEnd = SCNVector3ToGLKVector3(endVector);

    if (fabs(fabs(realSP.x) - 0.15) < 0.000001f) {
        if (round(startVector.y * 10) == round(endVector.y * 10)) {
            rotateFace = 1;
        } else {
            rotateFace = 2;
        }
    } else if (fabs(fabs(realSP.y) - 0.15) < 0.000001f) {
        if (round(startVector.x * 10) == round(endVector.x * 10)) {
            rotateFace = 0;
        } else {
            rotateFace = 2;
        }
    } else {
        if (round(startVector.x * 10) == round(endVector.x * 10)) {
            rotateFace = 0;
        } else {
            rotateFace = 1;
        }
    }

    switch (rotateFace) {
        case 0:
            index = round(startVector.x * 10);
            rotateOrigin = GLKVector3Make(startVector.x, 0, 0);
            break;
        case 1:
            index = round(startVector.y * 10);
            rotateOrigin = GLKVector3Make(0, startVector.y, 0);
            break;
        case 2:
            index = round(startVector.z * 10);
            rotateOrigin = GLKVector3Make(0, 0, startVector.z);
            break;
        default:
            break;
    }

    glkStart = GLKVector3Subtract(glkStart, rotateOrigin);
    glkEnd = GLKVector3Subtract(glkEnd, rotateOrigin);

    GLKVector3 cross = GLKVector3CrossProduct(glkStart, glkEnd);
    SCNVector3 realCross = SCNVector3FromGLKVector3(cross);
    switch (rotateFace) {
        case 0:
            if (realCross.x > 0) {
                direction = YES;
            } else {
                direction = NO;
            }
            break;
        case 1:
            if (realCross.y > 0) {
                direction = YES;
            } else {
                direction = NO;
            }
            break;
        case 2:
            if (realCross.z > 0) {
                direction = YES;
            } else {
                direction = NO;
            }
            break;
        default:
            break;
    }
    
    NSLog(@"rotate face is %d\nindex is %d\n", rotateFace, index);
    if (direction) {
        NSLog(@"vanney code log : zheng");
    } else {
        NSLog(@"vanney code log : fu");
    }

    switch (rotateFace) {
        case 0:
            [self rotateWithXAxisAtIndex:index andDirection:direction];
            return;
        case 1:
            [self rotateWithYAxisAtIndex:index andDirection:direction];
            return;
        case 2:
            [self rotateWithZAxisAtIndex:index andDirection:direction];
            return;
    }
}

- (void)handleTap:(SCNNode *)startNode andNormal:(SCNVector3)normal {
    SCNVector3 startVector = [self.frame convertPosition:startNode.position fromNode:nil];
    SCNVector3 normals = [self.frame convertPosition:normal fromNode:nil];

    //NSLog(@"vanney code log : startVector x:%f,y:%f,z:%f", normals.x, normals.y, normals.z);
    NSLog(@"vanney code log : handle tap");
    [self rotateWithXAxisAtIndex:0 andDirection:YES];
}


- (NSMutableArray *)p_getRotateNodesAtIndex:(NSInteger)index andAxis:(NSInteger)axis {
    NSMutableArray *rotateNodes = [NSMutableArray new];
    [self.nodes enumerateObjectsUsingBlock:^(RubikNode *obj, NSUInteger idx, BOOL *stop) {
        switch (axis) {
            case 0:
                if (obj.x == index) {
                    [rotateNodes addObject:obj];
                }
                break;
            case 1:
                if (obj.y == index) {
                    [rotateNodes addObject:obj];
                }
                break;
            case 2:
                if (obj.z == index) {
                    [rotateNodes addObject:obj];
                }
                break;
            default:
                break;
        }
    }];
    
    NSLog(@"rotate node num is %d", rotateNodes.count);
    return rotateNodes;
}


- (void)p_createRubikScene {
    RubikNode *curNode;

    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorWhite face1:RubikNodeFaceLeft color2:RubikNodeColorYellow face2:RubikNodeFaceBack color3:RubikNodeColorOrange face3:RubikNodeFaceDown andPosition:SCNVector3Make(-1, -1, -1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorYellow face1:RubikNodeFaceBack color2:RubikNodeColorOrange face2:RubikNodeFaceDown andPosition:SCNVector3Make(0, -1, -1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorYellow face1:RubikNodeFaceBack color2:RubikNodeColorBlue face2:RubikNodeFaceRight color3:RubikNodeColorOrange face3:RubikNodeFaceDown andPosition:SCNVector3Make(1, -1, -1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];

    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorWhite face1:RubikNodeFaceLeft color2:RubikNodeColorOrange face2:RubikNodeFaceDown andPosition:SCNVector3Make(-1, -1, 0)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor:RubikNodeColorOrange face:RubikNodeFaceDown andPosition:SCNVector3Make(0, -1, 0)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorBlue face1:RubikNodeFaceRight color2:RubikNodeColorOrange face2:RubikNodeFaceDown andPosition:SCNVector3Make(1, -1, 0)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];

    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorWhite face1:RubikNodeFaceLeft color2:RubikNodeColorGreen face2:RubikNodeFaceFront color3:RubikNodeColorOrange face3:RubikNodeFaceDown andPosition:SCNVector3Make(-1, -1, 1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorGreen face1:RubikNodeFaceFront color2:RubikNodeColorOrange face2:RubikNodeFaceDown andPosition:SCNVector3Make(0, -1, 1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorGreen face1:RubikNodeFaceFront color2:RubikNodeColorBlue face2:RubikNodeFaceRight color3:RubikNodeColorOrange face3:RubikNodeFaceDown andPosition:SCNVector3Make(1, -1, 1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];


    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorYellow face1:RubikNodeFaceBack color2:RubikNodeColorWhite face2:RubikNodeFaceLeft andPosition:SCNVector3Make(-1, 0, -1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor:RubikNodeColorYellow face:RubikNodeFaceBack andPosition:SCNVector3Make(0, 0, -1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorYellow face1:RubikNodeFaceBack color2:RubikNodeColorBlue face2:RubikNodeFaceRight andPosition:SCNVector3Make(1, 0, -1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];

    curNode = [[RubikNode alloc] initWithColor:RubikNodeColorWhite face:RubikNodeFaceLeft andPosition:SCNVector3Make(-1, 0, 0)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor:RubikNodeColorBlue face:RubikNodeFaceRight andPosition:SCNVector3Make(1, 0, 0)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];

    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorWhite face1:RubikNodeFaceLeft color2:RubikNodeColorGreen face2:RubikNodeFaceFront andPosition:SCNVector3Make(-1, 0, 1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor:RubikNodeColorGreen face:RubikNodeFaceFront andPosition:SCNVector3Make(0, 0, 1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorBlue face1:RubikNodeFaceRight color2:RubikNodeColorGreen face2:RubikNodeFaceFront andPosition:SCNVector3Make(1, 0, 1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];


    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorWhite face1:RubikNodeFaceLeft color2:RubikNodeColorRed face2:RubikNodeFaceUp color3:RubikNodeColorYellow face3:RubikNodeFaceBack andPosition:SCNVector3Make(-1, 1, -1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorYellow face1:RubikNodeFaceBack color2:RubikNodeColorRed face2:RubikNodeFaceUp andPosition:SCNVector3Make(0, 1, -1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorYellow face1:RubikNodeFaceBack color2:RubikNodeColorRed face2:RubikNodeFaceUp color3:RubikNodeColorBlue face3:RubikNodeFaceRight andPosition:SCNVector3Make(1, 1, -1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];

    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorWhite face1:RubikNodeFaceLeft color2:RubikNodeColorRed face2:RubikNodeFaceUp andPosition:SCNVector3Make(-1, 1, 0)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor:RubikNodeColorRed face:RubikNodeFaceUp andPosition:SCNVector3Make(0, 1, 0)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorRed face1:RubikNodeFaceUp color2:RubikNodeColorBlue face2:RubikNodeFaceRight andPosition:SCNVector3Make(1, 1, 0)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];

    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorRed face1:RubikNodeFaceUp color2:RubikNodeColorWhite face2:RubikNodeFaceLeft color3:RubikNodeColorGreen face3:RubikNodeFaceFront andPosition:SCNVector3Make(-1, 1, 1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorRed face1:RubikNodeFaceUp color2:RubikNodeColorGreen face2:RubikNodeFaceFront andPosition:SCNVector3Make(0, 1, 1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
    curNode = [[RubikNode alloc] initWithColor1:RubikNodeColorRed face1:RubikNodeFaceUp color2:RubikNodeColorBlue face2:RubikNodeFaceRight color3:RubikNodeColorGreen face3:RubikNodeFaceFront andPosition:SCNVector3Make(1, 1, 1)];
    [_nodes addObject:curNode];
    [_frame addChildNode:curNode.node];
}

@end
