//
//  DOMTimeline.m
//  PPFlashroot
//
//  Created by Patrick Pietens on 4/2/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLTimeline.h"
#import "FLAnimation.h"
#import "FLLayer.h"

@implementation FLTimeline

@synthesize root                = _root;
@synthesize layers              = _layers;
@synthesize layer               = _layer;

@synthesize currentFrame        = _currentFrame;
@synthesize totalFrames         = _totalFrames;
@synthesize stopped             = _stopped;


- (id)initWithXMLString:(NSString *)XMLString
{
    self = [self init];
    if(self)
    {
        CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:XMLString options:0 error:nil];
        
        NSArray *myLayers = [myDocument nodesForXPath:@"//DOMLayer" error:nil];
        [self parseLayers:myLayers];
        
        [myDocument release];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self) 
    {
        _layers = [[NSMutableArray array] retain];        

        _currentFrame = -1;
        _totalFrames = 0;          
        
        _layer = [[CALayer layer] retain];
        [_layer setAnchorPoint:CGPointMake(0, 0)];
    }
    
    return self;
}


- (void)dealloc
{
    [_layer removeFromSuperlayer];    
    [_layers release];
    
    _root = nil;
    
    [super dealloc];
}


#pragma mark -


- (void)parseLayers:(NSArray *)layers
{
    [layers enumerateObjectsUsingBlock:^(CXMLElement* layer, NSUInteger idx, BOOL *stop) {
        FLLayer *myLayer = [[FLLayer alloc] initWithXMLString:layer.XMLString];        
        [_layers addObject:myLayer];        
        [myLayer release];
    }];    
}


- (void)ready
{
    [_layers enumerateObjectsUsingBlock:^(FLLayer *layer, NSUInteger idx, BOOL *stop) {
        if(!layer.isGuide)
        {
            if(layer.hasGuide)
            {
                [layer setGuideLayer:[_layers objectAtIndex:layer.guideLayerIndex]];
            }

            _totalFrames = MAX(layer.totalFrames, _totalFrames);
        }
        
        [layer setRoot:_root];
        [layer setParent:self];
        [layer ready];
    }];
    
    [_layer setFrame:_root.layer.frame];
    [_root.layer insertSublayer:_layer atIndex:0];
    
    [super ready];
}


- (void)update
{
    if(_isReady)
    {
        if(!_stopped)
        {
            _currentFrame++;
            if(_currentFrame > _totalFrames)
            {
                _currentFrame = 0;
                if([_root.timeline isEqual:self])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kFLTimelineReachedLastFrame object:self];    
                }
            }                    
        }
        
        [_layers enumerateObjectsUsingBlock:^(FLLayer *layer, NSUInteger idx, BOOL *stop) {
            [layer update];
        }];
    }
}
     
@end
