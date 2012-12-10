//
//  GENote.m
//  gene
//
//  Created by Wang Chi-An on 12/12/9.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import "GENote.h"

@implementation GENote
@synthesize noteType,noteLength;
@synthesize touchPoint;
@synthesize orderInAllNotes;

- (void)initWithTouchPoint:(CGPoint)point AndNotesArray:(NSArray *)notesArray{
    
    touchPoint = point;
    
    if (point.y > 226 - 13.5 && point.y < 226 + 13.5) {
        noteType = Fa;
    } else if (point.y > 226 + 13.5 && point.y < 280 - 13.5) {
        noteType = Mi;
    } else if (point.y > 280 - 13.5 && point.y < 280 + 13.5) {
        noteType = Re;
    } else if (point.y > 280 + 13.5 && point.y < 334 - 13.5) {
        noteType = Do;
    }
    
    //see whether it is the x that affects the length of the note.
    //depends on the distance from the last note on iPad.
    noteLength = quarterNote;
    
    //他是上面所有音符當中第幾個
    orderInAllNotes = [notesArray count] + 1;
    
}

@end
