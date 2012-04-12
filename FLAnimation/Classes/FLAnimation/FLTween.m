//
//  FLTween.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/5/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLTween.h"

@implementation FLTween

@synthesize ease            = _ease;
@synthesize orientToPath    = _orientToPath;

- (id)initWithXMLString:(NSString *)XMLString
{
    self = [self init];
    if(self)
    {
        CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:XMLString options:0 error:nil];
        
        NSString *myEase = [myDocument.rootElement attributeForName:@"acceleration"].stringValue;
        if(myEase)
        {
            if(myEase.intValue > 0)
            {
                _ease = [[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] retain];
            }
            else 
            {
                _ease = [[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut] retain];
            }
        }
        
        _orientToPath = [myDocument.rootElement attributeForName:@"motionTweenOrientToPath"].stringValue!=nil;
        
        [myDocument release];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self) 
    {
        _orientToPath = NO;
        _ease = [[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [_ease release];
    [super dealloc];
}

@end

