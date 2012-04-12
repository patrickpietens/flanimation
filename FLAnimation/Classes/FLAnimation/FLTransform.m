//
//  FLTransform.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLTransform.h"

@implementation FLTransform

@synthesize symbolName  = _symbolName;
@synthesize matrix      = _matrix;
@synthesize alpha       = _alpha;
@synthesize x           = _x;
@synthesize y           = _y;
@synthesize scaleX      = _scaleX;
@synthesize scaleY      = _scaleY;
@synthesize rotation    = _rotation;
@synthesize position    = _position;


- (id)initWithXMLString:(NSString *)XMLString
{
    self = [self init];
    if(self)
    {
        CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:XMLString options:0 error:nil];

        [_alpha release], _alpha = nil;
        [_x release], _x = nil;
        [_y release], _y = nil;
        [_scaleX release], _scaleX = nil;
        [_scaleY release], _scaleY = nil;
        [_rotation release], _rotation = nil;
        
        _symbolName = [[myDocument.rootElement attributeForName:@"name"].stringValue retain];
        if(_symbolName==nil)
        {
            _symbolName = [[myDocument.rootElement attributeForName:@"libraryItemName"].stringValue retain];
        }
        
        CXMLElement *myMatrix = (CXMLElement *)[myDocument.rootElement nodeForXPath:@"//Matrix" error:nil];
        _matrix.a = [self numberFromNode:[myMatrix attributeForName:@"a"]];
        _matrix.b = [self numberFromNode:[myMatrix attributeForName:@"b"] withDefaultValue:0.0f];
        _matrix.c = [self numberFromNode:[myMatrix attributeForName:@"c"] withDefaultValue:0.0f];
        _matrix.d = [self numberFromNode:[myMatrix attributeForName:@"d"]];
        _matrix.tx = round([self numberFromNode:[myMatrix attributeForName:@"tx"]]);
        _matrix.ty = round([self numberFromNode:[myMatrix attributeForName:@"ty"]]);        
        
        CXMLElement *myColor = (CXMLElement *)[myDocument.rootElement nodeForXPath:@"//Color" error:nil];        
        _alpha = [[NSNumber numberWithFloat:[self numberFromNode:[myColor attributeForName:@"alphaMultiplier"]]] retain];
        
        _x = [[NSNumber numberWithInt:_matrix.tx] retain];
        _y = [[NSNumber numberWithInt:_matrix.ty] retain];
        _position = CGPointMake(_x.intValue, _y.intValue);
        
        _scaleX = [[NSNumber numberWithFloat:sqrtf((_matrix.a * _matrix.a) + (_matrix.c * _matrix.c))] retain];
        _scaleY = [[NSNumber numberWithFloat:sqrtf((_matrix.b * _matrix.b) + (_matrix.d * _matrix.d))] retain];

        CGPoint myPoint1 = CGPointApplyAffineTransform(CGPointMake(-100.f, 0.f), _matrix);
        CGPoint myPoint2 = CGPointApplyAffineTransform(CGPointMake(100.f, 0.f), _matrix);
        
        CGFloat myY = myPoint2.y - myPoint1.y;
        CGFloat myX = myPoint2.x - myPoint1.x;        
        
        _rotation = [[NSNumber numberWithFloat:atan2f(myY, myX)] retain];
        
        [myDocument release];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self) 
    {
        _matrix = CGAffineTransformIdentity;
        _position = CGPointZero;
        
        _alpha = [[NSNumber numberWithFloat:0] retain];
        _x = [[NSNumber numberWithFloat:0] retain];
        _y = [[NSNumber numberWithFloat:0] retain];
        _scaleX = [[NSNumber numberWithFloat:0] retain];
        _scaleY = [[NSNumber numberWithFloat:0] retain];
        _rotation = [[NSNumber numberWithFloat:0] retain];
    }
     
    return self;
}


- (void)dealloc
{
    [_alpha release];
    [_x release];
    [_y release];
    [_scaleX release];
    [_scaleY release];
    [_rotation release];
    
    [_data release];    
    [_symbolName release];
    
    [super dealloc];
}


#pragma mark -


- (float)numberFromNode:(CXMLNode *)value
{
    return [self numberFromNode:value withDefaultValue:1.0f];
}


- (float)numberFromNode:(CXMLNode *)value withDefaultValue:(float)defaultValue
{
    if(!value)
    {
        return defaultValue;
    }
    
    return value.stringValue.floatValue;
}

@end

