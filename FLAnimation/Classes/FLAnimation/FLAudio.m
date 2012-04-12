//
//  FLSound.m
//  PPFlashAnimation
//
//  Created by Patrick Pietens on 4/4/12.
//  Copyright (c) 2012 PatrickPietens.com. All rights reserved.
//

#import "FLAudio.h"
#import "FLLibrary.h"

@implementation FLAudio

@synthesize player      = _player;
@synthesize soundName   = _soundName;
@synthesize loopMode    = _loopMode;
@synthesize library     = _library;


- (id)initWithXMLString:(NSString *)XMLString
{
    self = [self init];
    if (self)
    {
        CXMLDocument *myDocument = [[CXMLDocument alloc] initWithXMLString:XMLString options:0 error:nil];
        _soundName = [[myDocument.rootElement attributeForName:@"soundName"].stringValue retain];
        
        [myDocument release];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self) 
    {
        _loopMode = FLAudioLoopRepeat;
    }

    return self;
}


- (void)dealloc
{
    [_player stop];
    
    [_player release];
    [_soundName release];
    
    [super dealloc];
}


#pragma mark -


- (void)play
{
    [_player stop];
    [_player play];
}


#pragma mark -
#pragma mark Accessory methods


- (void)setLibrary:(FLLibrary *)library
{
    _library = library;
    
    NSString *myPath = [[NSBundle mainBundle] pathForResource:_soundName.stringByDeletingPathExtension ofType:_soundName.pathExtension inDirectory:library.directory];
    NSURL *myURL = [NSURL fileURLWithPath:myPath];

    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:myURL error:nil];
    if(_loopMode == FLAudioLoop)
    {
        [_player setNumberOfLoops:-1];            
    }    

    [_player prepareToPlay];
}

@end
