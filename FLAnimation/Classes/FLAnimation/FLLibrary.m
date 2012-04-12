//
//  FLLibrary.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/6/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLLibrary.h"

@implementation FLLibrary

@synthesize directory=_directory;

- (id)initWithAssets:(NSArray *)assets inDirectory:(NSString *)directory
{
    self = [self init];
    if(self)
    {
        _directory = [NSString stringWithFormat:@"%@/LIBRARY", directory];        
        [assets enumerateObjectsUsingBlock:^(CXMLElement *element, NSUInteger idx, BOOL *stop) {

            NSString *myKey = [element attributeForName:@"name"].stringValue;
            NSString *myHref = [element attributeForName:@"href"].stringValue;
            
            if([element.name isEqualToString:@"DOMBitmapItem"])
            {
                NSString *myPath = [[NSBundle mainBundle] pathForResource:myHref.stringByDeletingPathExtension ofType:myHref.pathExtension inDirectory:_directory];
                UIImage *myImage = [UIImage imageWithContentsOfFile:myPath];
                
                [_assets setObject:myImage forKey:myKey];                       
            }
            else if([element.name isEqualToString:@"Include"])
            {
                NSString *myPath = [[NSBundle mainBundle] pathForResource:myHref.stringByDeletingPathExtension ofType:@"xml" inDirectory:_directory];
                
                NSData *myData = [NSData dataWithContentsOfFile:myPath];    
                CXMLDocument *myDocument = [[CXMLDocument alloc] initWithData:myData options:0 error:nil];
                
                [_assets setObject:myDocument.rootElement forKey:myHref];                       
                
                // TODO: Release document
                //[myDocument release];                
            }
        }];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self) 
    {
        _assets = [[NSMutableDictionary dictionary] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [_assets release];
    [super dealloc];
}


#pragma mark -


- (id)assetWithName:(NSString *)name
{
    return [_assets objectForKey:name];
}


- (BOOL)hasAssetWithName:(NSString *)name
{
    return [self assetWithName:name] != nil;
}

@end
 