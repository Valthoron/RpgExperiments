//
//  Builder.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Builder.h"
#import "Builder_Subclass.h"
#import "BuilderParameter.h"

NSMutableArray* registeredBuilders = nil;

@implementation Builder

- (id)init
{
    self = [super init];
	
    if (self)
	{
		random = [[MersenneRandom alloc] init];
		parameters = [[NSMutableArray alloc] init];
    }
	
    return self;
}

- (NSString*)description
{
	return [self.class description];
}

- (void)parseConfiguration:(NSDictionary *)configuration
{
	id valueObject;
	
	valueObject = [configuration objectForKey:@"seed"];
	if (valueObject)
		[random setSeed:(unsigned int)[valueObject longLongValue]];
	
	for (BuilderParameter* parameter in parameters)
	{
		valueObject = [configuration objectForKey:parameter.name];
		
		if (valueObject == nil)
			valueObject = parameter.defaultValue;
		
		switch (parameter.type)
		{
			case kCFNumberIntType:
				*(int*)(parameter.variable) = [valueObject intValue];
				break;
				
			case kCFNumberFloatType:
				*(float*)(parameter.variable) = [valueObject floatValue];
				break;
				
			case kCFNumberCharType:
				*(BOOL*)(parameter.variable) = [valueObject boolValue];
				break;
				
			default:
				break;
		}
	}
}

- (NSDictionary*)defaultConfiguration
{
	NSMutableDictionary* configuration = [[NSMutableDictionary alloc] init];
	
	for (BuilderParameter* parameter in parameters)
		[configuration setObject:parameter.defaultValue forKey:parameter.name];
	
	return [configuration copy];
}

- (Map*)buildMapWithWidth:(NSUInteger)mapWidth andHeight:(NSUInteger)mapHeight usingConfiguration:(NSDictionary*)configuration
{
	width = mapWidth;
	height = mapHeight;
	
	[self parseConfiguration:configuration];
	
	map = [[Map alloc] initWithWidth:width andHeight:height];
	
	[self buildMap];
	
	[map.metadata setObject:[self.class description] forKey:@"builderName"];
	[map.metadata setObject:[NSNumber numberWithUnsignedInt:random.seed] forKey:@"builderSeed"];
	[map.metadata setObject:[configuration copy] forKey:@"builderConfiguration"];
	
	return map;
}

- (void)buildMap
{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

@end
