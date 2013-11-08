//
//  Coordinate.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Coordinate.h"

Coordinate MakeCoordinate(NSUInteger x, NSUInteger y)
{
	Coordinate c;
	c.x = x;
	c.y = y;
	return c;
}
