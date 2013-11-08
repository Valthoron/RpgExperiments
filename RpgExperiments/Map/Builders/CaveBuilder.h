//
//  CaveBuilder.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Builder.h"

@interface CaveBuilder : Builder

@property (nonatomic) float initialPopulation;
@property (nonatomic) int threshold;
@property (nonatomic) int neighborhoodSize;
@property (nonatomic) int iterations;

@end
