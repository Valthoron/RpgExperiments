//
//  CaveBuilder.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "CaveBuilder.h"

@implementation CaveBuilder

- (id)init
{
    self = [super init];
	
    if (self)
	{
		_initialPopulation = 0.50f;
		_neighborhoodSize = 2;
		_threshold = 13;
		_iterations = 3;
    }
	
    return self;
}

- (NSString*)getConfigurationHash
{
	return [NSString stringWithFormat:@"Initial population = %f, Neighborhood size = %d, Threshold = %d, Iterations = %d", _initialPopulation, _neighborhoodSize, _threshold, _iterations];
}

- (void)buildMap
{
	[self seedCells];
	
	for (int i = 0; i < _iterations; i++)
	{
		[self workCells];
	}
	
	[self enumerateSections];
}

- (void)setTileIds:(NSUInteger)tileId inRect:(NSRect)rect
{
	NSUInteger xMin = rect.origin.x;
	NSUInteger xMax = rect.origin.x + rect.size.width - 1;
	NSUInteger yMin = rect.origin.y;
	NSUInteger yMax = rect.origin.y + rect.size.height -1;
	
	for (NSUInteger x = xMin; x <= xMax; x++)
	{
		for (NSUInteger y = yMin; y <= yMax; y++)
		{
			[map tileAt:MakeCoordinate(x, y)].tileId = tileId;
		}
	}
}

- (void)seedCells
{
	[map iterateTilesUsingBlock:^(Tile *tile)
	 {
		 if ((tile.location.x < _neighborhoodSize) ||
			 (tile.location.x >= (map.width - _neighborhoodSize)) ||
			 (tile.location.y < _neighborhoodSize) ||
			 (tile.location.y >= (map.height - _neighborhoodSize)))
			 return;
		 
		 if ([random nextFloat] < _initialPopulation)
		 {
			 tile.tileId = 1;
		 }
	 }];
}

- (void)workCells
{
	// Count neighbors for each cell
	[map iterateTilesUsingBlock:^(Tile *tile)
	 {
		 if ((tile.location.x < _neighborhoodSize) ||
			 (tile.location.x >= (map.width - _neighborhoodSize)) ||
			 (tile.location.y < _neighborhoodSize) ||
			 (tile.location.y >= (map.height - _neighborhoodSize)))
			 return;
		 
		 int neighborCount = 0;
		 
		 for (int x = -_neighborhoodSize; x <= _neighborhoodSize; x++)
		 {
			 for (int y = -_neighborhoodSize; y <= _neighborhoodSize; y++)
			 {
				 if ((x == 0) && (y == 0))
					 continue;
				 
				 if ([map tileAt:MakeCoordinate(tile.location.x + x, tile.location.y + y)].tileId == 0)
					 neighborCount++;
			 }
		 }
		 
		 tile.builderData1 = neighborCount;
	 }];
	
	// Kill or spawn cells depending on neighbor count
	[map iterateTilesUsingBlock:^(Tile *tile)
	 {
		 if ((tile.location.x < _neighborhoodSize) ||
			 (tile.location.x >= (map.width - _neighborhoodSize)) ||
			 (tile.location.y < _neighborhoodSize) ||
			 (tile.location.y >= (map.height - _neighborhoodSize)))
			 return;
		 
		 if (tile.builderData1 >= _threshold)
			 tile.tileId = 0;
		 else
			 tile.tileId = 1;
	 }];
}

- (void)enumerateSections
{
	__block NSUInteger nextSection = 0;
	__block NSMutableArray* floodList = [[NSMutableArray alloc] init];
	
	[map iterateTilesUsingBlock:^(Tile *tile)
	 {
		 if ((tile.tileId == 0) || (tile.sectionId != 0))
			 return;
		 
		 nextSection++;
		 [floodList addObject:tile];
		 
		 while (floodList.count > 0)
		 {
			 Tile* thisTile;
			 
			 thisTile = [floodList objectAtIndex:0];
			 [floodList removeObjectAtIndex:0];
			 
			 if ((thisTile.tileId == 0) || (thisTile.sectionId != 0))
				 continue;
			 
			 thisTile.sectionId = nextSection;
			 
			 if (thisTile.location.x > 0)
			 {
				 Tile* leftNeighbor = [map tileAt:MakeCoordinate(thisTile.location.x - 1, thisTile.location.y)];
				 [floodList addObject:leftNeighbor];
			 }
			 
			 if (thisTile.location.x < (map.width - 1))
			 {
				 Tile* rightNeighbor = [map tileAt:MakeCoordinate(thisTile.location.x + 1, thisTile.location.y)];
				 [floodList addObject:rightNeighbor];
			 }
			 
			 if (thisTile.location.y > 0)
			 {
				 Tile* downNeighbor = [map tileAt:MakeCoordinate(thisTile.location.x, thisTile.location.y - 1)];
				 [floodList addObject:downNeighbor];
			 }
			 
			 if (thisTile.location.y < (map.height - 1))
			 {
				 Tile* upNeighbor = [map tileAt:MakeCoordinate(thisTile.location.x, thisTile.location.y + 1)];
				 [floodList addObject:upNeighbor];
			 }
		 }
	 }];
}

@end
