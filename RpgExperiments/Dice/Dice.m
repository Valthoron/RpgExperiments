//
//  Dice.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 19.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Dice.h"
#import "DiceNotationTerm.h"
#import "DiceNotationTermStack.h"

@implementation Dice

int roll(int sides)
{
	return arc4random_uniform(sides) + 1;
}

+ (int)roll:(int)dice d:(int)sides
{
	int result = 0;
	
	NSMutableString* string = [[NSMutableString alloc] init];
	
	for (int i = 0; i < dice; i++)
	{
		int value = roll(sides);
		
		if (i > 0)
			[string appendString:@", "];
		
		[string appendFormat:@"%d", value];
		
		result += value;
	}
	
	return result;
}

+ (int)rollExpression:(NSString*)expression
{
	int result = 0;
	
	// Parse expression as infix
	NSMutableArray* infix = [[NSMutableArray alloc] init];
	NSUInteger current = 0;
	NSUInteger start = 0;
	NSUInteger length = 0;
	
	while (1)
	{
		unichar c = [expression characterAtIndex:current];
		
		switch (c)
		{
			// Digits
			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
			case '8':
			case '9':
				if (length == 0)
					start = current;
				
				length++;
				break;
			
			// Whitespace
			case ' ':
			case '\t':
			case '\n':
			case '\r':
				if (length > 0)
				{
					[infix addObject:[[DiceNotationTerm alloc] initWithString:[expression substringWithRange:NSMakeRange(start, length)]]];
					length = 0;
				}
				break;
			
				
			default:
				if (length > 0)
				{
					[infix addObject:[[DiceNotationTerm alloc] initWithString:[expression substringWithRange:NSMakeRange(start, length)]]];
					length = 0;
				}
				
				[infix addObject:[[DiceNotationTerm alloc] initWithString:[expression substringWithRange:NSMakeRange(current, 1)]]];
				break;
		}
		
		current++;
		
		if (current == expression.length)
		{
			if (length > 0)
				[infix addObject:[[DiceNotationTerm alloc] initWithString:[expression substringWithRange:NSMakeRange(start, length)]]];
			
			break;
		}
	}
	
	//NSLog(@"%@", [infix debugDescription]);
	
	// Convert infix to postfix
	// http://faculty.cs.niu.edu/~hutchins/csci241/eval.htm
	NSMutableArray* postfix = [[NSMutableArray alloc] init];
	DiceNotationTermStack* conversionStack = [[DiceNotationTermStack alloc] init];
	
	for (int i = 0; i < infix.count; i++)
	{
		DiceNotationTerm* term = (DiceNotationTerm*)[infix objectAtIndex:i];
		
		if (term.type == TermOperand)
		{
			[postfix addObject:term];
		}
		else if (term.type == TermLeftParenthesis)
		{
			[conversionStack push:term];
		}
		else if (term.type == TermRightParenthesis)
		{
			if (conversionStack.isEmpty)
				@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Unbalanced parentheses in expression." userInfo:nil];
			
			while (!conversionStack.isEmpty)
			{
				if (conversionStack.topTerm.type == TermLeftParenthesis)
				{
					[conversionStack pop];
					break;
				}
				else
				{
					[postfix addObject:[conversionStack pop]];
				}
			}
		}
		else if (term.type == TermOperator)
		{
			if (conversionStack.isEmpty || (conversionStack.topTerm.type == TermLeftParenthesis))
			{
				[conversionStack push:term];
			}
			else
			{
				while (!conversionStack.isEmpty && (conversionStack.topTerm.type != TermLeftParenthesis) && (term.precedence <= conversionStack.topTerm.precedence))
				{
					[postfix addObject:[conversionStack pop]];
				}
				
				[conversionStack push:term];
			}
		}
	}
	
	while (conversionStack.size > 0)
	{
		if (conversionStack.topTerm.type == TermLeftParenthesis)
			@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Unbalanced parentheses in expression." userInfo:nil];
		
		[postfix addObject:[conversionStack pop]];
	}
	
	//NSLog(@"%@", [postfix debugDescription]);
	
	// Evaluate expression
	DiceNotationTermStack* evaluationStack = [[DiceNotationTermStack alloc] init];
	
	for (int i = 0; i < postfix.count; i++)
	{
		DiceNotationTerm* term = (DiceNotationTerm*)[postfix objectAtIndex:i];
		
		if (term.type == TermOperand)
		{
			[evaluationStack push:term];
		}
		else if (term.type == TermOperator)
		{
			DiceNotationTerm* operandB = [evaluationStack pop];
			DiceNotationTerm* operandA = [evaluationStack pop];
			DiceNotationTerm* result = [[DiceNotationTerm alloc] initAsResultOfOperation:term onOperands:operandA and:operandB];
			[evaluationStack push:result];
		}
	}
	
	result = evaluationStack.topTerm.value;
	
	return result;
}

@end
