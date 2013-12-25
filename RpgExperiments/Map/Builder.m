//
//  Builder.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Builder.h"
#import "Builder_Subclass.h"

NSMutableArray* registeredBuilders = nil;

@implementation Builder

- (id)init
{
    self = [super init];
	
    if (self)
	{
		random = [[MersenneRandom alloc] init];
		parameterDefaults = [[NSMutableDictionary alloc] init];
    }
	
    return self;
}

- (NSString*)description
{
	return [self.class description];
}

- (NSDictionary*)defaultConfiguration
{
	return [parameterDefaults copy];
}

- (Map*)buildMapWithWidth:(NSUInteger)mapWidth andHeight:(NSUInteger)mapHeight usingConfiguration:(NSDictionary*)configuration
{
	parameters = [configuration copy];
	
	width = mapWidth;
	height = mapHeight;
	
	id seedValueObject = [configuration objectForKey:@"seed"];
	if (seedValueObject)
		[random setSeed:(unsigned int)[seedValueObject longLongValue]];
	else
		[random reseed];
	
	map = [[Map alloc] initRectangularWithWidth:width andHeight:height];
	
	[self buildMap];
	
	[map.metadata setObject:[self.class description] forKey:@"builderName"];
	[map.metadata setObject:[NSNumber numberWithUnsignedInt:random.seed] forKey:@"builderSeed"];
	[map.metadata setObject:[configuration copy] forKey:@"builderConfiguration"];
	
	parameters = nil;
	
	return map;
}

- (void)buildMap
{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

// =============================================
#pragma mark - Setting default parameter values
// =============================================

- (void)setDefaultValue:(int)value forIntParameter:(NSString*)name
{
	[parameterDefaults setObject:[NSNumber numberWithInt:value] forKey:name];
}

- (void)setDefaultValue:(float)value forFloatParameter:(NSString*)name
{
	[parameterDefaults setObject:[NSNumber numberWithFloat:value] forKey:name];
}

- (void)setDefaultValue:(BOOL)value forBoolParameter:(NSString*)name
{
	[parameterDefaults setObject:[NSNumber numberWithBool:value] forKey:name];
}

- (void)setDefaultValue:(NSString*)value forStringParameter:(NSString*)name
{
	[parameterDefaults setObject:value forKey:name];
}

// =====================================
#pragma mark - Getting parameter values
// =====================================

- (int)valueForIntParameter:(NSString*)name
{
	id valueObject;
	
	// Try given values
	valueObject = [parameters objectForKey:name];
	
	if (valueObject)
		return [valueObject intValue];
	
	// Try default values
	valueObject = [parameterDefaults objectForKey:name];
	
	if (valueObject)
		return [valueObject intValue];
	
	// Fail
	return 0;
}

- (float)valueForFloatParameter:(NSString*)name
{
	id valueObject;
	
	// Try given values
	valueObject = [parameters objectForKey:name];
	
	if (valueObject)
		return [valueObject floatValue];
	
	// Try default values
	valueObject = [parameterDefaults objectForKey:name];
	
	if (valueObject)
		return [valueObject floatValue];
	
	// Fail
	return 0.0f;
}

- (BOOL)valueForBoolParameter:(NSString*)name
{
	id valueObject;
	
	// Try given values
	valueObject = [parameters objectForKey:name];
	
	if (valueObject)
		return [valueObject boolValue];
	
	// Try default values
	valueObject = [parameterDefaults objectForKey:name];
	
	if (valueObject)
		return [valueObject boolValue];
	
	// Fail
	return NO;
}

- (NSString*)valueForStringParameter:(NSString*)name
{
	id valueObject;
	
	// Try given values
	valueObject = [parameters objectForKey:name];
	
	if (valueObject)
		return (NSString*)valueObject;
	
	// Try default values
	valueObject = [parameterDefaults objectForKey:name];
	
	if (valueObject)
		return (NSString*)valueObject;
	
	// Fail
	return @"";
}


@end
