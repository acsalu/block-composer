//
//  GEStaff.m
//  gene
//
//  Created by Wang Chi-An on 12/12/18.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import "GEStaff.h"
#import "GECalculateHelper.h"

@interface GEStaff ()

@end

@implementation GEStaff

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
    [self drawStaffWithPoint:CGPointMake(15, 30)];
    
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
        [white setBackgroundColor:[UIColor whiteColor]];
        [white setTag:i*2];
        y += whiteHeight;
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, lineHeight)];
        if (i == 1 || i == 7) {
            [line setBackgroundColor:[UIColor whiteColor]];
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
    
    /*
    NSLog(@"start!");
    NSLog(@"noteSequence = %@",notesSequence);
    NSLog(@"noteOnStaff = %@",notesOnStaff);
    */
    
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        //if there's someone moving, then we must had saved him in the the notesOnStaff so
        //finding the closest point should be a good solve.
        NSString *key = [GECalculateHelper getClosestPointKey:[touch previousLocationInView:self.view] In:notesOnStaff];
        GENote *tempNote = [notesOnStaff objectForKey:key];
        [tempNote setTouchPoint:[touch locationInView:self.view]];
        [notesOnStaff setValue:tempNote forKey:NSStringFromCGPoint([touch locationInView:self.view])];
        [notesOnStaff removeObjectForKey:key];
        NSValue *tempObj = [NSValue valueWithCGPoint:[GECalculateHelper getCGPointValueWithString:key]];
        NSValue *newObj = [NSValue valueWithCGPoint:[touch locationInView:self.view]];
        [notesSequence replaceObjectAtIndex:[notesSequence indexOfObject:tempObj] withObject:newObj];
        
    }
    
    /*
    NSLog(@"moved!");
    NSLog(@"noteSequence = %@",notesSequence);
    NSLog(@"noteOnStaff = %@",notesOnStaff);
     */
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        NSString *key = [GECalculateHelper getClosestPointKey:[touch previousLocationInView:self.view] In:notesOnStaff];
        [notesOnStaff removeObjectForKey:key];
        NSValue *tempObj = [NSValue valueWithCGPoint:[GECalculateHelper getCGPointValueWithString:key]];
        [notesSequence removeObject:tempObj];
        
    }
    
    /*
    NSLog(@"End!!");
    NSLog(@"noteSequence = %@",notesSequence);
    NSLog(@"noteOnStaff = %@",notesOnStaff);
     */

}

//check for treble clef in notesOnStaff, if yes, remove the two points!!
- (void)checkForTrebleClef{
    
    
    
}

- (NSInteger)getTouchedViewNoteTypeWithTouch:(UITouch*)touch{
    
    for (UIView *view  in self.view.subviews) {
        if (CGRectContainsPoint(view.frame, [touch locationInView:self.view])) {
            return view.tag;
        }
    }
    
    return -1;
    
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
