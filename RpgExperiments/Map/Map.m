//
//  Map.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Map.h"
#import "Map+Builder.h"

@implementation Map

- (id)initWithWidth:(NSUInteger)theWidth andHeight:(NSUInteger)theHeight
{
	self = [super init];
	
	if (self)
	{
		_width = theWidth;
		_height = theHeight;
		
		NSMutableArray* tileArray = [[NSMutableArray alloc] init];
		NSUInteger tileCount = _width * _height;
		
		for (NSUInteger i = 0; i < tileCount; i++)
		{
			NSUInteger x = i % _width;
			NSUInteger y = i / _width;
			
			Tile* tile = [[Tile alloc] init];
			tile.location = MakeCoordinate(x, y);
			[tileArray addObject:tile];
		}
		
		tiles = [NSArray arrayWithArray:tileArray];
	}
	
	return self;
}

- (Tile*)tileAt:(Coordinate)coordinate
{
	NSUInteger tileIndex = (coordinate.y * _width) + coordinate.x;
	return [tiles objectAtIndex:tileIndex];
}

- (void)iterateTilesUsingBlock:(void (^)(Tile *))block
{
	for (NSUInteger i = 0; i < tiles.count; i++)
	{
		block((Tile*)[tiles objectAtIndex:i]);
	}
}

@end
