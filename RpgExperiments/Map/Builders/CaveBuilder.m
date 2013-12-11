//
//  CaveBuilder.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "CaveBuilder.h"
#import "Builder_Subclass.h"
#import "BuilderParameter.h"

@implementation CaveBuilder

- (id)init
{
    self = [super init];
	
    if (self)
	{
		[parameters addObject:[BuilderParameter floatParameter:&initialPopulation withName:@"initialPopulation" andDefaultValue:0.6f]];
		[parameters addObject:[BuilderParameter intParameter:&neighborhoodSize withName:@"neighborhoodSize" andDefaultValue:2]];
		[parameters addObject:[BuilderParameter intParameter:&threshold withName:@"threshold" andDefaultValue:14]];
		[parameters addObject:[BuilderParameter intParameter:&iterations withName:@"iterations" andDefaultValue:3]];
    }
	
    return self;
}

- (void)buildMap
{
	neighborCounts = (int*)malloc(width * height * sizeof(int));
	
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
			
			if (![map containsCoordinate:coordinate withinBand:neighborhoodSize])
				continue;
			
			if ([random nextFloat] < initialPopulation)
			{
				tile.tileId = 1;
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
			
			if (![map containsCoordinate:coordinate withinBand:neighborhoodSize])
				continue;
			
			int neighborCount = 0;
			
			for (int dx = -neighborhoodSize; dx <= neighborhoodSize; dx++)
			{
				for (int dy = -neighborhoodSize; dy <= neighborhoodSize; dy++)
				{
					if ((dx == 0) && (dy == 0))
						continue;
					
					Tile* neighbor = [map tileAt:MakeVector(x + dx, y + dy)];
					
					if (neighbor.tileId == 1)
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
			
			if (![map containsCoordinate:coordinate withinBand:neighborhoodSize])
				continue;
			
			Tile* tile = [map tileAt:coordinate];
			
			if (neighborCounts[y * map.width + x] >= threshold)
				tile.tileId = 1;
			else
				tile.tileId = 0;
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
			Vector coordinate = MakeVector(x, y);
			Tile* tile = [map tileAt:coordinate];
			
			if ((tile.tileId == 0) || (tile.roomId != 0))
				continue;
			
			nextRoom++;
			[floodList addObject:tile];
			
			while (floodList.count > 0)
			{
				Tile* thisTile;
				
				thisTile = [floodList lastObject];
				[floodList removeLastObject];
				
				thisTile.roomId = nextRoom;
				thisTile.tag = [NSString stringWithFormat:@"%ld", (unsigned long)thisTile.roomId];
				
				if (thisTile.coordinate.x > 0)
				{
					Tile* leftNeighbor = [map tileAt:MakeVector(thisTile.coordinate.x - 1, thisTile.coordinate.y)];
					
					if ((leftNeighbor.tileId != 0) && (leftNeighbor.roomId == 0))
						[floodList addObject:leftNeighbor];
				}
				
				if (thisTile.coordinate.x < (map.width - 1))
				{
					Tile* rightNeighbor = [map tileAt:MakeVector(thisTile.coordinate.x + 1, thisTile.coordinate.y)];
					
					if ((rightNeighbor.tileId != 0) && (rightNeighbor.roomId == 0))
						[floodList addObject:rightNeighbor];
				}
				
				if (thisTile.coordinate.y > 0)
				{
					Tile* downNeighbor = [map tileAt:MakeVector(thisTile.coordinate.x, thisTile.coordinate.y - 1)];
					
					if ((downNeighbor.tileId != 0) && (downNeighbor.roomId == 0))
						[floodList addObject:downNeighbor];
				}
				
				if (thisTile.coordinate.y < (map.height - 1))
				{
					Tile* upNeighbor = [map tileAt:MakeVector(thisTile.coordinate.x, thisTile.coordinate.y + 1)];
					
					if ((upNeighbor.tileId != 0) && (upNeighbor.roomId == 0))
						[floodList addObject:upNeighbor];
				}
			}
		}
	}
}

@end
