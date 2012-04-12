//
//  FLLibrary.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/6/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"

@interface FLLibrary : NSObject
{
    NSString                *_directory;
    NSMutableDictionary     *_assets;
}

@property (nonatomic, readonly) NSString    *directory;

- (id)initWithAssets:(NSArray *)assets inDirectory:(NSString *)directory;
- (BOOL)hasAssetWithName:(NSString *)name;
- (id)assetWithName:(NSString *)name;

@end
