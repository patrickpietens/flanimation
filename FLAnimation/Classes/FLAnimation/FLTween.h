//
//  FLTween.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/5/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "TouchXML.h"

@interface FLTween : NSObject
{
    BOOL                        _orientToPath;
    CAMediaTimingFunction       *_ease;
}

@property (nonatomic, readonly) BOOL                    orientToPath;
@property (nonatomic, readonly) CAMediaTimingFunction   *ease;

- (id)initWithXMLString:(NSString *)XMLString;

@end
