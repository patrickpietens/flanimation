//
//  DOMObject.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/2/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLObject.h"

@implementation FLObject

@synthesize isReady     = _isReady;


- (id)init
{
    self = [super init];
    if(self)
    {
        _isReady = NO;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)ready
{    
    _isReady = YES;
}


- (void)update
{
}


@end
