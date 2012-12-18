//
//  GEComposeViewController.m
//  gene
//
//  Created by Acsa Lu on 12/8/12.
//  Copyright (c) 2012 An-Ruei-Che. All rights reserved.
//

#import "GEComposeViewController.h"

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
    
    self.onSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(startRotate)];
    self.onSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:self.onSwipeDown];
    
    
	// Do any additional setup after loading the view.
<<<<<<< HEAD
    
    UIButton *redirect = [[UIButton alloc]
                          initWithFrame:CGRectMake(10, 10, 100, 100)];

    [redirect setBackgroundColor:[UIColor redColor]];



=======
    switch (self.state) {
        case GEGameStateChoose:
            [self showChooseView];
            break;
        case GEGameStatePlay:
            break;
        default:
            break;
    }
>>>>>>> 431fa88258d6bfdcab3607d90122f0b2c8e49775
}

- (void)openStaff{
    
    
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
    } else if (point.y > 334 - 13.5 && point.y > 334 + 13.5) {
        note = @"SI";   
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
    float duration = (options == UIViewAnimationOptionCurveEaseOut) ? 0.3f : 0.1f;
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
                     }];
}


@end
