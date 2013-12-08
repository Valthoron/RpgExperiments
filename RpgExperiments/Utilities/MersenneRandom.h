//
//  SeededRandomGenerator.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MersenneRandom : NSObject
{
	unsigned int MT[624];
	unsigned int index;
	unsigned int _seed;
}

- (void)setSeed:(unsigned int)seed;
- (unsigned int)seed;
- (unsigned int)nextInt;
- (unsigned int)nextUniformIntWithUpperBound:(unsigned int)upperBound;
- (unsigned int)nextUniformIntWithUpperBound:(unsigned int)upperBound andLowerBound:(unsigned int)lowerBound;
- (float)nextFloat;

+ (MersenneRandom*)sharedInstance;

@end
