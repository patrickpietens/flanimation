//
//  PPAnimation.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 3/30/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "TouchXML.h"

#import "FLTimeline.h"
#import "FLLayer.h"
#import "FLFrame.h"
#import "FLSymbol.h"

#import "FLActions.h"
#import "FLAudio.h"
#import "FLLibrary.h"
#import "FLObject.h"
#import "FLShape.h"
#import "FLSymbol.h"
#import "FLTransform.h"
#import "FLTween.h"

@class FLLibrary, FLTimeline;

@interface FLAnimation : NSObject
{
    double                  _framerate;
    
    NSString                *_name;
    CXMLDocument            *_data;
    NSTimer                 *_timer;
    FLLibrary               *_library;
    FLTimeline              *_timeline;
    CALayer                 *_layer;
}

@property (nonatomic, readonly) double                  framerate;
@property (nonatomic, readonly) CALayer                 *layer;
@property (nonatomic, readonly) FLLibrary               *library;
@property (nonatomic, readonly) FLTimeline              *timeline;
@property (nonatomic, readonly) NSString                *name;

+ (FLAnimation *)animationWithName:(NSString *)name;
- (FLAnimation *)initWithName:(NSString *)name;

- (void)play;
- (void)stop;
- (void)update;

@end
