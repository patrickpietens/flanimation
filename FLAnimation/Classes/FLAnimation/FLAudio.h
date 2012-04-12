//
//  FLSound.h
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TouchXML.h"

typedef enum {
	FLAudioLoop = 0,
	FLAudioLoopRepeat
} FLAudioLoopMode;

@class FLLibrary;

@interface FLAudio : NSObject
{
    NSString            *_soundName;
    AVAudioPlayer       *_player;
    FLAudioLoopMode     _loopMode;
    FLLibrary           *_library;
}

@property (nonatomic, readonly) FLAudioLoopMode     loopMode;
@property (nonatomic, readonly) NSString            *soundName;
@property (nonatomic, readonly) AVAudioPlayer       *player;
@property (nonatomic, assign) FLLibrary             *library;

- (id)initWithXMLString:(NSString *)XMLString;
- (void)play;

@end
