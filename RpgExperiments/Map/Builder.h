//
//  Builder.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "Map+Builder.h"
#import "SeededRandomGenerator.h"

@interface Builder : NSObject
{
	Map* map;
	SeededRandomGenerator* random;
}

- (Map*)buildMapWithWidth:(NSUInteger)width andHeight:(NSUInteger)height;
- (Map*)buildMapWithWidth:(NSUInteger)width andHeight:(NSUInteger)height usingSeed:(unsigned int)seed;
- (void)buildMap;
- (NSString*)getName;
- (NSString*)getConfigurationHash;

@end
