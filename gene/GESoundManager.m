//
//  GESoundManager.m
//  gene_SoundManager
//
//  Created by LCR on 12/10/12.
//  Copyright (c) 2012 LCR. All rights reserved.
//

#import "GESoundManager.h"

@implementation GESoundManager

# pragma mark -
# pragma mark Object Lifecycle

+ (GESoundManager *)soleSoundManager {
    static dispatch_once_t once;
    static GESoundManager *soleSoundManager;
    dispatch_once(&once, ^ {
        soleSoundManager = [[self alloc] init];
    });
    return soleSoundManager;
}

- (id)init {
    if (self == [super init]) {
    }
    return self;
}

#pragma mark -
#pragma mark Interfaces

- (void)synthesizeNoteArray:(NSArray *)noteArray instrument:(MusicalInstrument)instrument{
    NSMutableData *concatenatedData = [NSMutableData data];
    for (NSString *note in noteArray) {
        NSString *noteFile = [[NSBundle mainBundle] pathForResource:note ofType:@"mp3"];
        NSURL *filePath = [NSURL fileURLWithPath:noteFile];
        NSData *audioData = [NSData dataWithContentsOfURL:filePath];
        if (audioData != nil) {
            [concatenatedData appendData:audioData];
        } else {
            NSLog(@"Error, no audio data");
        }
    }
    player = [[AVAudioPlayer alloc] initWithData:concatenatedData error:nil];
    [player play];
}

@end
