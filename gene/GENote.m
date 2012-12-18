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
const float trebleClefDistance = 80;

@implementation GENote
@synthesize noteType,noteLength;
@synthesize touchPoint,touchPoint2,TBCenterPoint;
@synthesize orderInAllNotes;

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
    
    //用來取mod?找到大於零小餘一塊積木大小的值！！再去判斷是多長！！
    float noteLengthRef = point.x - TBCenter.x;
    
    while (noteLengthRef > blockWidth) {
        noteLengthRef -= blockWidth;
    }
    
    [self setNoteLengthWithRef:noteLengthRef];
    
    return self;
    
}

- (id)initWithTouchPoint:(CGPoint)point NoteType:(NSInteger)type{
    
    self.noteType = type;
    self.touchPoint = point;
    
    return self;
    
}

//not done yet.
- (void)setNoteLengthWithRef:(float)ref{
    
    NSLog(@"note length set!");
    
}

- (BOOL)isTrebleClef{
    
    if (touchPoint2.x == 0 && touchPoint2.y == 0) {
        return NO;
    }
    
    else return YES;
    
}

@end
