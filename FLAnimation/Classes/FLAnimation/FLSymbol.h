//
//  FLElement.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "TouchXML.h"
#import "FLTimeline.h"

typedef enum {
	FLSymbolTypeMovieClip = 0,
	FLSymbolTypeGraphic,
    FLSymbolTypeShape
} FLSymbolType;

@class FLLayer, FLShape, FLSymbolShapeDelegate;

@interface FLSymbol : FLTimeline
{
    BOOL                    _hidden;
    FLSymbolType            _type;

    NSString                *_assetName;
    NSString                *_name;    
    FLLayer                 *_parent;
    
    FLShape                 *_shape;
    FLSymbolShapeDelegate   *_shapeDelegate;
}

@property (nonatomic, assign) BOOL              hidden;
@property (nonatomic, readonly) FLSymbolType    type;

@property (nonatomic, readonly) NSString        *name;
@property (nonatomic, assign) FLLayer           *parent;

- (void)parseAsShape;
- (void)parseAsGraphic;
- (void)parseAsTimeline;

@end


#pragma mark -

@interface FLSymbolShapeDelegate : NSObject
{
    CGMutablePathRef    _path;
}

@property (nonatomic, assign) CGMutablePathRef     path;

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context;

@end