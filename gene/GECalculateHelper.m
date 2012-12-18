//
//  GECalculateHelper.m
//  gene
//
//  Created by Wang Chi-An on 12/12/18.
//  Copyright (c) 2012年 An-Ruei-Che. All rights reserved.
//

#import "GECalculateHelper.h"
#import "GENote.h"

@implementation GECalculateHelper

+ (BOOL)isTheSamePointFor:(CGPoint)point1 andPoint:(CGPoint)point2 ByTolerating:(NSInteger)tolerableError{
    
    if ([self getDistanceBetweenTwoPoint:point1 andPoint:point2] < tolerableError) {
        return YES;
    }
    
    else return NO;
    
}

+ (BOOL)isTheSameDistanceFor:(float)dist1 andDistance:(float)dist2 ByTolerating:(NSInteger)tolerableError{
    
    if (fabsf(dist1 - dist2) < tolerableError) {
        return YES;
    }
    
    else return NO;
    
}

//for Treble Clef, only if two points have a close x value, could be treble clef,
//also trying to avoid someone placing the treble Clef casually...
+ (BOOL)isNotFarConsideringOneCoordinateWithPoint:(CGPoint)point1 andPoint:(CGPoint)point2 ByTolerating:(NSInteger)tolerableError{
    
    if (fabsf(point1.x - point2.x) < tolerableError) {
        return YES;
    }
    
    else return NO;
    
}

+ (NSString*)getClosestPointKey:(CGPoint)point In:(NSMutableDictionary *)dic{
    
    float shortestDistance = 9999;
    NSMutableString *shortestKey = [NSMutableString stringWithFormat:@""];
    
    for (id key in dic) {
        
        GENote *note = [dic objectForKey:key];
        float thisDistance = [self getDistanceBetweenTwoPoint:note.touchPoint andPoint:point];
        shortestDistance = MIN(shortestDistance, thisDistance);
        if (shortestDistance == thisDistance) {
            shortestKey = (NSMutableString*)key;
        }
    }
    
    return shortestKey;
}


//string format should be like -> {123, 222}
+ (CGPoint)getCGPointValueWithString:(NSString *)string{
    
    NSInteger x = [[string substringWithRange:NSMakeRange(1, [string rangeOfString:@","].location -1)]integerValue];
    NSInteger y = [[string substringWithRange:NSMakeRange([string rangeOfString:@" "].location+1, [string length]-[string rangeOfString:@" "].location - 2)]integerValue ];
    
    return CGPointMake(x, y);
    
}

+ (float)getDistanceBetweenTwoPoint:(CGPoint)point1 andPoint:(CGPoint)point2{
    
    float xDist = (point1.x - point2.x);
    float yDist = (point1.y - point2.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
    
}


@end
