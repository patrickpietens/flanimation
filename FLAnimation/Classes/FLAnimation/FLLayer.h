//
//  PPLayer.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 3/30/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "FLObject.h"
#import "TouchXML.h"

@class FLAnimation, FLFrame, FLSymbol, FLTimeline, FLTween;

@interface FLLayer : FLObject
{   
    @private
    BOOL                _isGuide;
    BOOL                _hasGuide;

    NSInteger           _currentKeyIndex;
    NSInteger           _totalFrames;
     
    FLAnimation         *_root;    
    FLTimeline          *_parent;

    FLLayer             *_guideLayer;
    NSInteger           _guideLayerIndex;
    FLFrame             *_currentKeyframe;
    NSMutableArray      *_keyframes;
    NSMutableArray      *_symbols;        
}

@property (nonatomic, readonly) BOOL            hasGuide;
@property (nonatomic, readonly) BOOL            isGuide;
@property (nonatomic, readonly) NSInteger       totalFrames;
@property (nonatomic, readonly) NSInteger       guideLayerIndex;

@property (nonatomic, assign) FLAnimation       *root;
@property (nonatomic, assign) FLTimeline        *parent;

@property (nonatomic, assign) FLLayer           *guideLayer;
@property (nonatomic, readonly) FLFrame         *currentKeyframe;
@property (nonatomic, readonly) NSArray         *keyframes;

- (id)initWithXMLString:(NSString *)XMLString;

- (void)parseFrames:(NSArray *)frames;
- (void)parseSymbols:(NSArray *)symbols;

- (void)transformSymbol:(FLSymbol *)symbol;
- (void)tweenToNextKeyframe:(FLSymbol *)symbol;

- (void)performActionscript;
- (void)playAudio;

@end
