//
//  GESoundManager.h
//  gene_SoundManager
//
//  Created by LCR on 12/10/12.
//  Copyright (c) 2012 LCR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString * const GESoundMgrInstrunmentPiano;
extern NSString * const GESoundMgrInstrunmentGuitar;


@interface GESoundManager : NSObject <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
}

@property (nonatomic) BOOL playing;
@property (nonatomic, strong) NSMutableArray *userNoteArray;

+ (GESoundManager *)soleSoundManager;
+ (BOOL)verifyAnswerWithAnswerArray:(NSArray*)ans andUserArray:(NSArray*)usrArray;

- (void)playSynthesizedNoteArray:(NSArray *)noteArray instrument:(NSString *)instrument;
- (void)playAnswerWithoutSynthesis:(NSString *)songName;

@end
