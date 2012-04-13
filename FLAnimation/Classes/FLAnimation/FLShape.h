//
//  FLShape.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

CG_INLINE float FLConvertHexStringToFloat(NSMutableString *value)
{
    NSMutableString *myDecimal = [NSMutableString stringWithString:value];
    [myDecimal replaceOccurrencesOfString:@"." withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, myDecimal.length)];
    [myDecimal replaceOccurrencesOfString:@"#" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, myDecimal.length)];
    myDecimal = [NSString stringWithFormat:@"0x%@%@", [@"0000000" substringToIndex:8 - myDecimal.length], myDecimal];
    
    int n; sscanf([myDecimal UTF8String], "%x", &n);
    NSNumber *myNumber = [NSNumber numberWithInt:n];
    
    return myNumber.floatValue / 256;
}


CG_INLINE float FLConvertStringToFloat(NSMutableString *value)
{
    float myValue = value.floatValue;
    if([value rangeOfString:@"#"].location != NSNotFound)
    {
        myValue = FLConvertHexStringToFloat(value);
    }
        
    return myValue / 20;    
}


#pragma mark -


@interface FLShape : NSObject
{
    @private
    CGMutablePathRef    _path;
}

@property (nonatomic, readonly) CGMutablePathRef    path;

- (id)initWithXMLString:(NSString *)XMLString;
- (void)makePathFromString:(NSString *)string;

@end