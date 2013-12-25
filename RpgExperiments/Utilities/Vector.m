//
//  Vector.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Vector.h"

// ======================
#pragma mark - Constants
// ======================

const Vector kVectorZero		= { .x =  0, .y =  0 };
const Vector kVectorNorth		= { .x =  0, .y =  1 };
const Vector kVectorNortheast	= { .x =  1, .y =  1 };
const Vector kVectorEast		= { .x =  1, .y =  0 };
const Vector kVectorSoutheast	= { .x =  1, .y = -1 };
const Vector kVectorSouth		= { .x =  0, .y = -1 };
const Vector kVectorSouthwest	= { .x = -1, .y = -1 };
const Vector kVectorWest		= { .x = -1, .y =  0 };
const Vector kVectorNorthwest	= { .x = -1, .y =  1 };

// ==============================
#pragma mark - Vector Operations
// ==============================

Vector MakeVector(NSInteger x, NSInteger y)
{
	Vector v;
	v.x = x;
	v.y = y;
	return v;
}

Vector VectorAdd(Vector v1, Vector v2)
{
	return MakeVector(v1.x + v2.x, v1.y + v2.y);
}

Vector VectorSubtract(Vector v1, Vector v2)
{
	return MakeVector(v1.x - v2.x, v1.y - v2.y);
}

Vector VectorNegative(Vector v)
{
	return MakeVector(-v.x, -v.y);
}

Vector VectorMultiply(Vector v, float c)
{
	return MakeVector(v.x * c, v.y * c);
}

Vector VectorDivide(Vector v, float c)
{
	return MakeVector(v.x / c, v.y / c);
}

float VectorLengthSquared(Vector v)
{
	return (v.x * v.x) + (v.y * v.y);
}

float VectorLength(Vector v)
{
	return sqrtf(VectorLengthSquared(v));
}

Vector VectorNormalize(Vector v)
{
	return VectorDivide(v, VectorLength(v));
}

float VectorDotProduct(Vector v1, Vector v2)
{
	return (v1.x * v2.x) + (v1.y * v2.y);
}

float VectorAngleBetween(Vector v1, Vector v2)
{
	float length1 = VectorLength(v1);
	float length2 = VectorLength(v2);
	float angle = acosf(VectorDotProduct(v1, v2) / (length1 * length2));
	
	if (angle <= M_PI)
		return angle;
	else
		return M_PI - angle;
}

// =================================
#pragma mark - Geometric Operations
// =================================

Vector VectorRotate(Vector v, Rotation r)
{
	switch (r)
	{
		case RotationClockwise90:
			return MakeVector(v.y, -v.x);
			
		case RotationClockwise180:
			return MakeVector(-v.x, -v.y);
			
		case RotationCounterClockwise90:
			return MakeVector(-v.y, v.x);
			
		default:
			return v;
	}
}

Vector VectorRotateAround(Vector v, Vector pivot, Rotation r)
{
	return VectorAdd(VectorRotate(VectorSubtract(v, pivot), r), pivot);
}

Vector VectorForDirection(Direction d)
{
	switch (d)
	{
		case DirectionNorth:
			return kVectorNorth;
			
		case DirectionNortheast:
			return kVectorNortheast;
			
		case DirectionEast:
			return kVectorEast;
			
		case DirectionSoutheast:
			return kVectorSoutheast;
			
		case DirectionSouth:
			return kVectorSouth;
			
		case DirectionSouthwest:
			return kVectorSouthwest;
			
		case DirectionWest:
			return kVectorWest;
			
		case DirectionNorthwest:
			return kVectorNorthwest;
			
		default:
			return kVectorZero;
		
	}
}

Vector VectorForMainDirection(MainDirection d)
{
	switch (d)
	{
		case MainDirectionNorth:
			return kVectorNorth;
			
		case MainDirectionEast:
			return kVectorEast;
			
		case MainDirectionSouth:
			return kVectorSouth;
			
		case MainDirectionWest:
			return kVectorWest;
			
		default:
			return kVectorZero;
			
	}
}

// ================================
#pragma mark - Instance Operations
// ================================

NSComparisonResult VectorCompare(Vector v1, Vector v2)
{
	if (v1.y < v2.y)
		return NSOrderedDescending;
	else if (v1.y > v2.y)
		return NSOrderedAscending;
	else
	{
		if (v1.x < v2.x)
			return NSOrderedDescending;
		else if (v1.x > v2.x)
			return NSOrderedAscending;
		else
			return NSOrderedSame;
	}
}
