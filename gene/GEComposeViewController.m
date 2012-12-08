//
//  GEComposeViewController.m
//  gene
//
//  Created by Acsa Lu on 12/8/12.
//  Copyright (c) 2012 An-Ruei-Che. All rights reserved.
//

#import "GEComposeViewController.h"



@interface GEComposeViewController ()

@end

@implementation GEComposeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma - mark Touch Event Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    self.touchPointLabel.text = [NSString stringWithFormat:@"(%.1f, %.1f)", point.x, point.y];

    NSString *note = @"";
    if (point.y > 226 - 13.5 && point.y < 226 + 13.5) {
        note = @"FA";
    } else if (point.y > 226 + 13.5 && point.y < 280 - 13.5) {
        note = @"MI";
    } else if (point.y > 280 - 13.5 && point.y < 280 + 13.5) {
        note = @"RE";
    } else if (point.y > 280 + 13.5 && point.y < 334 - 13.5) {
        note = @"DO";
    }
    self.noteLabel.text = [@"Play " stringByAppendingString:note];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    self.touchPointLabel.text = [NSString stringWithFormat:@"(%.1f, %.1f)", point.x, point.y];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    self.touchPointLabel.text = [NSString stringWithFormat:@"(%.1f, %.1f)", point.x, point.y];
}










@end
