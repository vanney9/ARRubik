//
//  RubikNode.h
//  rubik
//
//  Created by vanney on 2017/11/24.
//  Copyright © 2017年 vanney9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>


typedef NS_OPTIONS(NSUInteger, RubikNodeFace) {
    RubikNodeFaceNone = 0,
    RubikNodeFaceFront = 1 << 0,
    RubikNodeFaceRight = 1 << 1,
    RubikNodeFaceBack = 1 << 2,
    RubikNodeFaceLeft = 1 << 3,
    RubikNodeFaceUp = 1 << 4,
    RubikNodeFaceDown = 1 << 5
};

typedef NS_ENUM(NSInteger, RubikNodeColor) {
    RubikNodeColorWhite = 0,
    RubikNodeColorOrange,
    RubikNodeColorYellow,
    RubikNodeColorRed,
    RubikNodeColorGreen,
    RubikNodeColorBlue,
    RubikNodeColorNone
};

typedef NS_ENUM(NSInteger, RubikNodeType) {
    RubikNodeTypeOneFace = 0,
    RubikNodeTypeTwoFace,
    RubikNodeTypeThreeFace
};

//const CGFloat RubikNodeSize = 0.1f;

@interface RubikNode : NSObject

@property (nonatomic, strong) SCNNode *node;

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;

- (instancetype)initWithColor:(RubikNodeColor)color face:(RubikNodeFace)face andPosition:(SCNVector3)position;
- (instancetype)initWithColor1:(RubikNodeColor)color1 face1:(RubikNodeFace)face1 color2:(RubikNodeColor)color2 face2:(RubikNodeFace)face2 andPosition:(SCNVector3)position;
- (instancetype)initWithColor1:(RubikNodeColor)color1 face1:(RubikNodeFace)face1 color2:(RubikNodeColor)color2 face2:(RubikNodeFace)face2 color3:(RubikNodeColor)color3 face3:(RubikNodeFace)face3 andPosition:(SCNVector3)position;

- (void)rotateXWithDirection:(BOOL)direction;
- (void)rotateYWithDirection:(BOOL)direction;
- (void)rotateZWithDirection:(BOOL)direction;

@end
