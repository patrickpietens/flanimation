//
//  DOMTimeline.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/2/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "FLObject.h"
#import "TouchXML.h"

#define kFLTimelineReachedLastFrame     @"FLTimelineReachedLastFrame"

@class FLAnimation, FLLayer;

@interface FLTimeline : FLObject
{
    NSInteger           _currentFrame;    
    NSInteger           _totalFrames;
    BOOL                _stopped;
    
    FLAnimation         *_root;
    NSMutableArray      *_layers;
    CALayer             *_layer;
}

@property (nonatomic, readonly) NSInteger       currentFrame;
@property (nonatomic, readonly) NSInteger       totalFrames;
@property (nonatomic, assign) BOOL              stopped;

@property (nonatomic, assign) FLAnimation       *root;
@property (nonatomic, readonly) NSArray         *layers;
@property (nonatomic, readonly) CALayer         *layer;

- (id)initWithXMLString:(NSString *)XMLString;
- (void)parseLayers:(NSArray *)layers;

@end
