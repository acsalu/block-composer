//
//  GENote.m
//  gene
//
//  Created by Wang Chi-An on 12/12/9.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import "GENote.h"
#import "GECalculateHelper.h"

const float blockWidth = 110;
const NSRange rangeEigthNote = {0,36};
const NSRange rangeQuarterNote = {36,36};
const NSRange rangeHalfNote = {72, 38};
const float trebleClefDistance = 80;

@implementation GENote
@synthesize noteType,noteLength;
@synthesize touchPoint,touchPoint2,TBCenterPoint;
@synthesize orderInAllNotes;
@synthesize isTrebleClef;

+ (NSArray*)getTrebleClefPointsWith:(NSMutableDictionary *)dic{
    
    for (int i = 0; i < [dic count] - 1; ++i) {
        GENote *note1 = [dic objectForKey:[[dic allKeys] objectAtIndex:i]];
        GENote *note2 = [dic objectForKey:[[dic allKeys] objectAtIndex:i+1]];
        float distance = [GECalculateHelper getDistanceBetweenTwoPoint:note1.touchPoint andPoint:note2.touchPoint];
        
        if ([GECalculateHelper isTheSameDistanceFor:distance andDistance:trebleClefDistance ByTolerating:5] && [GECalculateHelper isNotFarConsideringOneCoordinateWithPoint:note1.touchPoint andPoint:note2.touchPoint ByTolerating:8]) {
            //this two point is treble Clef.
            
        }
        else return nil;
        
        
    }
    
}



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

- (id)initWithTouchPoint:(CGPoint)point NoteType:(NSInteger)type AndTrebleClefCenter:(CGPoint)TBCenter{
    
    self.noteType = type;
    self.touchPoint = point;
    self.isTrebleClef = NO;
    
    //用來取mod?找到大於零小餘一塊積木大小的值！！再去判斷是多長！！
    //[self setNoteLengthWithRef:noteLengthRef];
    [self updateNoteLengthWithTrebleClefCenter:TBCenter];
    
    
    return self;
    
}

- (id)initTrebleClefWithTouchPoint:(CGPoint)point1 AndTouchPoint:(CGPoint)point2{
    
    touchPoint = point1;
    touchPoint2 = point2;
    self.isTrebleClef = YES;
    
    self.noteType = 0;
    TBCenterPoint = CGPointMake((point1.x + point2.x)/2, (point1.y + point2.y)/2) ;
    
    return self;
    
}

- (id)initWithTouchPoint:(CGPoint)point NoteType:(NSInteger)type{
    
    self.noteType = type;
    self.touchPoint = point;
    self.isTrebleClef = NO;
    
    return self;
    
}

/*
- (BOOL)isTrebleClef{
    
    if (touchPoint2.x == 0 && touchPoint2.y == 0) {
        return NO;
    }
    
    else return YES;
    
}
 */

- (void)updateTrebleClefPointWithPoint:(CGPoint)point{
    
    if ([GECalculateHelper getDistanceBetweenTwoPoint:touchPoint andPoint:point] > [GECalculateHelper getDistanceBetweenTwoPoint:touchPoint2 andPoint:point]) {
        [self setTouchPoint2:point];
    }
    else
        [self setTouchPoint:point];
    
    TBCenterPoint = CGPointMake( (touchPoint.x + touchPoint2.x)/2, (touchPoint.y + touchPoint2.y)/2);
}

//the const value of the range is defined in this .m's header.
//check which range it is in, determines its note length
/****2****|****4****|****8****/

- (void)updateNoteLengthWithTrebleClefCenter:(CGPoint)TBCenter{
    
    NSUInteger distanceFromTB = abs(touchPoint.x - TBCenter.x);
    
    while (distanceFromTB > blockWidth) {
        distanceFromTB -= blockWidth;
    }
    
    if (NSLocationInRange(distanceFromTB, rangeHalfNote)) {
        noteLength = halfNote;
        return;
    }
    else if (NSLocationInRange(distanceFromTB, rangeQuarterNote)){
        noteLength = quarterNote;
        return;
    }
    else if (NSLocationInRange(distanceFromTB, rangeEigthNote)){
        noteLength = eigthNote;
        return;
    }
    
}

- (void)updateNoteType:(NoteType)type{
    
    self.noteType = type;
    
}

@end
