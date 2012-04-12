//
//  PPFrame.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 3/30/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLFrame.h"
#import "FLActions.h"
#import "FLAudio.h"
#import "FLAnimation.h"
#import "FLShape.h"
#import "FLSymbol.h"
#import "FLTransform.h"
#import "FLTween.h"

@implementation FLFrame

@synthesize hasActions          = _hasActions;
@synthesize hasAudio            = _hasAudio;
@synthesize hasTween            = _hasTween;
@synthesize hasSound            = _hasSound;

@synthesize index               = _index;
@synthesize name                = _name;
@synthesize duration            = _duration;

@synthesize root                = _root;
@synthesize parent              = _parent;

@synthesize actions             = _actions;
@synthesize audio               = _audio;
@synthesize nextFrame           = _nextFrame;
@synthesize guide               = _guide;
@synthesize tween               = _tween;


- (id)initWithXMLString:(NSString *)XMLString;
{
    self = [self init];
    if(self)
    {
        CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:XMLString options:0 error:nil];        
        
        NSString *myIndex   = [myDocument.rootElement attributeForName:@"index"].stringValue;
        _name               = [NSString stringWithFormat:@"Frame %@", myIndex];        
        _index              = [myDocument.rootElement attributeForName:@"index"].stringValue.intValue;
        _duration           = [myDocument.rootElement attributeForName:@"duration"].stringValue.intValue;
        
        CXMLElement *myGuide = (CXMLElement *)[myDocument.rootElement nodeForXPath:@"//DOMShape" error:nil];        
        if(myGuide)
        {
            _guide = [[FLShape alloc] initWithXMLString:myGuide.XMLString];
        }
        
        CXMLElement *myAction = (CXMLElement *)[myDocument.rootElement nodeForXPath:@"//Actionscript" error:nil];        
        if(myAction)
        {
            _hasActions = YES;
            _actions = [[FLActions alloc] initWithXMLString:myAction.XMLString];
        }
        
        NSArray *myTransforms = [myDocument nodesForXPath:@"//DOMSymbolInstance" error:nil];        
        [myTransforms enumerateObjectsUsingBlock:^(CXMLElement *transform, NSUInteger idx, BOOL *stop) {
            FLTransform *myTransform = [[FLTransform alloc] initWithXMLString:transform.XMLString];
            [_transformations setObject:myTransform forKey:myTransform.symbolName];
            
            [myTransform release];
        }];
        
        NSString *mySoundName = [myDocument.rootElement attributeForName:@"soundName"].stringValue;
        if(mySoundName)
        {
            _hasAudio = YES;            
            _audio = [[FLAudio alloc] initWithXMLString:myDocument.XMLString];
        }

        
        NSString *myTweenType = [myDocument.rootElement attributeForName:@"tweenType"].stringValue;
        if(myTweenType)
        {
            _hasTween = YES;
            _tween = [[FLTween alloc] initWithXMLString:myDocument.XMLString];
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
        _hasAudio = NO;
        _hasActions = NO; 
        _hasSound = NO;
        _hasTween = NO;
        
        _transformations = [[NSMutableDictionary dictionary] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [_tween release];
    [_guide release];
    
    [_actions release];
    [_audio release];
    [_transformations release];

    _nextFrame = nil;
    _parent = nil;
    _root = nil;
    
    [super dealloc];
}


#pragma mark -


- (void)ready
{
    if(_hasAudio)
    {
        [_audio setLibrary:_root.library];
    }

    [super ready];
}


- (BOOL)hasSymbol:(FLSymbol *)symbol
{
    return [_transformations objectForKey:symbol.name] != nil;
}


- (FLTransform *)transformForSymbol:(FLSymbol *)symbol
{
    return [_transformations objectForKey:symbol.name];
}

@end


