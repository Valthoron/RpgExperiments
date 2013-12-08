//
//  Builder.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "MersenneRandom.h"

@interface Builder : NSObject
{
	NSUInteger width;
	NSUInteger height;
	MersenneRandom* random;
	NSMutableArray* parameters;
	Map* map;
}

- (NSDictionary*)defaultConfiguration;
- (Map*)buildMapWithWidth:(NSUInteger)mapWidth andHeight:(NSUInteger)mapHeight usingConfiguration:(NSDictionary*)configuration;

@end
