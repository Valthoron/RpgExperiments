//
//  Directions.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 9.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

typedef enum
{
	North = 0,
	Northeast,
	East,
	Southeast,
	South,
	Southwest,
	West,
	Northwest,
	None = 10
} Direction;

typedef enum
{
	Zero = 0,
	Clockwise_90 = 1,
	Clockwise_180 = 2,
	CounterClockwise_180 = 2,
	CounterClockwise_90 = 3
} Rotation;

inline Direction RotateDirection(Direction d, Rotation r);
