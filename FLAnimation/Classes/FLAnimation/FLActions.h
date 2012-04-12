//
//  FLActionscript.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface FLActions : NSObject
{
    @private
    NSMutableArray        *_actions;
}

@property (nonatomic, readonly) NSArray         *actions;

- (id)initWithXMLString:(NSString *)XMLString;
- (void)parseActions:(NSString *)actions;

@end


#pragma mark -


@interface FLAction : NSObject
{
    NSString        *_methodName;
    NSArray         *_arguments;
}

@property (nonatomic, readonly) NSString    *methodName;
@property (nonatomic, readonly) NSArray     *arguments;

- (id)initWithString:(NSString *)string;

@end