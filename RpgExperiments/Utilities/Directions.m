//
//  Directions.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 10.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#include "Directions.h"

Direction RotateDirection(Direction d, Rotation r)
{
	// Every 90 degrees of rotation moves forward 2 directions.
	return (d + (r * 2)) % 8;
}
