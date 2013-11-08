//
//  Tile.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 24.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Tile.h"
#import "Tile+Builder.h"

@implementation Tile

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_location = MakeCoordinate(0, 0);
		_sectionId = 0;
		_tileId = 0;
		_artId = 0;
	}
	
	return self;
}

- (void)resetBuilderData
{
	_builderData1 = 0;
	_builderData2 = 0;
	_builderData3 = 0.f;
}

@end
