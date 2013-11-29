//
//  Vector.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Vector.h"

inline Vector MakeVector(NSInteger x, NSInteger y)
{
	Vector v;
	v.x = x;
	v.y = y;
	return v;
}

inline Vector VectorAdd(Vector v1, Vector v2)
{
	return MakeVector(v1.x + v2.x, v1.y + v2.y);
}

inline Vector VectorSubtract(Vector v1, Vector v2)
{
	return MakeVector(v1.x - v2.x, v1.y - v2.y);
}

inline Vector VectorNegative(Vector v)
{
	return MakeVector(-v.x, -v.y);
}

inline Vector VectorMultiply(Vector v, float c)
{
	return MakeVector(v.x * c, v.y * c);
}

inline Vector VectorDivide(Vector v, float c)
{
	return MakeVector(v.x / c, v.y / c);
}

inline float VectorLengthSquared(Vector v)
{
	return (v.x * v.x) + (v.y * v.y);
}

inline float VectorLength(Vector v)
{
	return sqrtf(VectorLengthSquared(v));
}

inline Vector VectorNormalize(Vector v)
{
	return VectorDivide(v, VectorLength(v));
}

inline float VectorDotProduct(Vector v1, Vector v2)
{
	return (v1.x * v2.x) + (v1.y * v2.y);
}

inline float VectorAngleBetween(Vector v1, Vector v2)
{
	float length1 = VectorLength(v1);
	float length2 = VectorLength(v2);
	float angle = acosf(VectorDotProduct(v1, v2) / (length1 * length2));
	
	if (angle <= M_PI)
		return angle;
	else
		return M_PI - angle;
}
