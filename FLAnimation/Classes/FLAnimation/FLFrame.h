//
//  PPFrame.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 3/30/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "FLObject.h"
#import "TouchXML.h"

@class FLAnimation, FLLayer, FLActions, FLAudio, FLShape, FLSymbol, FLTransform, FLTween;

@interface FLFrame : FLObject
{
    @private
    BOOL                        _hasAudio;
    BOOL                        _hasActions;    
    BOOL                        _hasTween;
    BOOL                        _hasSound;
    
    NSInteger                   _index;
    NSInteger                   _duration;
    
    NSString                    *_name;
    NSMutableDictionary         *_transformations;
        
    FLAnimation                 *_root;
    FLLayer                     *_parent;
    
    FLActions                   *_actions;
    FLAudio                     *_audio;
    FLFrame                     *_nextFrame;
    FLShape                     *_guide;
    FLTween                     *_tween;
}

@property (nonatomic, readonly) BOOL                    hasActions;
@property (nonatomic, readonly) BOOL                    hasAudio;
@property (nonatomic, readonly) BOOL                    hasTween;
@property (nonatomic, readonly) BOOL                    hasSound;

@property (nonatomic, readonly) NSInteger               index;
@property (nonatomic, readonly) NSInteger               duration;
@property (nonatomic, readonly) NSString                *name;

@property (nonatomic, assign) FLAnimation               *root;
@property (nonatomic, assign) FLLayer                   *parent;

@property (nonatomic, assign) FLFrame                   *nextFrame;
@property (nonatomic, readonly) FLAudio                 *audio;
@property (nonatomic, readonly) FLActions               *actions;
@property (nonatomic, readonly) FLShape                 *guide;
@property (nonatomic, readonly) FLTween                 *tween;

- (id)initWithXMLString:(NSString *)XMLString;

- (BOOL)hasSymbol:(FLSymbol *)symbol;
- (FLTransform *)transformForSymbol:(FLSymbol *)symbol;

@end