//
//  FLViewController.m
//  FLAnimation
//
//  Created by Patrick Pietens on 3/30/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLViewController.h"

@implementation FLViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didReachLastFrame:) 
                                                     name:kFLTimelineReachedLastFrame 
                                                   object:nil];
    }
         
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObject:self];
    [_animation release];

    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _animation = [[FLAnimation animationWithName:@"example"] retain];
    [self.view.layer addSublayer:_animation.layer];
    
    [_animation play];
}


- (void)viewDidUnload
{
    [_animation release], _animation = nil;
    [super viewDidUnload];
}


#pragma mark -  


- (void)didReachLastFrame:(NSNotification *)notification
{
    NSLog(@"Reached end of animation: %@", _animation.name);    
}

@end
