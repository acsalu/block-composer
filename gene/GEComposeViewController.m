//
//  GEComposeViewController.m
//  gene
//
//  Created by Acsa Lu on 12/8/12.
//  Copyright (c) 2012 An-Ruei-Che. All rights reserved.
//

#import "GEComposeViewController.h"
#import "GEStaff.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

typedef enum {
    GEGameStateChoose = 0,
    GEGameStatePlay = 1
} GameState;


@interface GEComposeViewController ()

@property (strong, nonatomic) AVAudioPlayer *player;
@property (nonatomic) NSUInteger state;
@property (nonatomic) float rotateDuration;
@property (nonatomic) BOOL isRotating;
@property (strong, nonatomic) UISwipeGestureRecognizer *onSwipeDown;

@property (nonatomic) NSUInteger rotateNum;
@property (nonatomic) NSUInteger rotateCount;

@property (nonatomic, strong) NSArray *songs;
@property (nonatomic, strong) NSDictionary *songChosen;

- (void)showChooseView;
- (void)rotateWithOptions: (UIViewAnimationOptions)options;
- (void)startRotate;
- (void)stopRotate;
- (void)blinkArrow;

@end

@implementation GEComposeViewController

@synthesize allNotesArray;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        _player = [[AVAudioPlayer alloc] init];
        _state = GEGameStateChoose;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"songs" ofType:@"plist"];
        _songs = [NSArray arrayWithContentsOfFile:path];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.onSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(startRotate)];
    self.onSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.backgroundView addGestureRecognizer:self.onSwipeDown];
    [self showChooseView];
}

- (void)showChooseView
{
    self.rouletteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roulette.png"]];
    CGRect frame = self.rouletteView.frame;
    self.rouletteView.frame = CGRectMake(160, 80, frame.size.width, frame.size.width);
    self.rouletteView.layer.shadowColor = [UIColor purpleColor].CGColor;
    self.rouletteView.layer.shadowOffset = CGSizeMake(1, 1);
    self.rouletteView.layer.shadowOpacity = 1;
    self.rouletteView.layer.shadowRadius = 5.0;
    self.rouletteView.clipsToBounds = NO;

    [self.view addSubview:self.rouletteView];
    
    UIImageView *indexView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index.png"]];
    frame = indexView.frame;
    indexView.frame = CGRectMake(620, 120, frame.size.width, frame.size.height);
    [self.view addSubview:indexView];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    frame = self.arrowView.frame;
    self.arrowView.frame = CGRectMake(800, 160, frame.size.width, frame.size.height);
    [self.view addSubview:self.arrowView];
    [self blinkArrow];
    
}

- (void)rotateWithOptions:(UIViewAnimationOptions)options
{
    
    static int count = 0;
    NSLog(@"count %d", count++);
    float duration = 0.1f;
    if (self.rotateCount >= self.rotateNum - 6) duration = 0.12f;
    if (self.rotateCount >= self.rotateNum - 4) duration = 0.14f;
    if (self.rotateCount >= self.rotateNum - 2) duration = 0.16f;
    if (self.rotateCount == self.rotateNum - 1) duration = 0.2f;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:options
                     animations:^{
                         self.rouletteView.transform = CGAffineTransformRotate(self.rouletteView.transform, (DEGREES_TO_RADIANS(45.0f)));
                     } completion:^(BOOL finished) {
                         if (finished) {
                             if (self.isRotating) {
                                 // if flag still set, keep spinning with constant speed
                                 NSLog(@"rotateCount %d", self.rotateCount);
                                 
                                 
                                 if (self.rotateCount++ == self.rotateNum) {
                                     self.isRotating = NO;
                                     [self performSelector:@selector(stopRotate) withObject:nil afterDelay:1.0];
                                 }
                                 else [self rotateWithOptions: UIViewAnimationOptionCurveLinear];
                             }
                             else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self rotateWithOptions: UIViewAnimationOptionCurveEaseOut];
                             } else {
                                 [self performSelector:@selector(stopRotate) withObject:nil afterDelay:1.0];
                             }
                         }
                     }];
}

- (void)startRotate
{
    self.arrowView.hidden = YES;
    NSLog(@"Swipe down gesture detected!");
    self.isRotating = YES;
    
    //self.rotateCount = (self.rotateNum)% self.songs.count + 1;
    //self.rotateNum = (arc4random() % 5 + 3) * 4 + arc4random() % 4;
    self.rotateCount = 1;
    self.rotateNum = 28;
    self.songChosen = (NSDictionary *) self.songs[(self.rotateNum)% self.songs.count];
    NSLog(@"rotateNum = %d", self.rotateNum);
    NSLog(@"songChosen = %@", [self.songChosen objectForKey:@"name"]);
    [self rotateWithOptions:UIViewAnimationOptionCurveEaseIn];

}

- (void)stopRotate
{
    [UIView animateWithDuration:1.0f
                          delay:1.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //self.rouletteView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         //[self.rouletteView removeFromSuperview];
                         //[self.view removeGestureRecognizer:self.onSwipeDown];
                         GEStaff *staffViewController = [[GEStaff alloc] init];
                         staffViewController.view.alpha = 0.2f;
                         staffViewController.answer = [self.songChosen objectForKey:@"melody"];
                         staffViewController.songName = (NSString*)[self.songChosen objectForKey:@"name"];
                         
                         [self.navigationController presentModalViewController:staffViewController animated:NO];
                            staffViewController.songName = [self.songChosen objectForKey:@"name"];
                         [UIView beginAnimations:nil context:nil];
                            staffViewController.view.alpha = 1.0f;
                            [staffViewController setSongNameLabelWithText:[self.songChosen objectForKey:@"name"]];
                         [UIView commitAnimations];
                     }];
}

- (void)blinkArrow
{
    [UIView animateWithDuration:0.01f
                          delay:0.5f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.arrowView.alpha = (self.arrowView.alpha == 0.0f) ? 1.0f : 0.0f;
                     } completion:^(BOOL finished) {
                         [self blinkArrow];
                     }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    
}

@end
