//
//  NSValue+Coordinate.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 03.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"

@interface NSValue (Coordinate)

+ (NSValue*)valueWithCoordinate:(Coordinate)coordinate;
- (Coordinate)coordinateValue;

@end
