//
//  Builder.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Builder.h"

@implementation Builder

- (id)init
{
    self = [super init];
	
    if (self)
	{
    }
	
    return self;
}

- (Map*)buildMapWithWidth:(NSUInteger)width andHeight:(NSUInteger)height
{
	return [self buildMapWithWidth:width andHeight:height usingSeed:arc4random()];
}

- (Map*)buildMapWithWidth:(NSUInteger)width andHeight:(NSUInteger)height usingSeed:(unsigned int)seed
{
	NSLog(@"%@ building map using seed: %u", [self className], seed);
	
	random = [[SeededRandomGenerator alloc] initWithSeed:seed];
	map = [[Map alloc] initWithWidth:width andHeight:height];
	
	[self buildMap];
	
	map.builderName = [self getName];
	map.builderConfigurationHash = [self getConfigurationHash];
	map.builderSeed = seed;
	
	return map;
}

- (void)buildMap
{
	@throw [NSException exceptionWithName:@"NOT IMPLEMENTED" reason:@"Method not implemented." userInfo:nil];
}

- (NSString *)getName
{
	return [self className];
}

- (NSString*)getConfigurationHash
{
	return @"";
}

@end
