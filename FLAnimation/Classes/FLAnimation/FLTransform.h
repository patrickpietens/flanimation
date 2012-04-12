//
//  FLTransform.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface FLTransform : NSObject
{
    CGPoint             _position;
    CGAffineTransform   _matrix;

    CXMLDocument        *_data;
    NSString            *_symbolName;
    NSNumber            *_x;
    NSNumber            *_y;    
    NSNumber            *_rotation;
    NSNumber            *_scaleX;
    NSNumber            *_scaleY;
    NSNumber            *_alpha;
}

@property (nonatomic, readonly) CGPoint             position;
@property (nonatomic, readonly) CGAffineTransform   matrix;

@property (nonatomic, readonly) NSString            *symbolName;
@property (nonatomic, readonly) NSNumber            *x;
@property (nonatomic, readonly) NSNumber            *y;
@property (nonatomic, readonly) NSNumber            *rotation;
@property (nonatomic, readonly) NSNumber            *scaleX;
@property (nonatomic, readonly) NSNumber            *scaleY;
@property (nonatomic, readonly) NSNumber            *alpha;

- (id)initWithXMLString:(NSString *)XMLString;

- (float)numberFromNode:(CXMLNode *)value;
- (float)numberFromNode:(CXMLNode *)value withDefaultValue:(float)defaultValue;

@end

