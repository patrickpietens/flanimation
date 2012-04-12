//
//  FLAppDelegate.m
//  FLAnimation
//
//  Created by Patrick Pietens on 4/12/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLAppDelegate.h"

@implementation FLAppDelegate

@synthesize window          = _window;
@synthesize viewController  = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[FLViewController alloc] initWithNibName:@"FLViewController" bundle:nil] autorelease];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
