//
//  DOMObject.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/2/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface FLObject : NSObject
{
    BOOL                    _isReady;
}

@property (nonatomic, readonly) BOOL            isReady;

- (void)ready;
- (void)update;

@end
