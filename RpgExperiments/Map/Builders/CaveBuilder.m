//
//  CaveBuilder.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "CaveBuilder.h"
#import "Builder_Subclass.h"
#import "NSValue+Vector.h"

@implementation CaveBuilder

- (id)init
{
    self = [super init];
	
    if (self)
	{
		[self setDefaultValue:0.6f forFloatParameter:@"initialPopulation"];
		[self setDefaultValue:2 forIntParameter:@"neighborhoodSize"];
		[self setDefaultValue:14 forIntParameter:@"threshold"];
		[self setDefaultValue:3 forIntParameter:@"iterations"];
    }
	
    return self;
}

- (void)buildMap
{
	initialPopulation = [self valueForFloatParameter:@"initialPopulation"];
	neighborhoodSize = [self valueForIntParameter:@"neighborhoodSize"];
	threshold = [self valueForIntParameter:@"threshold"];
	iterations = [self valueForIntParameter:@"iterations"];
	
	neighborCounts = (int*)calloc(width * height, sizeof(int));
	
	[self seedCells];
	
	for (int i = 0; i < iterations; i++)
		[self workCells];
	
	[self enumerateSections];
	
	free(neighborCounts);
}

- (void)seedCells
{
	for (int y = 0; y < map.height; y++)
	{
		for (int x = 0; x < map.width; x++)
		{
			Vector coordinate = MakeVector(x, y);
			
			Tile* tile = [map tileAt:coordinate];
			
			if (![map containsCoordinates:coordinate inBand:neighborhoodSize])
				continue;
			
			if ([random nextFloat] < initialPopulation)
			{
				tile.type = 1;
			}
		}
	}
}

- (void)workCells
{
	// Count neighbors for each cell
	for (int y = 0; y < map.height; y++)
	{
		for (int x = 0; x < map.width; x++)
		{
			Vector coordinate = MakeVector(x, y);
			
			if (![map containsCoordinates:coordinate inBand:neighborhoodSize])
				continue;
			
			int neighborCount = 0;
			
			for (int dx = -neighborhoodSize; dx <= neighborhoodSize; dx++)
			{
				for (int dy = -neighborhoodSize; dy <= neighborhoodSize; dy++)
				{
					if ((dx == 0) && (dy == 0))
						continue;
					
					Tile* neighbor = [map tileAt:MakeVector(x + dx, y + dy)];
					
					if (neighbor.type == 1)
						neighborCount++;
				}
			}
			
			neighborCounts[y * map.width + x] = neighborCount;
		}
	}

	// Kill or spawn cells depending on neighbor count
	for (int y = 0; y < map.height; y++)
	{
		for (int x = 0; x < map.width; x++)
		{
			Vector coordinate = MakeVector(x, y);
			
			if (![map containsCoordinates:coordinate inBand:neighborhoodSize])
				continue;
			
			Tile* tile = [map tileAt:coordinate];
			
			if (neighborCounts[y * map.width + x] >= threshold)
				tile.type = 1;
			else
				tile.type = 0;
		}
	}
}

- (void)enumerateSections
{
	NSUInteger nextRoom = 0;
	NSMutableArray* floodList = [[NSMutableArray alloc] init];
	
	for (int y = 0; y < map.height; y++)
	{
		for (int x = 0; x < map.width; x++)
		{
			Vector location = MakeVector(x, y);
			Tile* tile = [map tileAt:location];
			
			if ((tile.type == 0) || (tile.roomId != 0))
				continue;
			
			nextRoom++;
			[floodList addObject:[NSValue valueWithVector:location]];
			
			while (floodList.count > 0)
			{
				Vector thisLocation = [[floodList lastObject] vectorValue];
				[floodList removeLastObject];
				
				Tile* thisTile = [map tileAt:thisLocation];
				
				if ((thisTile.type == 0) || (thisTile.roomId != 0))
					continue;
				
				thisTile.roomId = nextRoom;
				thisTile.tag = [NSString stringWithFormat:@"%ld", (unsigned long)thisTile.roomId];
				
				[floodList addObject:[NSValue valueWithVector:VectorAdd(thisLocation, kVectorNorth)]];
				
				[floodList addObject:[NSValue valueWithVector:VectorAdd(thisLocation, kVectorEast)]];
				
				[floodList addObject:[NSValue valueWithVector:VectorAdd(thisLocation, kVectorSouth)]];
				
				[floodList addObject:[NSValue valueWithVector:VectorAdd(thisLocation, kVectorWest)]];
			}
		}
	}
}

@end
