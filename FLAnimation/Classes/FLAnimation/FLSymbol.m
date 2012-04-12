//
//  FLElement.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLSymbol.h"
#import "FLAnimation.h"
#import "FLLayer.h"
#import "FLLibrary.h"
#import "FLShape.h"

@implementation FLSymbol

@synthesize name            = _name;
@synthesize hidden          = _hidden;
@synthesize parent          = _parent;
@synthesize type            = _type;


- (id)initWithXMLString:(NSString *)XMLString;
{
    self = [self init];
    if(self)
    {
        CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:XMLString options:0 error:nil];
        NSDictionary *myTypes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:0], @"DOMSymbolInstance", 
                                      [NSNumber numberWithInt:1], @"DOMBitmapInstance", 
                                      [NSNumber numberWithInt:2], @"DOMShape", nil];
        
        NSString *myType = myDocument.rootElement.name;
        _type = [[myTypes objectForKey:myType] intValue];
        
        _assetName = [[myDocument.rootElement attributeForName:@"libraryItemName"].stringValue retain]; 
        _name = [[myDocument.rootElement attributeForName:@"name"].stringValue retain];
        
        if(_name==nil)
        {
            _name = [_assetName retain];
        }

        if(_type==FLSymbolTypeShape)
        {
            _shape = [[FLShape alloc] initWithXMLString:XMLString];
        }
        
        [myDocument release];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self) 
    {
        _hidden = NO;
    }
    
    return self;
}


- (void)dealloc
{
    [_layer release];
    [_assetName release];
    [_name release];
    [_parent release];
    
    [_shape release];
    [_shapeDelegate release];
    
    _parent = nil;
    
    [super dealloc];
}


#pragma mark -


- (void)ready
{
    switch (_type)
    {
        case FLSymbolTypeMovieClip:
            [self parseAsTimeline];
            break;
            
        case FLSymbolTypeGraphic:
            [self parseAsGraphic];
            break;
            
        case FLSymbolTypeShape:
            [self parseAsShape];
            break;
    }
}


- (void)update
{
    if(!_layer.hidden || _type==FLSymbolTypeMovieClip)
    {
        [super update];
    }
}


- (void)parseAsShape
{
    _shapeDelegate = [[FLSymbolShapeDelegate alloc] init];
    [_shapeDelegate setPath:_shape.path];
    
    [_layer setAnchorPoint:CGPointMake(0.5, 0.5)];    
    [self.layer setBounds:CGRectMake(0, 0, 30, 30)];
    [self.layer setDelegate:_shapeDelegate];
    [self.layer setNeedsDisplay];
    
    [super ready];
}


- (void)parseAsGraphic
{
    [super ready];

    UIImage *myImage = [self.root.library assetWithName:@"ladybug.png"];
    CGRect myFrame = _layer.frame;
    myFrame.size = myImage.size;

    [_layer setFrame:myFrame];    
    [_layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_layer setContents:(id)myImage.CGImage];
}


- (void)parseAsTimeline
{
    NSString *myName = [NSString stringWithFormat:@"%@.xml", _assetName];
    CXMLElement *myData = [_root.library assetWithName:myName];

    NSDictionary *myMappings = [NSDictionary dictionaryWithObject:@"http://ns.adobe.com/xfl/2008/" forKey:@"adobe"];    
    NSArray *myTimelines = [myData nodesForXPath:@"//adobe:DOMTimeline" namespaceMappings:myMappings error:nil];

    CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:[[myTimelines lastObject] XMLString] options:0 error:nil];
    NSArray *myLayers = [myDocument.rootElement nodesForXPath:@"//DOMLayer" error:nil];
    
    [self parseLayers:myLayers];
    [super ready];
    
    [myDocument release];
}


#pragma mark -
#pragma mark Accessory methods


- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    [_layer setHidden:_hidden];
    
    if(_hidden)
    {
        _currentFrame = 0;
    }
}

@end


#pragma mark -


@implementation FLSymbolShapeDelegate

@synthesize path        = _path;

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
    CGContextAddPath(context, _path);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);

    // TODO: Fill is not working
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
