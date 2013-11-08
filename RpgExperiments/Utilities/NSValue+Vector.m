//
//  NSValue+Vector.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 03.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "NSValue+Vector.h"

@implementation NSValue (Vector)

+ (NSValue*)valueWithVector:(Vector)vector
{
	return [NSValue valueWithBytes:&vector objCType:@encode(Vector)];
}

- (Vector)vectorValue
{
	Vector vector;
    [self getValue:&vector];
    return vector;
}

@end
