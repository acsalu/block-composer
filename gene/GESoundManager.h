//
//  GESoundManager.h
//  gene_SoundManager
//
//  Created by LCR on 12/10/12.
//  Copyright (c) 2012 LCR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    Piano = 1 << 0,
    Guitar = 1 << 1
} MusicalInstrument;

@interface GESoundManager : NSObject {
    AVAudioPlayer *player;
}

+ (GESoundManager *)soleSoundManager;

- (void)synthesizeNoteArray:(NSArray *)noteArray instrument:(MusicalInstrument)instrument;

@end
