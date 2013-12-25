//
//  Directions.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 9.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

typedef enum
{
	MainDirectionNorth = 0,
	MainDirectionEast,
	MainDirectionSouth,
	MainDirectionWest,
	MainDirectionNone = 10
} MainDirection;

typedef enum
{
	DirectionNorth = 0,
	DirectionNortheast,
	DirectionEast,
	DirectionSoutheast,
	DirectionSouth,
	DirectionSouthwest,
	DirectionWest,
	DirectionNorthwest,
	DirectionNone = 10
} Direction;

typedef enum
{
	RotationZero = 0,
	RotationClockwise90 = 1,
	RotationClockwise180 = 2,
	RotationCounterClockwise180 = 2,
	RotationCounterClockwise90 = 3
} Rotation;

inline MainDirection MainDirectonFromString(NSString* string);
inline MainDirection RotateMainDirection(MainDirection d, Rotation r);
inline Rotation FindRotation(MainDirection start, MainDirection end);
