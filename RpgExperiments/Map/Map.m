//
//  Map.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Map.h"

@implementation Map

- (id)init
{
    self = [super init];
	
    if (self)
	{
		_width = 0;
		_height = 0;
        _metadata = [[NSMutableDictionary alloc] init];
		tiles = [[NSMutableArray alloc] init];
    }
	
    return self;
}

- (id)initWithWidth:(NSUInteger)width andHeight:(NSUInteger)height
{
	self = [self init];
	
	if (self)
	{
		_width = width;
		_height = height;
		
		NSUInteger tileCount = width * height;
		
		for (int i = 0; i < tileCount; i++)
		{
			Tile* tile = [[Tile alloc] init];
			tile.coordinate = MakeVector(i % width, i / width);
			[tiles addObject:tile];
		}
	}
	
	return self;
}

- (Tile*)tileAt:(Vector)coordinate
{
	if (coordinate.x > _width)
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"x coordinate out of bounds" userInfo:nil];
	
	if (coordinate.y > _height)
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"y coordinate out of bounds" userInfo:nil];
	
	NSUInteger tileIndex = (coordinate.y * _width) + coordinate.x;
	return [tiles objectAtIndex:tileIndex];
}

- (BOOL)containsCoordinate:(Vector)coordinate
{
	if (coordinate.x >= _width)
		return NO;
	
	if (coordinate.y >= _height)
		return  NO;
	
	return YES;
}

- (BOOL)containsCoordinate:(Vector)coordinate withinBand:(NSUInteger)band
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
