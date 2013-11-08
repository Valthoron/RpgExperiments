//
//  NSValue+Coordinate.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 03.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "NSValue+Coordinate.h"

@implementation NSValue (Coordinate)

+ (NSValue*)valueWithCoordinate:(Coordinate)coordinate
{
	return [NSValue valueWithBytes:&coordinate objCType:@encode(Coordinate)];
}

- (Coordinate)coordinateValue
{
	Coordinate coordinate;
    [self getValue:&coordinate];
    return coordinate;
}

@end
