//
//  GEDragToPlayView.m
//  gene
//
//  Created by Acsa Lu on 12/10/12.
//  Copyright (c) 2012 An-Ruei-Che. All rights reserved.
//

#import "GEDragToPlayView.h"
#import "GENote.h"
#import "GESoundManager.h"
#import "GEStaff.h"

@implementation GEDragToPlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pointArray = [NSMutableArray arrayWithCapacity:7];
        _signalArray = [NSMutableArray arrayWithCapacity:7];
        float width = 123.0;
        float offset = 90.0;
        for (NSUInteger i = 0; i < 7; ++i) {
            UIImageView *point = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point.png"]];
            point.center = CGPointMake(offset + width * (i + 0.5), 20);
            //point.alpha = 0.40f;
            
            UIView *signal = [[UIView alloc] initWithFrame:CGRectMake(offset + width * (i + 0.5) - 10, 8, 20, 20)];
            signal.backgroundColor = [UIColor redColor];
            
            [self addSubview:signal];
            [self addSubview:point];
            _pointArray[i] = point;
            _signalArray[i] = signal;
        }
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - 
#pragma mark Touch Events Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[GESoundManager soleSoundManager] playing]) {
        return;
    }
    
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"(%.2f, %.2f) in DragToPlayView", point.x, point.y);
    self.startX = @(point.x);
    [self.arrowView removeFromSuperview];
    
    self.arrowView = [[UIView alloc] initWithFrame:CGRectMake([self.startX doubleValue], 50, 1, 20)];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[GESoundManager soleSoundManager] playing]) {
        return;
    }
    
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"(%.2f, %.2f) in DragToPlayView", point.x, point.y);
    self.endX = @(point.x);
    if ([self.startX doubleValue] <= [self.endX doubleValue]) {
        [self.arrowView setFrame:CGRectMake([self.startX doubleValue], 50,
                                            [self.endX doubleValue] - [self.startX doubleValue], 20)];
        self.arrowView.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.arrowView];
    }
    
    self.startRoom = ([self.startX doubleValue] - 100) / 123;
    self.endRoom = ([self.endX doubleValue] - 100) / 123;
    if (self.endRoom > 6) self.endRoom = 6;
    
    for (NSUInteger i = self.startRoom; i <= self.endRoom; ++i)
        ((UIView *) self.signalArray[i]).backgroundColor = [UIColor greenColor];
    
    for (NSUInteger i = 0; i < self.startRoom; ++i)
        ((UIView *) self.signalArray[i]).backgroundColor = [UIColor redColor];
    
    for (NSUInteger i = self.endRoom + 1; i < 7; ++i)
        ((UIView *) self.signalArray[i]).backgroundColor = [UIColor redColor];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[GESoundManager soleSoundManager] playing]) {
        return;
    }
    
    if ([self.startX doubleValue] > [self.endX doubleValue]) {
        return;
    }
    
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"(%.2f, %.2f) in DragToPlayView", point.x, point.y);
    self.endX = @(point.x);
    NSLog(@"from %.2f to %.2f", [self.startX doubleValue], [self.endX doubleValue]);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"songs" ofType:@"plist"];
    NSArray *songs = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"melody: %@", songs[0][@"melody"]);
    
    // initial x:100 + 123 * (# of room)
    self.startRoom = ([self.startX doubleValue] - 100) / 123;
    self.endRoom = ([self.endX doubleValue] - 100) / 123;
    if (self.endRoom > 6) { self.endRoom = 6; }
    self.playRoomsArray = [NSMutableArray arrayWithCapacity:7];
    
    NSLog(@"in DragToPlay noteSequence:%@", self.notesSequence);
    for (NSUInteger i = self.startRoom; i <= self.self.endRoom; ++i) {
        id objInNotesSequence = [self.notesSequence objectAtIndex:i];
        NSString *noteStr;
        if ([objInNotesSequence isEqual:[NSNull null]]) {
            noteStr = @"rest_4";
        } else {
            noteStr = [objInNotesSequence description];
        }
        [self.playRoomsArray addObject:noteStr];
    }
    
    [[GESoundManager soleSoundManager] playSynthesizedNoteArray:self.playRoomsArray instrument:GESoundMgrPiano];
    self.targetIndex = 0;
    [self performSelector:@selector(revertSignals) withObject:nil afterDelay:0.0f];
    
    [UIView animateWithDuration:1 animations:^{
        self.arrowView.alpha = 0;
    } completion:^(BOOL finished) {
        NSLog(@"done");
        [self.arrowView removeFromSuperview];
        
    }];
}

- (void)revertSignals {
    NSLog(@"target %d, count %d", self.targetIndex, self.playRoomsArray.count);
    if (self.playRoomsArray.count == 0) return;
    NSString *note = (NSString *) self.playRoomsArray[0];
    float delay = (1.0f / [[note substringFromIndex:[note length] - 1] intValue]);
    NSLog(@"delay: %f", delay);
    [self.playRoomsArray removeObjectAtIndex:0];
    [self performSelector:@selector(revertSignalForIndex:) withObject:@((self.targetIndex++) + self.startRoom) afterDelay:delay];
    [self performSelector:@selector(revertSignals) withObject:nil afterDelay:delay - 0.04f];
}

- (void)revertSignalForIndex:(NSNumber *)index
{
    [UIView animateWithDuration:0.1f animations:^{
        ((UIView *) self.signalArray[[index integerValue]]).backgroundColor = [UIColor redColor];
    }];
}

@end
