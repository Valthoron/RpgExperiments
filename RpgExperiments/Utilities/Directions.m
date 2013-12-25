//
//  Directions.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 10.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#include "Directions.h"

MainDirection MainDirectonFromString(NSString* string)
{
	NSString* letter = [[string substringToIndex:1] uppercaseString];
	
	if ([letter isEqualToString:@"N"])
		return MainDirectionNorth;
	else if ([letter isEqualToString:@"E"])
		return MainDirectionEast;
	else if ([letter isEqualToString:@"S"])
		return MainDirectionSouth;
	else if ([letter isEqualToString:@"W"])
		return MainDirectionWest;
	else
		return MainDirectionNone;
}

MainDirection RotateMainDirection(MainDirection d, Rotation r)
{
	if (d == MainDirectionNone)
		return MainDirectionNone;
	
	// Every 90 degrees of rotation moves forward 1 direction.
	return (d + r) % 4;
}

Rotation FindRotation(MainDirection start, MainDirection end)
{
	if ((start == MainDirectionNone) || (end == MainDirectionNone))
		return RotationZero;
	
	return (end - start) % 4;
}
