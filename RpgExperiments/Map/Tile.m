//
//  Tile.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 24.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Tile.h"

@implementation Tile

+ (Tile*)tileWithType:(NSUInteger)type
{
	Tile* tile = [[Tile alloc] init];
	tile.type = type;
	return tile;
}

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_type = 0;
	}
	
	return self;
}

@end
