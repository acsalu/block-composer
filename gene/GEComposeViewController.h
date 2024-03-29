//
//  GEComposeViewController.h
//  gene
//
//  Created by Acsa Lu on 12/8/12.
//  Copyright (c) 2012 An-Ruei-Che. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GEComposeViewController : UIViewController

//an array used to save all the notes on iPad
//its content should be GENote.


@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;

@property (strong, nonatomic)NSMutableArray *allNotesArray;

@property (strong, nonatomic) UIImageView *rouletteView;
@property (strong, nonatomic) UIImageView *arrowView;

@end
