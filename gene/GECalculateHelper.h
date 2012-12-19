//
//  GECalculateHelper.h
//  gene
//
//  Created by Wang Chi-An on 12/12/18.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GECalculateHelper : NSObject

+ (BOOL)isTheSamePointFor:(CGPoint)point1 andPoint:(CGPoint)point2 ByTolerating:(NSInteger)tolerableError;
+ (BOOL)isTheSameDistanceFor:(float)dist1 andDistance:(float)dist2 ByTolerating:(NSInteger)tolerableError;
+ (BOOL)isNotFarConsideringOneCoordinateWithPoint:(CGPoint)point1 andPoint:(CGPoint)point2 ByTolerating:(NSInteger)tolerableError;
+ (NSString*)getClosestPointKey:(CGPoint)point In:(NSMutableDictionary*)dic;

+ (CGPoint)getCGPointValueWithString:(NSString*)string;
+ (float)getDistanceBetweenTwoPoint:(CGPoint)point1 andPoint:(CGPoint)point2;

@end
