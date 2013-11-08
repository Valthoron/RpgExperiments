//
//  DiceNotationTermStack.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 21.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "DiceNotationTermStack.h"

@implementation DiceNotationTermStack

- (id)init
{
	self = [super init];
	
	if (self)
	{
		stack = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (DiceNotationTerm*)topTerm
{
	return (DiceNotationTerm*)stack.lastObject;
}

- (NSUInteger)size
{
	return stack.count;
}

- (BOOL)isEmpty
{
	return (stack.count == 0);
}

- (void)push:(DiceNotationTerm *)term
{
	[stack addObject:term];
}

- (DiceNotationTerm*)pop
{
	DiceNotationTerm* term = (DiceNotationTerm*)stack.lastObject;
	[stack removeLastObject];
	return term;
}

@end
