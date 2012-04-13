//
//  FLShape.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLShape.h"

@implementation FLShape

@synthesize path            = _path;


- (id)initWithXMLString:(NSString *)XMLString
{
    self = [self init];
    if(self)
    {
        CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:XMLString options:0 error:nil];
        
        NSArray *myEdges = [myDocument.rootElement nodesForXPath:@"//Edge" error:nil];
        CXMLElement *myEdge = [myEdges objectAtIndex:0];
        [self makePathFromString:[myEdge attributeForName:@"edges"].stringValue];
        
        [myDocument release];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if(self)
    {
        _path = CGPathCreateMutable();
        
    }
    
    return self;
}


- (void)dealloc
{
    CGPathRelease(_path);
    [super dealloc];
}


#pragma mark -


- (void)makePathFromString:(NSString *)string
{
    NSMutableString *myString = [NSMutableString stringWithString:string];
    [myString replaceOccurrencesOfString:@"  " withString:@" " options:0 range:NSMakeRange(0, myString.length)];
    [myString replaceOccurrencesOfString:@" !" withString:@"!" options:0 range:NSMakeRange(0, myString.length)];
    [myString replaceOccurrencesOfString:@" [" withString:@"[" options:0 range:NSMakeRange(0, myString.length)];
    [myString replaceOccurrencesOfString:@" \\" withString:@"\\" options:0 range:NSMakeRange(0, myString.length)];
    
	NSCharacterSet *myCharacters = [NSCharacterSet characterSetWithCharactersInString:@"![\\|"];
	NSScanner *myScanner = [NSScanner scannerWithString:myString];
    
    while (!myScanner.isAtEnd) 
    {
        NSAutoreleasePool *myPool = [[NSAutoreleasePool alloc] init];
        
        [myScanner scanUpToCharactersFromSet:myCharacters intoString:nil];
        if(!myScanner.isAtEnd)
        {
            NSString *myScanResult = [myScanner.string substringFromIndex:myScanner.scanLocation + 1];
            NSScanner *myValueScanner = [NSScanner scannerWithString:myScanResult];
            
            [myValueScanner scanUpToCharactersFromSet:myCharacters intoString:nil];                    
            NSArray *myValues = [[myScanResult substringToIndex:myValueScanner.scanLocation] componentsSeparatedByString:@" "];
            
            unichar myCharacter = [myString characterAtIndex:myScanner.scanLocation];
            switch (myCharacter) {
                    // MoveTo
                case '!':
                    CGPathMoveToPoint(_path, NULL, 
                                      FLConvertStringToFloat([myValues objectAtIndex:0]), 
                                      FLConvertStringToFloat([myValues objectAtIndex:1]));
                    
                    break;
                    
                    // CurveTo
                case ']':
                case '[':
                    CGPathAddQuadCurveToPoint(_path, NULL, 
                                              FLConvertStringToFloat([myValues objectAtIndex:0]),
                                              FLConvertStringToFloat([myValues objectAtIndex:1]),
                                              FLConvertStringToFloat([myValues objectAtIndex:2]),
                                              FLConvertStringToFloat([myValues objectAtIndex:3]));
                    break;
                    
                    // LineTo
                case '/':
                case '|':
                    CGPathAddLineToPoint(_path, NULL, 
                                              FLConvertStringToFloat([myValues objectAtIndex:0]),
                                              FLConvertStringToFloat([myValues objectAtIndex:1]));
                    break;
                    
            }
            
            myScanner.scanLocation++;            
        }
        
        [myPool release];                                   
    }
}

@end