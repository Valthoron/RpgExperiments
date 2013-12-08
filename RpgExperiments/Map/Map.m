//
//  Map.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Map.h"

@implementation Map

- (id)initWithWidth:(NSUInteger)width andHeight:(NSUInteger)height
{
	self = [super init];
	
	if (self)
	{
		_width = width;
		_height = height;
		
		NSUInteger tileCount = width * height;
		NSMutableArray* mutableTiles = [[NSMutableArray alloc] initWithCapacity:(tileCount)];
		
		for (int i = 0; i < tileCount; i++)
		{
			Tile* tile = [[Tile alloc] init];
			tile.coordinate = MakeCoordinate(i % width, i / width);
			[mutableTiles addObject:tile];
		}
		
		tiles = [mutableTiles copy];
	}
	
	return self;
}

- (Tile*)tileAt:(Coordinate)coordinate
{
	if (coordinate.x > _width)
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"x coordinate out of bounds" userInfo:nil];
	
	if (coordinate.y > _height)
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"y coordinate out of bounds" userInfo:nil];
	
	NSUInteger tileIndex = (coordinate.y * _width) + coordinate.x;
	return [tiles objectAtIndex:tileIndex];
}

- (BOOL)containsCoordinate:(Coordinate)coordinate
{
	if (coordinate.x >= _width)
		return NO;
	
	if (coordinate.y >= _height)
		return  NO;
	
	return YES;
}

- (BOOL)containsCoordinate:(Coordinate)coordinate withinBand:(NSUInteger)band
{
	if (coordinate.x < band)
		return NO;
	
	if (coordinate.x >= _width - band)
		return NO;
	
	if (coordinate.y < band)
		return NO;
	
	if (coordinate.y >= _height - band)
		return NO;
	
	return YES;
}

@end
