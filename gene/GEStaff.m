//
//  GEStaff.m
//  gene
//
//  Created by Wang Chi-An on 12/12/18.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import "GEStaff.h"
#import "GECalculateHelper.h"
#import "GEDragToPlayView.h"

// declare in GENote.h
// const float trebleClefDistance = 80;
@interface GEStaff ()

@end

@implementation GEStaff

@synthesize answer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [testLabel setTextColor:[UIColor blackColor]];
    [testLabel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:testLabel];
    
    [self.view setMultipleTouchEnabled:YES];
    UIImageView *backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [backGroundImage setImage:[UIImage imageNamed:@"staff_back.png"]];
    [self.view addSubview:backGroundImage];
    
    [self drawStaffWithPoint:CGPointMake(15, 30)];
    
    GEDragToPlayView *drag = [[GEDragToPlayView alloc]initWithFrame:CGRectMake(10, 400, 950, 200)];
    [self.view addSubview:drag];
    
    
    NSLog(@"trebleClef = %@" ,TrebleClef);
    
    notesOnStaff = [[NSMutableDictionary alloc]init];
    notesSequence = [[NSMutableArray alloc]init];
    
    
}


- (void)drawStaffWithPoint:(CGPoint)point{
    
    NSInteger x = point.x;
    NSInteger y = point.y;
    NSInteger lineHeight = 22;
    NSInteger whiteHeight = 25;
    //specify the width in here XDD sorry
    NSInteger width = 950;
    
    for (int i = 7; i > 0; --i) {
        
        UIView *white = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, whiteHeight)];
        [white setBackgroundColor:[UIColor clearColor]];
        [white setTag:i*2];
        y += whiteHeight;
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, lineHeight)];
        if (i == 1 || i == 7) {
            [line setBackgroundColor:[UIColor clearColor]];
        }
        else{
            [line setImage:[UIImage imageNamed:@"line.png"]];
        }
        [line setTag:i*2-1];
        y += lineHeight;
        [self.view addSubview:white];
        [self.view addSubview:line];
        
    }
    
}

#pragma mark - touches related functions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for(UITouch* touch in touches){
        
        [testLabel setText:NSStringFromCGPoint([touch locationInView:self.view])];
        NSLog(@"tag = %d",[self getTouchedViewNoteTypeWithTouch:touch]);
        
        if (TrebleClef == NULL) {
            NSLog(@"==null!!");
            
            GENote *note = [[GENote alloc]initWithTouchPoint:[touch locationInView:self.view] NoteType:[self getTouchedViewNoteTypeWithTouch:touch]];
            [notesSequence addObject:[NSValue valueWithCGPoint:[touch locationInView:self.view]]];
            [notesOnStaff setValue:note forKey:NSStringFromCGPoint([touch locationInView:self.view])];
            
            
        }
        else{
            
            GENote *note = [[GENote alloc]initWithTouchPoint:[touch locationInView:self.view] NoteType:[self getTouchedViewNoteTypeWithTouch:touch]    AndTrebleClefCenter:TrebleClef.TBCenterPoint];
            [notesSequence addObject:[NSValue valueWithCGPoint:[touch locationInView:self.view]]];
            [notesOnStaff setValue:note forKey:NSStringFromCGPoint([touch locationInView:self.view])];
            
            
        }

        //everytime a new touch is added, we 
        
        
    }//for loop end
    
    notesSequence = [[notesSequence sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger x1 = [(NSValue*)obj1 CGPointValue].x;
        NSInteger x2 = [(NSValue*)obj2 CGPointValue].x;
        if (x1 > x2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (x1 < x2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
    
        return (NSComparisonResult)NSOrderedSame;
        
    }] mutableCopy];
    
    NSLog(@"before check!");
    NSLog(@"noteSequence = %@",notesSequence);
    NSLog(@"noteOnStaff = %@",notesOnStaff);
    
    [self checkForTrebleClef];
    
    
    NSLog(@"after check!");
    NSLog(@"noteSequence = %@",notesSequence);
    NSLog(@"noteOnStaff = %@",notesOnStaff);
    
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        //if there's someone moving, then we must had saved him in the the notesOnStaff so
        //finding the closest point should be a good solve.
        //we will also keep Treble Clef's points in "notesOnStaff" so we can keep track of it.
        NSString *key = [GECalculateHelper getClosestPointKey:[touch previousLocationInView:self.view] In:notesOnStaff];
        GENote *tempNote = [notesOnStaff objectForKey:key];
        
        if ([tempNote isTrebleClef]) {
            //if the one moved is treble clef.
            //update every notes' length.
            //update its value in self, in dic
            [tempNote setTouchPoint:[touch locationInView:self.view]];
            [notesOnStaff setValue:tempNote forKey:NSStringFromCGPoint([touch locationInView:self.view])];
            [notesOnStaff removeObjectForKey:key];
            
            [TrebleClef updateTrebleClefPointWithPoint:[touch locationInView:self.view]];
            [self updateNotesLengthWithPoint:TrebleClef.TBCenterPoint];
            
        }
        else{
            //when a note is moved, we update its instance Var "touchPoint", "noteType", "noteLength"
            [tempNote setTouchPoint:[touch locationInView:self.view]];
            [tempNote updateNoteType:[self getTouchedViewNoteTypeWithTouch:touch]];
            if (TrebleClef) {
                [tempNote updateNoteLengthWithTrebleClefCenter:TrebleClef.TBCenterPoint];
            }
            
            [notesOnStaff setValue:tempNote forKey:NSStringFromCGPoint([touch locationInView:self.view])];
            [notesOnStaff removeObjectForKey:key];
            NSValue *tempObj = [NSValue valueWithCGPoint:[GECalculateHelper getCGPointValueWithString:key]];
            NSValue *newObj = [NSValue valueWithCGPoint:[touch locationInView:self.view]];
            [notesSequence replaceObjectAtIndex:[notesSequence indexOfObject:tempObj] withObject:newObj];
            
            
        }
        
    }
    
    
    NSLog(@"moved!");
    NSLog(@"noteSequence = %@",notesSequence);
    NSLog(@"noteOnStaff = %@",notesOnStaff);
     
    
}

- (void)updateNotesLengthWithPoint:(CGPoint)TBCenter{
    
    for (id key in notesOnStaff) {
        GENote *note = [notesOnStaff objectForKey:key];
        if ([note isTrebleClef]) {
            //do nothing
        }
        else{
            [note updateNoteLengthWithTrebleClefCenter:TBCenter];
            [notesOnStaff setValue:note forKey:key];
        }
    }

}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        NSString *key = [GECalculateHelper getClosestPointKey:[touch previousLocationInView:self.view] In:notesOnStaff];
        [notesOnStaff removeObjectForKey:key];
        NSValue *tempObj = [NSValue valueWithCGPoint:[GECalculateHelper getCGPointValueWithString:key]];
        [notesSequence removeObject:tempObj];
        
    }
    
    
    NSLog(@"End!!");
    NSLog(@"noteSequence = %@",notesSequence);
    NSLog(@"noteOnStaff = %@",notesOnStaff);
     

}

//check for treble clef in notesOnStaff, if yes, remove the two points!!
- (void)checkForTrebleClef{
    
    if ([notesSequence count] <= 1) {
        return;
    }
    
    for (int i = 0; i < [notesSequence count]-1; ++i) {
        
        CGPoint point1 = [[notesSequence objectAtIndex:i]CGPointValue];
        CGPoint point2 = [[notesSequence objectAtIndex:i+1]CGPointValue];
        float dist = [GECalculateHelper getDistanceBetweenTwoPoint:point1 andPoint:point2];
        if ([GECalculateHelper isTheSameDistanceFor:dist andDistance:trebleClefDistance ByTolerating:15]) {
            
            //generate a GENote
            //remove both points from array, and set the GENote's member "isTrebleClef" to YES
            NSLog(@"treble clef generated");
            TrebleClef = [[GENote alloc]initTrebleClefWithTouchPoint:point1 AndTouchPoint:point2];
            
            [notesSequence removeObject:[notesSequence objectAtIndex:i+1]];
            [notesSequence removeObject:[notesSequence objectAtIndex:i]];
            
            //[notesOnStaff removeObjectForKey:NSStringFromCGPoint(point1)];
            //[notesOnStaff removeObjectForKey:NSStringFromCGPoint(point2)];
            GENote *note1 = [notesOnStaff objectForKey:NSStringFromCGPoint(point1)];
            GENote *note2 = [notesOnStaff objectForKey:NSStringFromCGPoint(point2)];
            [note1 setIsTrebleClef:YES];
            [note2 setIsTrebleClef:YES];
            [notesOnStaff setObject:note1 forKey:NSStringFromCGPoint(point1)];
            [notesOnStaff setObject:note2 forKey:NSStringFromCGPoint(point2)];
            
            //[notesOnStaff setValue:TrebleClef forKey:NSStringFromCGPoint(point1)];
            //[notesOnStaff setValue:TrebleClef forKey:NSStringFromCGPoint(point2)];
            
            return;
        }
        
    }
    
}


- (NSInteger)getTouchedViewNoteTypeWithTouch:(UITouch*)touch{
    
    for (UIView *view  in self.view.subviews) {
        if (CGRectContainsPoint(view.frame, [touch locationInView:self.view])) {
            return view.tag;
        }
    }
    
    return -1;
    
}

#pragma mark - button functions
//check the NSArray "answer" and "notesOnStaff" by keys in "notesSequence"
- (BOOL)submitAnswer:(id)sender{
    
    for (int i = 0; i < [answer count]; i++) {
        NSString *key = NSStringFromCGPoint([[notesSequence objectAtIndex:i] CGPointValue]);
        GENote *theNoteToBeComparedWithAnswer = [notesOnStaff objectForKey:key];
        
        if ([(GENote*)[answer objectAtIndex:i]noteType] != [theNoteToBeComparedWithAnswer noteType] || [(GENote*)[answer objectAtIndex:i]noteLength] != [theNoteToBeComparedWithAnswer noteLength]) {
            return NO;
        }
        
    }
    
    return YES;
    
}

- (void)backToRouletteView:(id)sender{
    
    
    
}

//play the 
- (void)playTheQuiz{
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
