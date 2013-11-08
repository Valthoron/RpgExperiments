//
//  Coordinate.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"

typedef struct
{
	NSUInteger x, y;
} Coordinate;

Coordinate MakeCoordinate(NSUInteger x, NSUInteger y);
