//
//  DiceNotationTermStack.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 21.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DiceNotationTerm;

@interface DiceNotationTermStack : NSObject
{
	NSMutableArray* stack;
}

@property (nonatomic, readonly) DiceNotationTerm* topTerm;
@property (nonatomic, readonly) NSUInteger size;
@property (nonatomic, readonly) BOOL isEmpty;

- (void)push:(DiceNotationTerm*)term;
- (DiceNotationTerm*)pop;

@end
