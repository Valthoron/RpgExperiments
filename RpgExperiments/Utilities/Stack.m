//
//  Stack.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 21.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (id)init
{
	self = [super init];
	
	if (self)
	{
		stack = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)topObject
{
	return stack.lastObject;
}

- (NSUInteger)size
{
	return stack.count;
}

- (BOOL)isEmpty
{
	return (stack.count == 0);
}

- (void)push:(id)object
{
	[stack addObject:object];
}

- (id)pop
{
	id object = stack.lastObject;
	[stack removeLastObject];
	return object;
}

@end
