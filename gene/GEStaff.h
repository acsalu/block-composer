//
//  GEStaff.h
//  gene
//
//  Created by Wang Chi-An on 12/12/18.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GENote.h"
#import "GEDragToPlayView.h"

enum room {
    Room1 = 100,
    Room2 = 101,
    Room3 = 102,
    Room4 = 103,
    Room5 = 104,
    Room6 = 105,
    Room7 = 106
    };

@interface GEStaff : UIViewController{
    
    UILabel *testLabel;
    //save all the note's CGPointString -> GENote
    //including treble Clef.
    NSMutableDictionary *notesOnStaff;
    //save all the note's CGPoint on the Staff, sorted with point.x
    //treble Clef not included.
    NSMutableArray *notesSequence;
    NSArray *answer;
    
    NSArray *roomArray;
    NSArray *staffViewArray;
    
    GENote *TrebleClef;
    //save the tuned value.
    //NSMutableArray *tuneValue;
}

@property (strong, nonatomic)NSArray *answer;
@property (strong, nonatomic)NSMutableArray *notesSequence;
@property (strong, nonatomic)NSString *songChosen;

@end
