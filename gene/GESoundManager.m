//
//  GESoundManager.m
//  gene_SoundManager
//
//  Created by LCR on 12/10/12.
//  Copyright (c) 2012 LCR. All rights reserved.
//

#import "GESoundManager.h"

NSString * const GESoundMgrInstrumentPiano = @"Piano";
NSString * const GESoundMgrInstrunmentGuitar = @"Guitar";

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

- (void)playSynthesizedNoteArray:(NSArray *)noteArray instrument:(NSString *)instrument{
    
    // store/update user array
//    self.userNoteArray = [NSMutableArray arrayWithArray:noteArray];
    
    NSMutableData *concatenatedData = [NSMutableData data];
    for (NSString *note in noteArray) {
        NSString *noteFile = [[NSBundle mainBundle] pathForResource:note
                                                             ofType:@"mp3"
                                                        inDirectory:instrument];
        NSURL *filePath = [NSURL fileURLWithPath:noteFile];
        NSData *audioData = [NSData dataWithContentsOfURL:filePath];
        if (audioData != nil) {
            [concatenatedData appendData:audioData];
        } else {
            NSLog(@"Error, no audio data in %@", note);
        }
    }
    player = [[AVAudioPlayer alloc] initWithData:concatenatedData error:nil];
    [player play];
}



@end
