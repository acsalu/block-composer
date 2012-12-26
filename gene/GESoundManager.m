//
//  GESoundManager.m
//  gene_SoundManager
//
//  Created by LCR on 12/10/12.
//  Copyright (c) 2012 LCR. All rights reserved.
//

#import "GESoundManager.h"
#import "GENote.h"

NSString * const GESoundMgrPiano = @"Piano";
NSString * const GESoundMgrGuitar = @"Guitar";

@interface GESoundManager ()

@property (nonatomic, strong) NSArray *answerNoteArray;

@end

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
    if ((self = [super init])) {
    }
    return self;
}

#pragma mark -
#pragma mark Interfaces

- (void)playSynthesizedNoteArray:(NSArray *)noteArray instrument:(NSString *)instrument{
    
    if (self.playing) {
        NSLog(@"Audio player is playing.");
        return;
    }
    
    // store/update user array
    // self.userNoteArray = [NSMutableArray arrayWithArray:noteArray];
    
    NSMutableData *concatenatedData = [NSMutableData data];
    for (NSString *note in noteArray) {
        NSString *noteFile = [[NSBundle mainBundle] pathForResource:note ofType:@"mp3"];
        if (noteFile == nil) {
            NSLog(@"Can't locate note file");
            continue;
        }
        NSURL *filePath = [NSURL fileURLWithPath:noteFile];
        NSData *audioData = [NSData dataWithContentsOfURL:filePath];
        if (audioData != nil) {
            [concatenatedData appendData:audioData];
        } else {
            NSLog(@"Error, no audio data in %@", note);
        }
    }
    
    player = [[AVAudioPlayer alloc] initWithData:concatenatedData error:nil];
    player.delegate = self;
    [player play];
    self.playing = YES;
}

- (void)playAnswerOrSingleNote:(NSString *)songName instrument:(NSString *)instrument{
    if (self.playing) {
        NSLog(@"Audio player is playing.");
        return;
    }
    
    NSString *answerFile = [[NSBundle mainBundle] pathForResource:songName ofType:@"mp3"];
    if (answerFile == nil) {
        NSLog(@"Can't locate answer file");
        return;
    }
    NSURL *answerURL = [NSURL fileURLWithPath:answerFile];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:answerURL error:nil];
    player.delegate = self;
    [player play];
    self.playing = YES;
}


//pass in ans array should contain description and usrArray should contain
//GENote.
+ (BOOL)verifyAnswerWithAnswerArray:(NSArray*)ans andUserArray:(NSArray*)usrArray{
    
    NSLog(@"ans = %@",ans);
    NSLog(@"usrArray = %@",usrArray);
    
    for (int i = 0; i < [ans count]; ++i) {
        if (![[usrArray objectAtIndex:i] isKindOfClass:[GENote class]]) {
            return NO;
        }
        if (![[ans objectAtIndex:i] isEqualToString:[(GENote*)[usrArray objectAtIndex:i] description]]) {
            return NO;
        }
    }

    return YES;
}


# pragma mark -
# pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"in Delegate");
    self.playing = NO;
    if (flag == NO) {
        NSLog(@"Audio player decoding error.");
    }
}

@end
