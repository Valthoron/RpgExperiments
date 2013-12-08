//
//  CaveBuilder.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Builder.h"

@interface CaveBuilder : Builder
{
	float initialPopulation;
	int threshold;
	int neighborhoodSize;
	int iterations;
	
	int* neighborCounts;
}

@end
