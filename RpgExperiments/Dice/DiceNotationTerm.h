//
//  DiceNotationTerm.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 21.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	TermNone,
	TermResult,
	TermOperand,
	TermLeftParenthesis,
	TermRightParenthesis,
	TermOperator
} TermType;

typedef enum
{
	OperatorNone,
	OperatorRoll,
	OperatorAddition,
	OperatorSubtraction,
	OperatorMultiplication,
} OperatorType;

@interface DiceNotationTerm : NSObject

@property (nonatomic, readonly) TermType type;
@property (nonatomic, readonly) int value;
@property (nonatomic, readonly) OperatorType operatorType;
@property (nonatomic, readonly) int precedence;

- (id)initWithString:(NSString*)string;
- (id)initAsResultOfOperation:(DiceNotationTerm*)operatorTerm onOperands:(DiceNotationTerm*)operandA and:(DiceNotationTerm*)operandB;

@end
