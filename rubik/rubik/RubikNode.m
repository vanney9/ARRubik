//
//  RubikNode.m
//  rubik
//
//  Created by vanney on 2017/11/24.
//  Copyright © 2017年 vanney9. All rights reserved.
//

#import "RubikNode.h"

static const CGFloat kNodeSize = 0.1f;

@interface RubikNode()
@property (nonatomic, assign) RubikNodeColor color1;
@property (nonatomic, assign) RubikNodeColor color2;
@property (nonatomic, assign) RubikNodeColor color3;

@property (nonatomic, assign) RubikNodeFace face1;
@property (nonatomic, assign) RubikNodeFace face2;
@property (nonatomic, assign) RubikNodeFace face3;

@property (nonatomic, assign) RubikNodeType type;
@end

@implementation RubikNode

- (instancetype)initWithColor:(RubikNodeColor)color face:(RubikNodeFace)face andPosition:(SCNVector3)position {
    return [[RubikNode alloc] initWithColor1:color
                                       face1:face
                                      color2:RubikNodeColorNone
                                       face2:RubikNodeFaceNone
                                      color3:RubikNodeColorNone
                                       face3:RubikNodeFaceNone
                                 andPosition:position
                                     andType:RubikNodeTypeOneFace];
}

- (instancetype)initWithColor1:(RubikNodeColor)color1 face1:(RubikNodeFace)face1 color2:(RubikNodeColor)color2 face2:(RubikNodeFace)face2 andPosition:(SCNVector3)position {
    return [[RubikNode alloc] initWithColor1:color1
                                       face1:face1
                                      color2:color2
                                       face2:face2
                                      color3:RubikNodeColorNone
                                       face3:RubikNodeFaceNone
                                 andPosition:position
                                     andType:RubikNodeTypeTwoFace];
}

- (instancetype)initWithColor1:(RubikNodeColor)color1 face1:(RubikNodeFace)face1 color2:(RubikNodeColor)color2 face2:(RubikNodeFace)face2 color3:(RubikNodeColor)color3 face3:(RubikNodeFace)face3 andPosition:(SCNVector3)position {
    return [[RubikNode alloc] initWithColor1:color1
                                       face1:face1
                                      color2:color2
                                       face2:face2
                                      color3:color3
                                       face3:face3
                                 andPosition:position
                                     andType:RubikNodeTypeThreeFace];
}

- (void)rotateXWithDirection:(BOOL)direction {
    SCNMatrix4 finalM;
    if (direction) {
        finalM = SCNMatrix4Rotate(self.node.transform, M_PI_2, 1, 0, 0);
    } else {
        finalM = SCNMatrix4Rotate(self.node.transform, -M_PI_2, 1, 0, 0);
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithSCNMatrix4:self.node.transform];
    animation.toValue = [NSValue valueWithSCNMatrix4:finalM];
    animation.duration = 1.0f;
    animation.fillMode = kCAFillModeForwards;
    [animation setRemovedOnCompletion:NO];
    self.node.transform = finalM;
    [self.node addAnimation:animation forKey:nil];

    NSInteger newY, newZ;
    if (!direction) {
        if (self.y == 0) {
            newZ = 0;
        } else if (self.y == -1) {
            newZ = 1;
        } else {
            newZ = -1;
        }

        newY = self.z;
    } else {
        if (self.z == 0) {
            newY = 0;
        } else if (self.z == -1) {
            newY = 1;
        } else {
            newY= -1;
        }

        newZ = self.y;
    }


    self.z = newZ;
    self.y = newY;
}

- (void)rotateYWithDirection:(BOOL)direction {
    SCNMatrix4 finalM;
    if (direction) {
        finalM = SCNMatrix4Rotate(self.node.transform, M_PI_2, 0, 1, 0);
    } else {
        finalM = SCNMatrix4Rotate(self.node.transform, -M_PI_2, 0, 1, 0);
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithSCNMatrix4:self.node.transform];
    animation.toValue = [NSValue valueWithSCNMatrix4:finalM];
    animation.duration = 1.0f;
    animation.fillMode = kCAFillModeForwards;
    [animation setRemovedOnCompletion:NO];
    self.node.transform = finalM;
    [self.node addAnimation:animation forKey:nil];

    NSInteger newX, newZ;
    if (direction) {
        if (self.x == 0) {
            newZ = 0;
        } else if (self.x == -1) {
            newZ = 1;
        } else {
            newZ = -1;
        }

        newX = self.z;
    } else {
        if (self.z == 0) {
            newX = 0;
        } else if (self.z == -1) {
            newX = 1;
        } else {
            newX = -1;
        }

        newZ = self.x;
    }


    self.z = newZ;
    self.x = newX;

}

- (void)rotateZWithDirection:(BOOL)direction {
    SCNMatrix4 finalM;
    if (direction) {
        finalM = SCNMatrix4Rotate(self.node.transform, M_PI_2, 0, 0, 1);
    } else {
        finalM = SCNMatrix4Rotate(self.node.transform, -M_PI_2, 0, 0, 1);
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithSCNMatrix4:self.node.transform];
    animation.toValue = [NSValue valueWithSCNMatrix4:finalM];
    animation.duration = 1.0f;
    animation.fillMode = kCAFillModeForwards;
    [animation setRemovedOnCompletion:NO];
    self.node.transform = finalM;
    [self.node addAnimation:animation forKey:nil];

    NSInteger newX, newY;
    if (!direction) {
        if (self.x == 0) {
            newY = 0;
        } else if (self.x == -1) {
            newY = 1;
        } else {
            newY = -1;
        }

        newX = self.y;
    } else {
        if (self.y == 0) {
            newX = 0;
        } else if (self.y == -1) {
            newX = 1;
        } else {
            newX = -1;
        }

        newY = self.x;
    }


    self.y = newY;
    self.x = newX;
}


- (instancetype)initWithColor1:(RubikNodeColor)color1 face1:(RubikNodeFace)face1 color2:(RubikNodeColor)color2 face2:(RubikNodeFace)face2 color3:(RubikNodeColor)color3 face3:(RubikNodeFace)face3 andPosition:(SCNVector3)position andType:(RubikNodeType)type {
    if (self = [super init]) {
        _color1 = color1;
        _color2 = color2;
        _color3 = color3;

        _face1 = face1;
        _face2 = face2;
        _face3 = face3;

        _type = type;

        _x = position.x;
        _y = position.y;
        _z = position.z;

        [self p_createNode];
    }

    return self;
}

- (void)p_createNode {
    SCNBox *boxGeometry = [SCNBox boxWithWidth:kNodeSize height:kNodeSize length:kNodeSize chamferRadius:kNodeSize / 10];
    SCNMaterial *blackMaterial = [SCNMaterial new];

    blackMaterial.diffuse.contents = [UIColor blackColor];
    blackMaterial.locksAmbientWithDiffuse = YES;

    SCNMaterial *color1Material = [SCNMaterial new];
    color1Material.diffuse.contents = [self p_getColorWithRubikColor:_color1];
    color1Material.locksAmbientWithDiffuse = YES;
    //color1Material.diffuse.contents = [UIColor whiteColor];

    SCNMaterial *color2Material = [SCNMaterial new];
    color2Material.diffuse.contents = [self p_getColorWithRubikColor:_color2];
    color2Material.locksAmbientWithDiffuse = YES;

    SCNMaterial *color3Material = [SCNMaterial new];
    color3Material.diffuse.contents = [self p_getColorWithRubikColor:_color3];
    color3Material.locksAmbientWithDiffuse = YES;
    //color1Material.diffuse.contents = [UIColor orangeColor];

    NSUInteger faces = _face1 | _face2 | _face3;
    //NSLog(@"vanney code log : face is %d", faces);
    NSUInteger curFace = 1 << 0;
    NSMutableArray *colors = [NSMutableArray new];
    for (int i = 0; i < 6; ++i) {
//        NSLog(@"vanney code log : curface is %d", curFace);
//        NSLog(@"vanney code log : curface & faces is %d", curFace & faces);
        NSUInteger perResult = curFace & faces;
        if (perResult == 0) {
            //NSLog(@"vanney code log : black color face");
            [colors addObject:blackMaterial];
        } else {
            if (curFace == _face1) {
                [colors addObject:color1Material];
            } else if (curFace == _face2) {
                [colors addObject:color2Material];
            } else {
                [colors addObject:color3Material];
            }
        }

        curFace = curFace << 1;
        //[colors addObject:blackMaterial];
    }

    //colors = @[blackMaterial, blackMaterial, color2Material, color1Material, blackMaterial, color3Material];
    boxGeometry.materials = colors;

    _node = [SCNNode nodeWithGeometry:boxGeometry];
    _node.position = SCNVector3Make(_x * kNodeSize, _y * kNodeSize, _z * kNodeSize);
}

- (UIColor *)p_getColorWithRubikColor:(RubikNodeColor)color {
    switch (color) {
        case RubikNodeColorBlue:
            return [UIColor blueColor];
        case RubikNodeColorGreen:
            return [UIColor greenColor];
        case RubikNodeColorOrange:
            //NSLog(@"vanney code log : orange");
            return [UIColor orangeColor];
        case RubikNodeColorRed:
            return [UIColor redColor];
        case RubikNodeColorWhite:
            //NSLog(@"vanney code log : white");
            return [UIColor whiteColor];
        case RubikNodeColorYellow:
            //NSLog(@"vanney code log : yellow");
            return [UIColor yellowColor];
        default:
            return [UIColor blackColor];
    }
}


@end
