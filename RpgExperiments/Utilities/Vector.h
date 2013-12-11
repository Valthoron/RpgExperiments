//
//  Vector.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Directions.h"

typedef struct
{
	NSInteger x, y;
} Vector;

// Constants
const Vector kVectorZero;
const Vector kVectorNorth;
const Vector kVectorNortheast;
const Vector kVectorEast;
const Vector kVectorSoutheast;
const Vector kVectorSouth;
const Vector kVectorSouthwest;
const Vector kVectorWest;
const Vector kVectorNorthwest;

// Vector operations
inline Vector MakeVector(NSInteger x, NSInteger y);
inline Vector VectorAdd(Vector v1, Vector v2);
inline Vector VectorSubtract(Vector v1, Vector v2);
inline Vector VectorNegative(Vector v);
inline Vector VectorMultiply(Vector v, float c);
inline Vector VectorDivide(Vector v, float c);
inline float VectorLengthSquared(Vector v);
inline float VectorLength(Vector v);
inline Vector VectorNormalize(Vector v);
inline float VectorDotProduct(Vector v1, Vector v2);
inline float VectorAngleBetween(Vector v1, Vector v2);

// Geometric operations
inline Vector VectorRotate(Vector v, Rotation r);
inline Vector VectorRotateAround(Vector v, Vector pivot, Rotation r);
inline Vector VectorForDirection(Direction d);

// Instance operations
NSComparisonResult VectorCompare(Vector v1, Vector v2);
