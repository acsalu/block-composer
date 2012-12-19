//
//  GEStaff.h
//  gene
//
//  Created by Wang Chi-An on 12/12/18.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GENote.h"

@interface GEStaff : UIViewController{
    
    UILabel *testLabel;
    //save all the note's CGPointString -> GENote
    //including treble Clef.
    NSMutableDictionary *notesOnStaff;
    //save all the note's CGPoint on the Staff, sorted with point.x
    //treble Clef not included.
    NSMutableArray *notesSequence;
    GENote *TrebleClef;
    
}

@end
