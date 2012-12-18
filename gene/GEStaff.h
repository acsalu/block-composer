//
//  GEStaff.h
//  gene
//
//  Created by Wang Chi-An on 12/12/18.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GENote.h"

@interface GEStaff : UIViewController{
    
    UILabel *testLabel;
    NSMutableDictionary *notesOnStaff;
    NSMutableArray *notesSequence;
    GENote *TrebleClef;
    
}

@end
