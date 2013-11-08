//
//  DiceNotationTerm.m
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 21.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "DiceNotationTerm.h"
#import "Dice.h"

@implementation DiceNotationTerm

- (id)initWithString:(NSString *)string
{
	self = [super init];
	
	if (self)
	{
		_value = 0;
		_operatorType = OperatorNone;
		_precedence = 0;
		
		if ([string isEqualToString:@"("])
		{
			_type = TermLeftParenthesis;
		}
		else if ([string isEqualToString:@")"])
		{
			_type = TermRightParenthesis;
		}
		else if ([string isEqualToString:@"d"])
		{
			_type = TermOperator;
			_operatorType = OperatorRoll;
			_precedence = 3;
		}
		else if ([string isEqualToString:@"+"])
		{
			_type = TermOperator;
			_operatorType = OperatorAddition;
			_precedence = 1;
		}
		else if ([string isEqualToString:@"-"])
		{
			_type = TermOperator;
			_operatorType = OperatorSubtraction;
			_precedence = 1;
		}
		else if ([string isEqualToString:@"*"])
		{
			_type = TermOperator;
			_operatorType = OperatorMultiplication;
			_precedence = 2;
		}
		else
		{
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			NSNumber *number = [formatter numberFromString:string];
			if (!!number)
			{
				_type = TermOperand;
				_value = [string intValue];
			}
			else
			{
				@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Unknown dice roll expression." userInfo:nil];
			}
		}
	}
	
	return self;
}

- (id)initAsResultOfOperation:(DiceNotationTerm*)operatorTerm onOperands:(DiceNotationTerm*)operandA and:(DiceNotationTerm*)operandB
{
	if (operatorTerm.type != TermOperator)
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Term passed in as operator is not a valid operator." userInfo:nil];
	
	if ((operandA.type != TermOperand) && (operandA.type != TermResult))
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Term passed in as operand is not a valid operand." userInfo:nil];
	
	if ((operandB.type != TermOperand) && (operandB.type != TermResult))
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Term passed in as operand is not a valid operand." userInfo:nil];
	
	self = [super init];
	
	if (self)
	{
		_type = TermResult;
		_operatorType = OperatorNone;
		_precedence = 0;
		
		switch (operatorTerm.operatorType)
		{
			case OperatorRoll:
				_value = [Dice roll:operandA.value d:operandB.value];
				break;
				
			case OperatorAddition:
				_value = operandA.value + operandB.value;
				break;
				
			case OperatorSubtraction:
				_value = operandA.value - operandB.value;
				break;
				
			case OperatorMultiplication:
				_value = operandA.value * operandB.value;
				break;
				
			default:
				@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid operator." userInfo:nil];
		}
	}
	
	return self;
}

- (NSString *)debugDescription
{
	switch (_type)
	{
		case TermOperand:
			return [NSString stringWithFormat:@"%d", _value];
			
		case TermLeftParenthesis:
			return @"Left Parenthesis";
			
		case TermRightParenthesis:
			return @"Right Parenthesis";
			
		case TermOperator:
		{
			switch (_operatorType)
			{
				case OperatorRoll:
					return @"Operator d";
					
				case OperatorAddition:
					return @"Operator +";
					
				case OperatorSubtraction:
					return @"Operator -";
					
				case OperatorMultiplication:
					return @"Operator *";
					
				default:
					return [super debugDescription];
			}
			
			break;
		}
			
		default:
			return [super debugDescription];
	}
}

@end
