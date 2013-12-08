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

NSComparisonResult CompareCoordinates(Coordinate c1, Coordinate c2)
{
	if (c1.y < c2.y)
		return NSOrderedDescending;
	else if (c1.y > c2.y)
		return NSOrderedAscending;
	else
	{
		if (c1.x < c2.x)
			return NSOrderedDescending;
		else if (c1.x > c2.x)
			return NSOrderedAscending;
		else
			return NSOrderedSame;
	}
}