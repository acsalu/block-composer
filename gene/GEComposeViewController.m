//
//  GEComposeViewController.m
//  gene
//
//  Created by Acsa Lu on 12/8/12.
//  Copyright (c) 2012 An-Ruei-Che. All rights reserved.
//

#import "GEComposeViewController.h"
#import "GEStaff.h"

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


@end

@implementation GEComposeViewController

@synthesize allNotesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _player = [[AVAudioPlayer alloc] init];
        _state = GEGameStateChoose;
    }
    return self;
}

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

- (void)openStaff{
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark -
# pragma mark View Handling

- (void)showChooseView
{
    self.rouletteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roulette.png"]];
    CGRect frame = self.rouletteView.frame;
    self.rouletteView.frame = CGRectMake(252, 100, frame.size.width, frame.size.width);
    [self.view addSubview:self.rouletteView];
    //[self rotateWithOptions:UIViewAnimationOptionCurveEaseIn];
}

- (void)rotateWithOptions:(UIViewAnimationOptions)options
{
    float duration = (options == UIViewAnimationOptionCurveEaseOut) ? 0.5f : 0.1f;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:options
                     animations:^{
                         self.rouletteView.transform = CGAffineTransformRotate(self.rouletteView.transform, M_PI / 4);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             if (self.isRotating) {
                                 // if flag still set, keep spinning with constant speed
                                 if (self.rotateCount++ == self.rotateNum) self.isRotating = NO;
                                 [self rotateWithOptions: UIViewAnimationOptionCurveLinear];
                             }
                             else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self rotateWithOptions: UIViewAnimationOptionCurveEaseOut];
                             } else {
                                 [self stopRotate];
                             }
                         }
                     }];
}

- (void)startRotate
{
    NSLog(@"Swipe down gesture detected!");
    self.isRotating = YES;
    self.rotateCount = 0;
    self.rotateNum = (arc4random() % 5 + 3) * 4 + arc4random() % 4;
    self.songChosen = (NSDictionary *) self.songs[self.rotateNum % self.songs.count];
    NSLog(@"rotateNum = %d", self.rotateNum);
    NSLog(@"songChosen = %@", [self.songChosen objectForKey:@"name"]);
    [self rotateWithOptions:UIViewAnimationOptionCurveEaseIn];
    

}

- (void)stopRotate
{
    [UIView animateWithDuration:1.0f
                          delay:0.5f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.rouletteView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self.rouletteView removeFromSuperview];
                         [self.view removeGestureRecognizer:self.onSwipeDown];
                         GEStaff *staffViewController = [[GEStaff alloc] init];
                         staffViewController.view.alpha = 0.2f;
                         staffViewController.answer = @[];
//                         UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
//                         [UIView beginAnimations: nil context: nil];
//                         [UIView setAnimationTransition: trans forView:self.view.window cache: YES];
//                         [self.navigationController presentModalViewController:staffViewController animated: NO];
//                         [UIView commitAnimations];
                         
                         [self.navigationController presentModalViewController:staffViewController animated:NO];
                         [UIView beginAnimations:nil context:nil];
                         staffViewController.view.alpha = 1.0f;
                         [UIView commitAnimations];
                     }];
}


- (void)viewDidUnload {
    [self setBackgroundView:nil];
    [super viewDidUnload];
}
@end
