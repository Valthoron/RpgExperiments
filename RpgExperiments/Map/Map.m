//
//  Map.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Map.h"
#import "NSValue+Vector.h"

@implementation Map

// =========================
#pragma mark - Initializers
// =========================

- (id)init
{
    self = [super init];
	
    if (self)
	{
		_isRectangular = false;
		_minimumCoordinates = kVectorZero;
		_maximumCoordinates = kVectorZero;
		_baseAnchor = [Anchor anchorAt:kVectorZero inDirection:MainDirectionNorth withName:@"" andSubtype:0];
        _metadata = [[NSMutableDictionary alloc] init];
		
		tiles = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory];
		anchors = [[NSMutableArray alloc] init];
    }
	
    return self;
}

- (id)initRectangularWithWidth:(NSUInteger)width andHeight:(NSUInteger)height
{
	self = [self init];
	
	if (self)
	{
		_isRectangular = true;
		_minimumCoordinates = MakeVector(0, 0);
		_maximumCoordinates = MakeVector(width - 1, height - 1);
		
		NSUInteger tileCount = width * height;
		
		for (int i = 0; i < tileCount; i++)
		{
			Tile* tile = [[Tile alloc] init];
			Vector location = MakeVector(i % width, i / width);
			[tiles setObject:tile forKey:[NSValue valueWithVector:location]];
		}
	}
	
	return self;
}

- (id)initWithXmlElement:(CXMLElement*)xmlElement
{
	self = [self init];
	
	if (self)
	{
		NSString* roomName = [[xmlElement attributeForName:@"name"] stringValue];
		
		// ======
		// Tiles
		// ======
		NSArray* tileElements = [xmlElement nodesForXPath:@"tiles/tile" error:nil];
		
		for (CXMLElement* tileElement in tileElements)
		{
			Vector location = MakeVector(
										 [[[tileElement attributeForName:@"x"] stringValue] integerValue],
										 [[[tileElement attributeForName:@"y"] stringValue] integerValue]
										 );
			
			NSUInteger type = [[[tileElement attributeForName:@"type"] stringValue] integerValue];
			
			[self addTile:[Tile tileWithType:type] at:location];
		}
		
		// ========
		// Anchors
		// ========
		CXMLElement* baseAnchorElement = (CXMLElement*)[xmlElement nodeForXPath:@"anchors/baseanchor" error:nil];
		
		_baseAnchor = [Anchor anchorAt:MakeVector(
												  [[[baseAnchorElement attributeForName:@"x"] stringValue] integerValue],
												  [[[baseAnchorElement attributeForName:@"y"] stringValue] integerValue]
												  )
						   inDirection:MainDirectonFromString([[baseAnchorElement attributeForName:@"direction"] stringValue])
							  withName:roomName
							andSubtype:0
					   ];
		
		NSArray* anchorElements = [xmlElement nodesForXPath:@"anchors/anchor" error:nil];
		
		for (CXMLElement* anchorElement in anchorElements)
		{
			Anchor* anchor = [Anchor anchorAt:MakeVector(
														 [[[anchorElement attributeForName:@"x"] stringValue] integerValue],
														 [[[anchorElement attributeForName:@"y"] stringValue] integerValue]
														 )
								  inDirection:MainDirectonFromString([[anchorElement attributeForName:@"direction"] stringValue])
									 withName:roomName
								   andSubtype:[[[anchorElement attributeForName:@"type"] stringValue] integerValue]
							  ];
			
			[self addAnchor:anchor];
		}
	}
	
	return self;
}

// =======================
#pragma mark - Properties
// =======================

- (NSUInteger)width
{
	return _maximumCoordinates.x - _minimumCoordinates.x + 1;
}

- (NSUInteger)height
{
	return _maximumCoordinates.y - _minimumCoordinates.y + 1;
}

- (NSUInteger)anchorCount
{
	return anchors.count;
}

// ================================
#pragma mark - Getting Information
// ================================

- (id)copy
{
	Map* mapCopy = [[Map alloc] init];
	
	mapCopy->tiles = [tiles mutableCopy];
	mapCopy->anchors = [anchors mutableCopy];
	mapCopy->_isRectangular = _isRectangular;
	mapCopy->_minimumCoordinates = _minimumCoordinates;
	mapCopy->_maximumCoordinates = _maximumCoordinates;
	mapCopy->_baseAnchor = _baseAnchor;
	mapCopy->_metadata = [_metadata mutableCopy];
	
	return mapCopy;
}

- (Tile*)tileAt:(Vector)location
{
	return [tiles objectForKey:[NSValue valueWithVector:location]];
}

- (BOOL)isLocationEmpty:(Vector)location
{
	Tile* tile = [self tileAt:location];
	
	if (tile == nil)
		return YES;
	else if (tile.type == 0)
		return YES;
	
	return NO;
}

- (Anchor*)anchorAtIndex:(NSUInteger)index
{
	return [anchors objectAtIndex:index];
}

- (BOOL)containsCoordinates:(Vector)coordinates
{
	return [self containsCoordinates:coordinates inBand:0];
}

- (BOOL)containsCoordinates:(Vector)coordinates inBand:(NSUInteger)band
{
	if (coordinates.x < (_minimumCoordinates.x + band))
		return NO;
	
	if (coordinates.x > (_maximumCoordinates.x - band))
		return NO;
	
	if (coordinates.y < (_minimumCoordinates.y + band))
		return NO;
	
	if (coordinates.y > (_maximumCoordinates.y - band))
		return NO;
	
	return YES;
}

// =========================
#pragma mark - Modification
// =========================

- (void)recalculateMinMaxCoordinates
{
	Vector newMinimumCoordinates;
	Vector newMaximumCoordinates;
	BOOL firstTile = YES;
	
	for (NSValue* locationValue in tiles)
	{
		Vector location = [locationValue vectorValue];
		
		if (firstTile)
		{
			newMinimumCoordinates = location;
			newMaximumCoordinates = location;
			firstTile = NO;
		}
		else
		{
			if (newMinimumCoordinates.x > location.x)
				newMinimumCoordinates.x = location.x;
			
			if (newMinimumCoordinates.y > location.y)
				newMinimumCoordinates.y = location.y;
			
			if (newMaximumCoordinates.x < location.x)
				newMaximumCoordinates.x = location.x;
			
			if (newMaximumCoordinates.y < location.y)
				newMaximumCoordinates.y = location.y;
		}
	}
	
	_minimumCoordinates = newMinimumCoordinates;
	_maximumCoordinates = newMaximumCoordinates;
}

- (void)addTile:(Tile*)tile at:(Vector)location
{
	[tiles setObject:tile forKey:[NSValue valueWithVector:location]];
	
	// Extend minimum and maximum coordinates
	if (tiles.count == 1)
	{
		_minimumCoordinates = location;
		_maximumCoordinates = location;
		return;
	}
	
	if (_minimumCoordinates.x > location.x)
	{
		_minimumCoordinates.x = location.x;
		_isRectangular = false;
	}
	
	if (_minimumCoordinates.y > location.y)
	{
		_minimumCoordinates.y = location.y;
		_isRectangular = false;
	}
	
	if (_maximumCoordinates.x < location.x)
	{
		_maximumCoordinates.x = location.x;
		_isRectangular = false;
	}
	
	if (_maximumCoordinates.y < location.y)
	{
		_maximumCoordinates.y = location.y;
		_isRectangular = false;
	}
}

- (void)removeTileAt:(Vector)location
{
	[tiles removeObjectForKey:[NSValue valueWithVector:location]];
	
	[self recalculateMinMaxCoordinates];
}

- (void)addAnchor:(Anchor*)anchor
{
	[anchors addObject:anchor];
}

- (void)removeAnchorAt:(NSUInteger)index
{
	[anchors removeObjectAtIndex:index];
}

- (BOOL)placeMap:(Map*)map atAnchorIndexed:(NSUInteger)index force:(BOOL)forcePlace
{
	Anchor* targetAnchor = [anchors objectAtIndex:index];
	Vector displacement = VectorSubtract(targetAnchor.location, map.baseAnchor.location);
	Rotation rotation = FindRotation(map.baseAnchor.direction, targetAnchor.direction);
	
	NSMapTable* newLocationTable = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory];
	
	// Check to see if all tiles can be placed
	for (NSValue* locationValue in map->tiles)
	{
		Vector location = [locationValue vectorValue];
		
		Vector targetLocation = VectorAdd(
										  VectorRotateAround(location, map.baseAnchor.location, rotation),
										  displacement
										  );
		
		if (([self isLocationEmpty:targetLocation] == NO) && (forcePlace == NO))
			return NO;
		
		[newLocationTable setObject:[NSValue valueWithVector:targetLocation] forKey:locationValue];
	}
	
	// Place tiles
	for (NSValue* locationValue in map->tiles)
	{
		Tile* tile = [map->tiles objectForKey:locationValue];
		
		NSValue* newLocationValue = [newLocationTable objectForKey:locationValue];
		
		[tiles setObject:tile forKey:newLocationValue];
	}
	
	// Remove used anchor before inserting new ones!
	[self removeAnchorAt:index];
	
	// Place anchors
	for (Anchor* anchor in map->anchors)
	{
		Anchor* placedAnchor = (Anchor*)[anchor copy];
		
		placedAnchor.location = VectorAdd(
									VectorRotateAround(anchor.location, map.baseAnchor.location, rotation),
									displacement
									);
		
		placedAnchor.direction = RotateMainDirection(anchor.direction, rotation);
		
		[self addAnchor:placedAnchor];
	}
	
	[self recalculateMinMaxCoordinates];
	
	return YES;
}

@end
