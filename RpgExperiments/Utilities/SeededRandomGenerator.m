//
//  SeededRandomGenerator.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "SeededRandomGenerator.h"

@implementation SeededRandomGenerator

- (id)initWithSeed:(unsigned int)seed
{
	self = [super init];
	
	if (self)
	{
		index = 0;
		MT[0] = seed;
		
		for (int i = 1; i < 624; i++)
		{
			MT[i] = 0x6c078965 * (MT[i - 1] ^ (MT[i - 1] >> 30)) + i; // 
		}
	}
	
	return self;
}

- (void)generateNumbers
{
	for (int i = 0; i < 624; i++)
	{
		unsigned int y = (MT[i] & 0x80000000) + (MT[(i + 1) % 624] & 0x7fffffff);
		
		MT[i] = MT[(i + 397) % 624] ^ (y >> 1);
		
		if ((y % 2) != 0) // y is odd
		{
			MT[i] = MT[i] ^ 0x9908b0df;
		}
	}
}

- (unsigned int)nextInt
{
	if (index == 0)
	{
		[self generateNumbers];
	}
	
	unsigned int y = MT[index];
	y = y ^ (y >> 11);
	y = y ^ ((y << 7) & 0x9d2c5680);
	y = y ^ ((y << 15) & 0xefc60000);
	y = y ^ (y >> 18);
	
	index = (index + 1) % 624;
	
	return y;
}

- (unsigned int)nextUniformIntWithUpperBound:(unsigned int)upperBound
{
	unsigned int maxUInt = 0xffffffff;
	unsigned int maxUsable = (maxUInt / upperBound) * upperBound;
	
	while (1)
	{
		unsigned int result = [self nextInt];
		
		if(result < maxUsable)
			return result % upperBound;
	}
}

- (unsigned int)nextUniformIntWithUpperBound:(unsigned int)upperBound andLowerBound:(unsigned int)lowerBound
{
	if (upperBound < lowerBound)
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Lower bound cannot be greater than upper bound." userInfo:nil];
	
	unsigned int range = upperBound - lowerBound;
	
	return [self nextUniformIntWithUpperBound:range] + lowerBound;
}

- (float)nextFloat
{
	unsigned int maxUInt = 0xffffffff;
	return (float)[self nextInt] / (float)maxUInt;
}

@end
