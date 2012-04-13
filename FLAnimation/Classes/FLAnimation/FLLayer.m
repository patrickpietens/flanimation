//
//  PPLayer.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 3/30/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLLayer.h"
#import "FLActions.h"
#import "FLAnimation.h"
#import "FLFrame.h"
#import "FLShape.h"
#import "FLSymbol.h"
#import "FLTimeline.h"
#import "FLTransform.h"
#import "FLTween.h"

@implementation FLLayer

@synthesize root                = _root;
@synthesize parent              = _parent;

@synthesize keyframes              = _keyframes;
@synthesize hasGuide            = _hasGuide;
@synthesize isGuide             = _isGuide;
@synthesize totalFrames         = _totalFrames;

@synthesize guideLayerIndex     = _guideLayerIndex;
@synthesize guideLayer          = _guideLayer;
@synthesize currentKeyframe     = _currentKeyframe;

- (id)initWithXMLString:(NSString *)XMLString;
{
    self = [self init];
    if(self)
    {
        CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:XMLString options:0 error:nil];
        
        _isGuide = [[myDocument.rootElement attributeForName:@"layerType"].stringValue isEqualToString:@"guide"];
        _hasGuide = [myDocument.rootElement attributeForName:@"parentLayerIndex"].stringValue!=nil; 
        _guideLayerIndex = [myDocument.rootElement attributeForName:@"parentLayerIndex"].stringValue.intValue;
        
        NSArray *myFrames = [myDocument nodesForXPath:@"//DOMFrame" error:nil];        
        [self parseFrames:myFrames];
        
        FLFrame *myLastFrame = [_keyframes lastObject];
        _totalFrames = myLastFrame.index + myLastFrame.duration;

        NSArray *mySymbols = [myDocument nodesForXPath:@"//DOMSymbolInstance|//DOMBitmapInstance|//DOMShape" error:nil];        
        [self parseSymbols:mySymbols];
        
        [myDocument release];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self) 
    {
        _currentKeyIndex = 0;    
        _hasGuide = NO;
        
        _keyframes = [[NSMutableArray array] retain];
        _symbols = [[NSMutableArray array] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [_symbols release];
    [_keyframes release];
    
    _parent = nil;
    _root = nil;
    
    [super dealloc];
}


#pragma mark -


- (void)parseFrames:(NSArray *)frames
{
    [frames enumerateObjectsUsingBlock:^(CXMLElement* frame, NSUInteger idx, BOOL *stop) {
        FLFrame *myFrame = [[FLFrame alloc] initWithXMLString:frame.XMLString];            
        [_keyframes addObject:myFrame];
        
        [myFrame release];
    }];            
}


- (void)parseSymbols:(NSArray *)symbols
{
    if(!self.isGuide)
    {
        __block NSMutableDictionary *myDictionary = [NSMutableDictionary dictionary];
        [symbols enumerateObjectsUsingBlock:^(CXMLElement *symbol, NSUInteger idx, BOOL *stop) {
            FLSymbol *mySymbol = [[FLSymbol alloc] initWithXMLString:symbol.XMLString];
            
            if([myDictionary objectForKey:mySymbol.name]==nil)
            {
                [_symbols addObject:mySymbol];
                if(mySymbol.name)
                {
                    [myDictionary setObject:mySymbol forKey:mySymbol.name];                    
                }
            }
            
            [mySymbol release];
        }];        
        
        [myDictionary removeAllObjects];
    }
}


- (void)ready
{
    [_keyframes enumerateObjectsUsingBlock:^(FLFrame *frame, NSUInteger idx, BOOL *stop) {
        if(idx<(_keyframes.count-1))
        {
            FLFrame *myNextFrame = [_keyframes objectAtIndex:(idx+1)];
            [frame setNextFrame:myNextFrame];   
        }

        [frame setRoot:self.root];
        [frame setParent:self];
        [frame ready];
    }];    

    [_symbols enumerateObjectsUsingBlock:^(FLSymbol *symbol, NSUInteger idx, BOOL *stop) {
        [symbol setRoot:_root];
        [symbol setParent:self];
        [symbol ready];
        
        [_parent.layer insertSublayer:symbol.layer atIndex:0];
    }];

    [super ready];
}


- (void)update
{
    if(self.isReady)
    {
        if(!_parent.stopped)
        {
            if(_parent.currentFrame==0)
            {
                _currentKeyIndex = 0;
            }
            
            if(_currentKeyIndex<_keyframes.count)
            {
                _currentKeyframe = [_keyframes objectAtIndex:_currentKeyIndex];
            }

            if(_currentKeyframe.index==_parent.currentFrame)
            {    
                if(!self.isGuide)
                {
                    [_symbols enumerateObjectsUsingBlock:^(FLSymbol *symbol, NSUInteger idx, BOOL *stop) {
                        if(symbol.type == FLSymbolTypeMovieClip)
                        {
                            [symbol.layer removeAllAnimations];                            
                            
                            [self transformSymbol:symbol];
                            if(_currentKeyframe.hasTween)
                            {
                                [self tweenToNextKeyframe:symbol];                    
                            }
                        }
                    }];
                }
                
                [self performActionscript]; 
                [self playAudio];
                
                _currentKeyIndex++;          
            }   
        }
        
        [_symbols enumerateObjectsUsingBlock:^(FLSymbol *symbol, NSUInteger idx, BOOL *stop) {
            [symbol update];
        }];
    }
}


- (void)transformSymbol:(FLSymbol *)symbol
{
    [CATransaction begin];	
    [CATransaction setDisableActions:YES];

    FLTransform *myTransform = [_currentKeyframe transformForSymbol:symbol];
    [symbol.layer setOpacity:myTransform.alpha.floatValue];

    CGAffineTransform myMatrix = CGAffineTransformIdentity;
    myMatrix = CGAffineTransformRotate(myMatrix, myTransform.rotation.floatValue);
    myMatrix = CGAffineTransformScale(myMatrix, myTransform.scaleY.floatValue, myTransform.scaleY.floatValue);    

    [symbol.layer setAffineTransform:myMatrix];
    [symbol.layer setPosition:myTransform.position];

    [symbol setHidden:![_currentKeyframe hasSymbol:symbol]];
    
    [CATransaction commit];    
}


- (void)tweenToNextKeyframe:(FLSymbol *)symbol
{   
    if(!symbol.hidden)
    {        
        FLTransform *myTransformTo = [_currentKeyframe.nextFrame transformForSymbol:symbol];
        
        CABasicAnimation *myOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [myOpacity setToValue:myTransformTo.alpha];
        
        CABasicAnimation *myRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [myRotation setToValue:myTransformTo.rotation];
        
        CABasicAnimation *myScaleX = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        [myScaleX setToValue:myTransformTo.scaleX];
        
        CABasicAnimation *myScaleY = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        [myScaleY setToValue:myTransformTo.scaleY];
        
        CAAnimation *myTranslation = nil;
        if(_hasGuide && (_currentKeyframe.index==_guideLayer.currentKeyframe.index))
        {
            myTranslation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            [(id)myTranslation setPath:_guideLayer.currentKeyframe.guide.path];
            [(id)myTranslation setCalculationMode:kCAAnimationPaced];
            
            if(_currentKeyframe.tween.orientToPath)
            {
                [(id)myTranslation setRotationMode:@"auto"];     
                myRotation = nil;
            }
        }
        else 
        {
            CABasicAnimation *myPositionX = [CABasicAnimation animationWithKeyPath:@"position.x"];
            [myPositionX setToValue:myTransformTo.x];
            
            CABasicAnimation *myPositionY = [CABasicAnimation animationWithKeyPath:@"position.y"];
            [myPositionY setToValue:myTransformTo.y];
            
            myTranslation = [CAAnimationGroup animation];
            [(id)myTranslation setAnimations:[NSArray arrayWithObjects:myPositionX, myPositionY, nil]];
        }
        
        CAAnimationGroup *myGroup = [CAAnimationGroup animation];
        [myGroup setTimingFunction:_currentKeyframe.tween.ease];
        [myGroup setAnimations:[NSArray arrayWithObjects:myTranslation, myScaleX, myScaleY, myOpacity, myRotation, nil]];
        [myGroup setFillMode:kCAFillModeForwards];
        [myGroup setRemovedOnCompletion:NO];
        
        float myDuration = _currentKeyframe.duration / _parent.root.framerate;            
        [myGroup setDuration:myDuration];
        
        [symbol.layer addAnimation:myGroup forKey:@"tween"];        
    }
}


#pragma mark -


- (void)performActionscript
{
    [_currentKeyframe.actions.actions enumerateObjectsUsingBlock:^(FLAction *action, NSUInteger idx, BOOL *stop) {
        if([action.methodName isEqualToString:@"trace"])
        {
            NSLog(@"%@", [action.arguments componentsJoinedByString:@","]);
        }
        else if ([action.methodName isEqualToString:@"stop"])
        {
            _parent.stopped = YES;
        }
    }];
}


- (void)playAudio
{
    if(_currentKeyframe.hasAudio)
    {
        [_currentKeyframe.audio play];
    }
}

@end
