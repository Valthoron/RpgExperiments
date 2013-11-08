//
//  SeededRandomGenerator.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeededRandomGenerator : NSObject
{
	unsigned int MT[624];
	unsigned int index;
}

- (id)initWithSeed:(unsigned int)seed;
- (unsigned int)nextInt;
- (unsigned int)nextUniformIntWithUpperBound:(unsigned int)upperBound;
- (unsigned int)nextUniformIntWithUpperBound:(unsigned int)upperBound andLowerBound:(unsigned int)lowerBound;
- (float)nextFloat;

@end
