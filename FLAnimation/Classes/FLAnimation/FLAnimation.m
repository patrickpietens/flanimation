//
//  PPAnimation.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 3/30/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLAnimation.h"
#import "FLLibrary.h"
#import "FLTimeline.h"

@implementation FLAnimation

@synthesize framerate       = _framerate;
@synthesize layer           = _layer;
@synthesize library         = _library;
@synthesize timeline        = _timeline;
@synthesize name            = _name;


+ (FLAnimation *)animationWithName:(NSString *)name;
{
    return [[[FLAnimation alloc] initWithName:name] autorelease];
}


- (FLAnimation *)initWithName:(NSString *)name
{
    self = [super init];
    if(self)
    {
        _name = [name retain];
        _layer = [[CALayer layer] retain];

        NSString *myPath = [[NSBundle mainBundle] pathForResource:@"DOMDocument" ofType:@"xml" inDirectory:name];
        NSData *myData = [NSData dataWithContentsOfFile:myPath];

        NSDictionary *myMappings = [NSDictionary dictionaryWithObject:@"http://ns.adobe.com/xfl/2008/" forKey:@"adobe"];
        
        _data = [[CXMLDocument alloc] initWithData:myData options:0 error:nil];
        _framerate = [_data.rootElement attributeForName:@"frameRate"].stringValue.doubleValue;
        
        CGRect myFrame = CGRectZero;
        myFrame.size.width = [_data.rootElement attributeForName:@"width"].stringValue.intValue;
        myFrame.size.height = [_data.rootElement attributeForName:@"height"].stringValue.intValue;
        [_layer setFrame:myFrame];
        
        NSArray *myAssets = [_data nodesForXPath:@"//adobe:DOMBitmapItem|//adobe:Include" namespaceMappings:myMappings error:nil];        
        _library = [[FLLibrary alloc] initWithAssets:myAssets inDirectory:name];
        
        NSArray *myScenes = [_data nodesForXPath:@"//adobe:DOMTimeline" namespaceMappings:myMappings error:nil];
        CXMLElement *myScene = [myScenes lastObject];
        _timeline = [[FLTimeline alloc] initWithXMLString:myScene.XMLString];
        
        [_timeline setRoot:self];
        [_timeline ready];
        
        [self update];        
    }
    
    return self;
}


- (void)dealloc
{    
    [_layer removeFromSuperlayer];
    [_timer invalidate];
    
    [_name release];
    [_layer release];
    [_timer release];
    [_library release];
    [_timeline release];
    
    // TODO: Releasing XCXMLDocument causes the app to crash.
    // This is a known bug from TouchXML when using XPath.
    
    // [_data release];

    [super dealloc];
}


#pragma mark -


- (void)update
{
    [_timeline update];
    [_layer setNeedsDisplay];
}


- (void)play
{
    double myInterval = 1.0f / self.framerate;
    _timer = [[NSTimer scheduledTimerWithTimeInterval:myInterval target:self selector:@selector(update) userInfo:nil repeats:YES] retain];
}


- (void)stop
{
    [_timer invalidate], 
    [_timer release], _timer = nil;
}

@end