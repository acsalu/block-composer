//
//  GEDragToPlayView.m
//  gene
//
//  Created by Acsa Lu on 12/10/12.
//  Copyright (c) 2012 An-Ruei-Che. All rights reserved.
//

#import "GEDragToPlayView.h"

@implementation GEDragToPlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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


#pragma - mark Touch Events Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"(%.2f, %.2f) in DragToPlayView", point.x, point.y);
    self.startX = @(point.x);
    [self.arrowView removeFromSuperview];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"(%.2f, %.2f) in DragToPlayView", point.x, point.y);
    self.endX = @(point.x);
    if (self.startX <= self.endX) {
        [self.arrowView removeFromSuperview];
        self.arrowView = [[UIView alloc] initWithFrame:CGRectMake([self.startX doubleValue], 50, [self.endX doubleValue] - [self.startX doubleValue], 20)];
        self.arrowView.backgroundColor = [UIColor orangeColor];
        
        [self addSubview:self.arrowView];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"(%.2f, %.2f) in DragToPlayView", point.x, point.y);
    self.endX = @(point.x);
    NSLog(@"from %.2f to %.2f", [self.startX doubleValue], [self.endX doubleValue]);
    [UIView animateWithDuration:1 animations:^{
        self.arrowView.alpha = 0;
    } completion:^(BOOL finished) {
        NSLog(@"done");
    }];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeArrowView) userInfo:nil repeats:NO];
    // call SoundManager
}

- (void)removeArrowView
{
    [self.arrowView removeFromSuperview];
}

@end
