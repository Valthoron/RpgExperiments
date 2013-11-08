//
//  Dice.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 19.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dice : NSObject

+ (int)roll:(int)dice d:(int)sides;
+ (int)rollExpression:(NSString*)dice;

@end
