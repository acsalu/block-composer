//
//  GEStaff.m
//  gene
//
//  Created by Wang Chi-An on 12/12/18.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import "GEStaff.h"
#import "GECalculateHelper.h"
#import "QuartzCore/QuartzCore.h"
#import "GESoundManager.h"
#import "SCWaveAnimationView.h"

// declare in GENote.h
// const float trebleClefDistance = 80;
@interface GEStaff ()

- (void)animateFinger;

@end

@implementation GEStaff

@synthesize answer;
@synthesize notesSequence;
@synthesize songName;

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
    [backGroundImage setImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:backGroundImage];
    
    // finger cue
    self.fingerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finger.png"]];
    self.fingerView.frame = CGRectMake(15, 515, 100, 100);
    [self.view addSubview:self.fingerView];
    [self animateFinger];
    
    
    
    //also draw fake Treble Clef
    [self drawStaffWithPoint:CGPointMake(15, 30)];
    
    notesOnStaff = [[NSMutableDictionary alloc]init];
    notesSequence = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 7; i++) {
        [notesSequence addObject:[NSNull null]];
    }
    GEDragToPlayView *drag = [[GEDragToPlayView alloc]initWithFrame:CGRectMake(10, 510, 950, 200)];
    
    drag.notesSequence = notesSequence;
    [self.view addSubview:drag];
    
    UIButton *backToRoulette = [[UIButton alloc]initWithFrame:CGRectMake(5, 608, 130, 160)];
    [backToRoulette setBackgroundImage:[UIImage imageNamed:@"back_button_3d.png"] forState:UIControlStateNormal];
    [backToRoulette setBackgroundImage:[UIImage imageNamed:@"back_button_3d_press-2.png"] forState:UIControlStateHighlighted];
    [backToRoulette addTarget:self action:@selector(backToRouletteView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToRoulette];
    
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(836, 605, 130, 160)];
    [submitButton setImage:[UIImage imageNamed:@"submit_button_3d.png"] forState:UIControlStateNormal];
    [submitButton setImage:[UIImage imageNamed:@"submit_button_3d_press.png"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(submitAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    UIButton *playButton = [[UIButton alloc]initWithFrame:CGRectMake(686, 605, 130, 160)];
    [playButton setImage:[UIImage imageNamed:@"play_button_3d.png"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"play_button_3d_press.png"] forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(playTheQuiz) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    songNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(320, 605, 310, 160)];
    [songNameLabel setText:self.songName];
    NSLog(@"song Chosen = %@",self.songName);
    
    [songNameLabel setFont:[UIFont systemFontOfSize:40]];
    [songNameLabel setTextColor:[UIColor blackColor]];
    [songNameLabel setBackgroundColor:[UIColor clearColor]];
    [songNameLabel setTextAlignment:NSTextAlignmentCenter];
    [songNameLabel.layer setBorderColor:[UIColor blackColor].CGColor];
    [songNameLabel.layer setBorderWidth:5];
    [self.view addSubview:songNameLabel];
    
    //a block is 120 * 320 !!
    /*
    UIButton *testBUtton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 120, 320)];
    [testBUtton setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:testBUtton];
    */
    
    //tuneValue = [[NSMutableArray alloc]init];
    
    [self drawSevenRanges];
    
}

- (void) setSongNameLabelWithText:(NSString *)name{
    
    [songNameLabel setText:name];
    
}

- (void)drawSevenRanges{
    
    NSInteger width = 123;
    NSInteger xRef = 100;
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 7; i++) {
        UIImageView *room = [[UIImageView alloc]initWithFrame:CGRectMake(xRef, 20, width, 500)];
        [room setTag:i + 100];
        [room setImage:[UIImage imageNamed:@"dash.png"]];
        [room setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:room];
        xRef += width;
        [temp addObject:room];
    }
    
    roomArray = [[NSArray alloc]initWithArray:[temp copy]];
    
}


- (void)drawStaffWithPoint:(CGPoint)point{
    
    NSInteger x = point.x;
    NSInteger y = point.y;
    NSInteger lineHeight = 22;
    NSInteger whiteHeight = 25;
    //specify the width in here XDD sorry
    NSInteger width = 950;
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    
    for (int i = 7; i > 0; --i) {
        
        UIView *white = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, whiteHeight)];
        [white setBackgroundColor:[UIColor clearColor]];
        [white setTag:i * 2];
        y += whiteHeight;
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, lineHeight)];
        if (i == 1 || i == 7) {
            [line setBackgroundColor:[UIColor clearColor]];
        }
        else{
            [line setImage:[UIImage imageNamed:@"staff_line.png"]];
        }
        [line setTag:i * 2 - 1];
        y += lineHeight;
        [self.view addSubview:white];
        [self.view addSubview:line];
        
        [temp addObject:white];
        [temp addObject:line];
    }
    
    for (int j = 7; j > 0; --j) {
        
        if (j%2 == 1) {
            //奇數
            UIView *white = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, whiteHeight)];
            [white setBackgroundColor:[UIColor clearColor]];
            [white setTag:14 + j ];
            [self.view addSubview:white];
            y += whiteHeight;
            [temp addObject:white];
        }
        else{
            //偶數
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, lineHeight)];
            [line setBackgroundColor:[UIColor clearColor]];
            [line setTag:j+14];
            [self.view addSubview:line];
            y += lineHeight;
            [temp addObject:line];
    
        }
    }

    UIImageView *trebleClefImage = [[UIImageView alloc]initWithFrame:CGRectMake(-30, -20, 158, 400)];
    [trebleClefImage setImage:[UIImage imageNamed:@"Treble_Clef.png"]];
    [self.view addSubview:trebleClefImage];
    staffViewArray = [[NSArray alloc]initWithArray:[temp copy]];
    NSLog(@"y = %d",y);
}

#pragma mark - touches related functions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        
        NSInteger roomNumber = [self getRoomNumberWithPoint:[touch locationInView:self.view]] - 100;
        if (roomNumber > 6 || roomNumber < 0) {
            return;
        }
        
        GENote *note = [[GENote alloc]initWithTouchPoint:[touch locationInView:self.view] NoteType:[self getTouchedViewNoteTypeWithTouch:touch]];
        //[self getRoomNumberWithTouch:touch];
        [note setNoteLength:[self getNoteLengthWithTouch:touch]];
        [notesSequence replaceObjectAtIndex:[self getRoomNumberWithPoint:[touch locationInView:self.view]]-100 withObject:note];
        
        [[GESoundManager soleSoundManager] playAnswerOrSingleNote:note.description instrument:GESoundMgrPiano];
        
        NSLog(@"noteType = %d",[self getTouchedViewNoteTypeWithTouch:touch]);
        NSLog(@"noteLength = %d",[self getNoteLengthWithTouch:touch]);
        
        [SCWaveAnimationView waveAnimationAtPosition:[touch locationInView:self.view] forView:self.view];
        
    }
    
    NSLog(@"notesSequence = %@",notesSequence);
    
    
    /*
    if ([tuneValue count]>50) {
        NSLog(@"x mean = %f", [self meanOf:[tuneValue copy]].floatValue);
        NSLog(@"x std = %f", [self standardDeviationOf:[tuneValue copy]].floatValue);
    }
    */
    
}

- (NSNumber *)meanOf:(NSArray *)array
{
    double runningTotal = 0.0;
    
    for(NSNumber *number in array)
    {
        runningTotal += [number doubleValue];
    }
    
    return [NSNumber numberWithDouble:(runningTotal / [array count])];
}

- (NSNumber *)standardDeviationOf:(NSArray *)array
{
    if(![array count]) return nil;
    
    double mean = [[self meanOf:array] doubleValue];
    double sumOfSquaredDifferences = 0.0;
    
    for(NSNumber *number in array)
    {
        double valueOfNumber = [number doubleValue];
        double difference = valueOfNumber - mean;
        sumOfSquaredDifferences += difference * difference;
    }
    
    return [NSNumber numberWithDouble:sqrt(sumOfSquaredDifferences / [array count])];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch* touch in touches) {
        
        //if moved out of 7 rooms, delete previous one.
        NSInteger roomNumber = [self getRoomNumberWithPoint:[touch locationInView:self.view]]-100;
        NSInteger previousRoomNumber = [self getRoomNumberWithPoint:[touch previousLocationInView:self.view]]-100;
        
        if ( [self getRoomNumberWithPoint:[touch locationInView:self.view]] != [self getRoomNumberWithPoint:[touch previousLocationInView:self.view]] && previousRoomNumber >= 0 && previousRoomNumber < 7) {
            //remove previous room
            [notesSequence replaceObjectAtIndex:previousRoomNumber withObject:[NSNull null]];
        }
        //if new room number is not defined then do nothing.
        if (roomNumber > 6 || roomNumber < 0) {
            return;
        }
       
        
        GENote *note = [[GENote alloc]initWithTouchPoint:[touch locationInView:self.view] NoteType:[self    getTouchedViewNoteTypeWithTouch:touch]];
        [note setNoteLength:[self getNoteLengthWithTouch:touch]];
        [notesSequence replaceObjectAtIndex:roomNumber withObject:note];
    
        
    }
    
    
}

/*
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
    
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:2.0f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setType:@"rippleEffect" ];
    [self.view.layer addAnimation:animation forKey:NULL];
    
    
}
*/
/*
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
            //[self updateNotesLengthWithPoint:TrebleClef.TBCenterPoint];
            
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
*/
//add this function before drag to play and before submit.
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

- (void)updateNotesLengthEverySecond{
    
    //NSLog(@"in updateNotesLengthEverySecond");
    
    if (TrebleClef == nil) {
        return;
    }
    NSDictionary *tempCompareUse = [notesOnStaff copy];
    
    for (id key in tempCompareUse) {
        GENote *note = [tempCompareUse objectForKey:key];
        if ([note isTrebleClef]) {
            //do nothing
        }
        else{
            [note updateNoteLengthWithTrebleClefCenter:[TrebleClef TBCenterPoint]];
            [notesOnStaff setValue:note forKey:key];
        }
    }
    
    
}

/*
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
*/
//check for treble clef in notesOnStaff, if yes, remove the two points!!
- (void)checkForTrebleClef{
    
    if ([notesSequence count] <= 1) {
        return;
    }
    
    for (int i = 0; i < [notesSequence count]-1; ++i) {
        
        CGPoint point1 = [[notesSequence objectAtIndex:i]CGPointValue];
        CGPoint point2 = [[notesSequence objectAtIndex:i+1]CGPointValue];
        float dist = [GECalculateHelper getDistanceBetweenTwoPoint:point1 andPoint:point2];
        
        if ([GECalculateHelper isTheSameDistanceFor:dist andDistance:trebleClefDistance ByTolerating:10]) {
            
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
    
    for (UIView *view  in staffViewArray) {
        
        if (CGRectContainsPoint(view.frame, [touch locationInView:self.view])) {
            return view.tag;
        }
    }
    
    return -1;
    
}

//
- (NSInteger)getRoomNumberWithPoint:(CGPoint)point{
    
    for (UIImageView *room in roomArray) {
        if ( CGRectContainsPoint(room.frame, point)) {
            return room.tag;
        }
    }
    
    return -1;
    
}

- (NSInteger)getNoteLengthWithTouch:(UITouch*)touch{
    
    //NSInteger tempDif = 6;
    
    for (UIImageView *room in roomArray) {
        
        if ( CGRectContainsPoint(room.frame, [touch locationInView:self.view])) {
            
            NSLog(@"location in roomView = %@",NSStringFromCGPoint([touch locationInView:room]));
            
            //[tuneValue addObject:[NSNumber numberWithInteger:[touch locationInView:room].x]];
            
            if([touch locationInView:room].x < 35.27){
                
                return quarterRest;
                //休止符
                
            }
            else if([touch locationInView:room].x <54.22){
                
                return halfNote;
                
            }
            else if([touch locationInView:room].x <77.54){
                
                return quarterNote;
                
            }
            else{
                
                return quarterNote;
                
            }
            
        }
    }
    
    return -1;
    
}
    



#pragma mark - button functions
//check the NSArray "answer" and "notesOnStaff" by keys in "notesSequence"
- (void)submitAnswer:(id)sender{
    
    if ([GESoundManager verifyAnswerWithAnswerArray:answer andUserArray:[notesSequence copy]]) {
        //present success VC!!
        UIButton *successGrayButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [successGrayButton setBackgroundColor:[UIColor colorWithRed:90.0/255.0 green:95.0/255.0 blue:97.0/255.0 alpha:0.8]];
        [successGrayButton addTarget:self action:@selector(removeSuccessView:) forControlEvents:UIControlEventTouchUpInside];
        [successGrayButton setAlpha:0];
        [self.view addSubview:successGrayButton];
        
        UIImageView *successImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 650, 650)];
        [successImage setImage:[UIImage imageNamed:@"success.png"]];
        [successImage setCenter:successGrayButton.center];
        [successGrayButton addSubview:successImage];
        
        [UIView animateWithDuration:1.1 animations:^{
            [successGrayButton setAlpha:1];
        }];
        
        
    }
    else{
        //add failed view.
        UIButton *failGrayButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [failGrayButton setBackgroundColor:[UIColor colorWithRed:90.0/255.0 green:95.0/255.0 blue:97.0/255.0 alpha:0.8]];
        [failGrayButton addTarget:self action:@selector(removeFailedView:) forControlEvents:UIControlEventTouchUpInside];
        [failGrayButton setAlpha:0];
        [self.view addSubview:failGrayButton];
        
        UIImageView *failedImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 650, 650)];
        [failedImage setImage:[UIImage imageNamed:@"failed_view.png"]];
        [failedImage setCenter:failGrayButton.center];
        [failGrayButton addSubview:failedImage];
        
        [UIView animateWithDuration:1.1 animations:^{
            [failGrayButton setAlpha:1];
        }];
        
    }
}

- (void)removeFailedView:(UIButton*)sender{
    
    /*
    if ([[sender subviews]count]!=0) {
        for (UIView *subview in [sender subviews]) {
            [subview removeFromSuperview];
        }
    }
    */
    [UIView animateWithDuration:1.1 animations:^{
        [sender setAlpha:0];
    } completion:^(BOOL finished) {
        [sender removeFromSuperview];
    }];
    
}

- (void)removeSuccessView:(UIButton*)sender{
 
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)backToRouletteView:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)playTheQuiz{
    
    [[GESoundManager soleSoundManager] playAnswerOrSingleNote:songName instrument:GESoundMgrPiano];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark animations

- (void)animateFinger
{
    [UIView animateWithDuration:2.0f
                          delay:1.0f
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.fingerView.center = CGPointMake(205, 565);
                     } completion:^(BOOL finished){
                         self.fingerView.center = CGPointMake(65, 565);
                         [UIView animateWithDuration:0.5f
                                          animations:^{
                                              self.fingerView.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              self.fingerView.alpha = 1.0;
                                          }];
                     }];
}

@end
