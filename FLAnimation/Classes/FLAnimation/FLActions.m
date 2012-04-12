//
//  FLActionscript.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLActions.h"

@implementation FLActions

@synthesize actions     = _actions;


- (id)initWithXMLString:(NSString *)XMLString;
{
    self = [self init];
    if(self)
    {
        CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:XMLString options:0 error:nil];

        NSString *myActions = [myDocument nodeForXPath:@"//script" error:nil].stringValue;
        [self parseActions:myActions];
        
        [myDocument release];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self) 
    {
        _actions = [[NSMutableArray array] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [_actions release];
    [super dealloc];
}


#pragma mark -


- (void)parseActions:(NSString *)actions
{
    NSArray *myActions = [actions componentsSeparatedByString:@"\n"];
    [myActions enumerateObjectsUsingBlock:^(NSString *action, NSUInteger idx, BOOL *stop) {
        FLAction *myAction = [[FLAction alloc] initWithString:action];
        
        [_actions addObject:myAction];
        
        [myAction release];
    }];
}

@end


#pragma mark -


@implementation FLAction

@synthesize methodName      = _methodName;
@synthesize arguments       = _arguments;

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if(self)
    {
        NSRegularExpression *myExpression = [NSRegularExpression regularExpressionWithPattern:@"^(.+?)\\((.*?)\\);?$" options:NSRegularExpressionCaseInsensitive error:nil];
        NSTextCheckingResult *myResult = [myExpression firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];        

        _methodName = [string substringWithRange:[myResult rangeAtIndex:1]];
        _methodName = [[[_methodName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] retain];
        
        _arguments = [[[string substringWithRange:[myResult rangeAtIndex:2]] componentsSeparatedByString:@","] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [_methodName release];
    [_arguments release];
    
    [super dealloc];
}


@end
