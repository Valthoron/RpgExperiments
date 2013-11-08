//
//  NSValue+Vector.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 03.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"

@interface NSValue (Vector)

+ (NSValue*)valueWithVector:(Vector)vector;
- (Vector)vectorValue;

@end
