//
//  FLViewController.h
//  FLAnimation
//
//  Created by Patrick Pietens on 4/12/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimation.h"

@interface FLViewController : UIViewController
{
    @private
    FLAnimation     *_animation;
}

- (void)didReachLastFrame:(NSNotification *)notification;

@end
