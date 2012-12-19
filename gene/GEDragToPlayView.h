//
//  GEDragToPlayView.h
//  gene
//
//  Created by Acsa Lu on 12/10/12.
//  Copyright (c) 2012 An-Ruei-Che. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GEDragToPlayView : UIView 

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSMutableArray *notesSequence;

@property (nonatomic, strong) NSNumber *startX;
@property (nonatomic, strong) NSNumber *endX;
@property (nonatomic, strong) UIView *arrowView;

@end
