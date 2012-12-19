//
//  GENote.h
//  gene
//
//  Created by Wang Chi-An on 12/12/9.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//
//A class saving datas needed for one note.
// it's location x. y.
// whether it is Do Re Mi? or a treble clef or a rest
// the order of current all notes on the pad.
// how long is this note?

#import <Foundation/Foundation.h>

extern const float trebleClefDistance;

typedef enum {
    //
    TrebleClef,
    // 中央C
    Do, Re, Mi, Fa, So, La, Si,
    // octave 高八度
    DoOctave, ReOctave, MiOctave, FaOctave, SoOctave, LaOctave, SiOctave,
    // preoctave 低八度
    DoPreoctave, RePreoctave, MiPreoctave, FaPreoctave, SoPreoctave, LaPreoctave, SiPreoctave,
    Rest = 99
    
} NoteType;

typedef enum {
    
    eigthNote = 8,//八分音符
    quarterNote = 4,//四分音符
    halfNote = 2,//二分音符
    wholeNote = 1,//全音符
    
}NoteLength;


@interface GENote : NSObject{
    
    BOOL isTrebleClef;
    
}

@property(nonatomic)CGPoint touchPoint;
@property(nonatomic)CGPoint touchPoint2;
@property(nonatomic)CGPoint TBCenterPoint;

@property(nonatomic)NSInteger noteType;
@property(nonatomic)NSInteger noteLength;
@property(nonatomic)NSInteger orderInAllNotes;

@property(nonatomic)BOOL isTrebleClef;

- (void)initWithTouchPoint:(CGPoint)point AndNotesArray:(NSArray*)notesArray;


+ (NSArray*)getTrebleClefPointsWith:(NSMutableDictionary*)dic;
- (id)initWithTouchPoint:(CGPoint)point NoteType:(NSInteger)type AndTrebleClefCenter:(CGPoint)TBCenter;
- (id)initWithTouchPoint:(CGPoint)point NoteType:(NSInteger)type;
- (id)initTrebleClefWithTouchPoint:(CGPoint)point1 AndTouchPoint:(CGPoint)point2;

//a function only should be called if the GENote is treble clef.
//would determine which touchpoint(two of them) is closer and would update that one.
- (void)updateTrebleClefPointWithPoint:(CGPoint)point;
- (void)updateNoteType:(NoteType)type;
- (void)updateNoteLengthWithTrebleClefCenter:(CGPoint)TBCenter;
//- (BOOL)isTrebleClef;

@end
